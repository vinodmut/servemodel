#!/usr/bin/env python

import sys
import caffe
import json
import urllib

# Set the right path to your model definition file and pretrained model weights.
# and the image you would like to classify.
MODEL_DEFINITION = '/opt/models/deploy.prototxt'
MODEL_WEIGHTS = '/opt/models/squeezenet_v1.0.caffemodel'
SYNSET_WORDS_FILE = '/opt/models/synset_words.txt'

# Parse url value from input.
try:
    url = json.loads(sys.argv[1])['url']
    print 'Using url: %s' % url
except Exception as e:
    print json.dumps({"error": 'Error parsing url value.'})
    sys.exit(0)

# Download image from url.
try:
    imagefile, _ = urllib.urlretrieve(url)
    print 'imagefile:', imagefile
except Exception as e:
    print 'Error downloading url.'
    print json.dumps({"error":"error downloading %s" % url})
    sys.exit(0)

# Classify image with Caffe.
caffe.set_mode_cpu()
net = caffe.Classifier(MODEL_DEFINITION, MODEL_WEIGHTS,
                       channel_swap=(2,1,0),
                       raw_scale=255,
                       image_dims=(256, 256))
input_image = caffe.io.load_image(imagefile)
prediction = net.predict([input_image])  # predict takes any number of images, and formats them for the Caffe net automatically
classid = prediction[0].argmax()

# Lookup labels in synset.
labels = ""
with open(SYNSET_WORDS_FILE) as fp:
    line = fp.readlines()[classid]
    labels = line.split(" ", 1)[1].strip()

# Output json object as last line. This is treated as the OpenWhisk action result.
print json.dumps({"class": classid, "labels": labels})
