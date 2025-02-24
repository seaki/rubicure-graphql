FROM ruby:3.0.6-alpine3.16

ENV LANG=C.UTF-8
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=1
ENV BUNDLE_FORCE_RUBY_PLATFORM=1

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base libxml2-dev libxslt-dev && \
apk add --update --no-cache libxml2 libxslt tzdata && \
gem install bundler -v 2.4.22
