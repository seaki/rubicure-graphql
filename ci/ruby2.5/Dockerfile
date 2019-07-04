FROM ruby:2.5.5-alpine3.9

ENV LANG C.UTF-8

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm && \
apk add --update --no-cache nodejs sqlite-libs tzdata && \
npm -g install yarn
