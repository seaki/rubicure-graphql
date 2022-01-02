FROM ruby:2.6.9-alpine3.15

ENV LANG C.UTF-8

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm gmp-dev && \
apk add --update --no-cache nodejs sqlite-libs tzdata && \
gem install bundler -v 2.2.22 && \
npm -g install yarn
