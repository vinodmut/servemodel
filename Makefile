DOCKER_NS ?= vinodmut
IMAGE_NAME ?= servecaffe

MODELS_DIR ?= models

# Build the Docker image.
build: $(MODELS_DIR)
	docker build -t $(IMAGE_NAME) .

# Download SqueezeNet model and ImageNet synset.
$(MODELS_DIR):
	wget -qP $(MODELS_DIR) https://raw.githubusercontent.com/DeepScale/SqueezeNet/master/SqueezeNet_v1.0/deploy.prototxt
	wget -qP $(MODELS_DIR) https://github.com/DeepScale/SqueezeNet/raw/master/SqueezeNet_v1.0/squeezenet_v1.0.caffemodel
	wget -qP $(MODELS_DIR) https://raw.githubusercontent.com/sh1r0/caffe-android-demo/master/app/src/main/assets/synset_words.txt


push:
	docker tag $(IMAGE_NAME) $(DOCKER_NS)/$(IMAGE_NAME)
	docker push $(DOCKER_NS)/$(IMAGE_NAME)

create-action:
	@#Note the `-m 512` argument increases the memory limit for the action to 512 MB from the default 256 MB.
	wsk action update -m 512 -t 120000 servecaffe --docker $(DOCKER_NS)/$(IMAGE_NAME)

clean:
	rm -rf $(MODELS_DIR)

.PHONY: build push clean

