FROM ruby:2.5.8-alpine3.11

ENV LANG C.UTF-8

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm && \
apk add --update --no-cache nodejs sqlite-libs tzdata git && \
gem install bundler -v 2.2.4 && \
npm -g install yarn
