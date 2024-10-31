FROM ruby:3.2.6-alpine3.19

ENV LANG C.UTF-8
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm gmp-dev libxml2-dev libxslt-dev && \
apk add --update --no-cache nodejs sqlite-libs tzdata libxml2 libxslt && \
gem install bundler -v 2.3.6 && \
npm -g install yarn
