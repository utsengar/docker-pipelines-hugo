FROM alpine:3.6
MAINTAINER Karel Bemelmans <mail@karelbemelmans.com>

# Install packages needed to build
RUN apk add --update --no-cache \
    bash \
    ca-certificates \
    curl \
    python \
    py-pip \
    wget \
  && pip install --upgrade pip \
  && pip install -U awscli

# Install hugo.
ARG HUGO_VERSION=0.25.1
ARG HUGO_SHA256=fbf8ca850aaaaad331f5b40bbbe8e797115dab296a8486a53c0561f253ca7b00

# Remember sha256sum (and md5sum) expect 2 spaces in front of the filename on alpine...
RUN curl -Ls https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
       -o /tmp/hugo.tar.gz \
  && echo "${HUGO_SHA256}  /tmp/hugo.tar.gz" | sha256sum -c - \
  && tar xf /tmp/hugo.tar.gz -C /tmp \
  && mv /tmp/hugo /usr/bin/hugo \
  && rm -rf /tmp/hugo*

# Install s3_website 
RUN apk add --update --no-cache build-base openssl libffi-dev ruby ruby-dev ruby-rdoc ruby-irb
RUN apk del build-base libffi-dev openssl ruby-dev \
    && rm -rf /var/cache/apk/*
RUN gem install s3_website

RUN apk --update add openjdk7-jre
CMD ["/usr/bin/java", "-version"]