FROM ruby:2.7.8-alpine3.16

ENV LANG C.UTF-8
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base && \
apk add --update --no-cache tzdata && \
gem install bundler -v 2.4.22
