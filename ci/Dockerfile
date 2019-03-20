FROM ruby:2.6.2-alpine3.9

ENV LANG C.UTF-8

RUN apk update
RUN apk upgrade
RUN apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm gmp-dev
RUN apk add --update --no-cache nodejs sqlite-libs tzdata

RUN npm -g install yarn
