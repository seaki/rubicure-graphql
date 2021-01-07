FROM ruby:2.7.2-alpine3.12

ENV LANG C.UTF-8

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm gmp-dev && \
apk add --update --no-cache nodejs sqlite-libs tzdata git && \
gem install bundler -v 2.2.4 && \
npm -g install yarn
