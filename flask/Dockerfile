FROM alpine:3.7
RUN apk add --update \
    python \
    py-pip \
  && rm -rf /var/cache/apk/*

WORKDIR /app

ADD app/requirements.txt /app/
RUN pip install -r /app/requirements.txt

ADD app /app
ENTRYPOINT ["gunicorn", "-w 4", "-b 0.0.0.0:80", "echo:app"]
