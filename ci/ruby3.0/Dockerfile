FROM ruby:3.0.0-alpine3.12

ENV LANG C.UTF-8

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm gmp-dev && \
apk add --update --no-cache nodejs sqlite-libs tzdata && \
gem install bundler -v 2.1.3 && \
npm -g install yarn
