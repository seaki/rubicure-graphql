FROM ruby:3.2.6-alpine3.19

ENV LANG C.UTF-8
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base && \
apk add --update --no-cache tzdata && \
gem install bundler -v 2.4.22
