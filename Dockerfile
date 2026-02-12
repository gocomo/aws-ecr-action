FROM docker:27-cli

RUN apk update \
  && apk upgrade \
  && apk add --no-cache --update python3 py3-pip coreutils \
  && rm -rf /var/cache/apk/* \
  && pip install --break-system-packages awscli

ADD entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]