# Serve neural net models in an OpenWhisk action

This project demonstrates how to serve a neural net model in the cloud.

- You will build a Docker image to serve a [SqueezeNet](https://github.com/DeepScale/SqueezeNet) [Caffe](http://caffe.berkeleyvision.org/) model.
- You will deploy the Docker image on the [OpenWhisk](https://github.com/openwhisk/openwhisk) serverless platform where you can serve your model without worrying about scalability or load.

## Instructions

1. Prerequisites:
   - Install [Docker](https://docs.docker.com/engine/getstarted/step_one/).
   - Get a [Docker Hub](https://hub.docker.com/) account.
   - Sign up for a free [OpenWhisk Bluemix](https://console.ng.bluemix.net/openwhisk/) account.
   - Install the [OpenWhisk CLI](https://console.ng.bluemix.net/openwhisk/learn/cli).

1. Build the Docker image:
   ```
   $ make build
   ```

   This builds a Docker image called `servecaffe` that includes a Caffe SqueezeNet model.

1. Test the Docker image you just built by classifying an image:
   ```
   $ docker run -it servecaffe /action/exec '{"url":"http://elelur.com/data_images/mammals/elephant/elephant-03.jpg"}'
   ```

   You should see the logs of Caffe classifying an image using the SqueezeNet model. The last line of output should look like this:
   ```
   {"class":"386", "label":"African elephant, Loxodonta africana"}
   ```

1. Push the Docker image to Docker Hub and create the OpenWhisk action:
   ```
   $ env DOCKER_NS=vinodmut make push create-action
   ```
   Replace the value of `DOCKER_NS` with your Docker Hub account.


1. Invoke the OpenWhisk action and pass it the URL of an image to classify:
   ```
   $ wsk action invoke servecaffe --blocking --result --param url http://elelur.com/data_images/mammals/elephant/elephant-03.jpg
   {
      "class": "386",
      "label": "African elephant, Loxodonta africana"
   }
   ```

