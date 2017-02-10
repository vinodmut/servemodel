FROM kaixhin/caffe

# Action proxy
ENV FLASK_PROXY_PORT 8080
RUN pip install gevent==1.1.2 flask==0.11.1
COPY actionproxy.py /actionProxy/
CMD ["/bin/bash", "-c", "cd /actionProxy && python -u actionproxy.py"]

# Models
COPY models /opt/models

# OpenWhisk action
COPY classify.py /action/exec
