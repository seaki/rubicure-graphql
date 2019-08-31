FROM ruby:2.3.8-alpine3.8

ENV LANG C.UTF-8

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm linux-headers && \
apk add --update --no-cache nodejs sqlite-libs tzdata && \
npm -g install yarn
