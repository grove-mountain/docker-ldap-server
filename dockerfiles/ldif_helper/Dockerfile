FROM python:alpine

RUN pip --no-cache-dir install pyyaml jinja2 \
  && mkdir /app

WORKDIR /app

COPY create_ldif.py .

ENTRYPOINT ["/usr/local/bin/python", "create_ldif.py"]
