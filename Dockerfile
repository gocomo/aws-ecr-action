FROM docker:19.03.4

RUN apk update \
  && apk upgrade \
  && apk add --no-cache --update python py-pip coreutils \
  && rm -rf /var/cache/apk/* \
  # must explicitly state version as >5.4 throws cython error
  && pip install PyYAML==5.3.1 \
  && pip install awscli \
  && apk --purge -v del py-pip

ADD entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]