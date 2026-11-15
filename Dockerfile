FROM ruby:2.7.8-alpine3.16

ENV LANG=C.UTF-8
ENV APP_ROOT=/usr/src/rubicure-graphql
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=1
ENV BUNDLE_FORCE_RUBY_PLATFORM=1

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

ADD Gemfile      ${APP_ROOT}/Gemfile
ADD Gemfile.lock ${APP_ROOT}/Gemfile.lock

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base libxml2-dev libxslt-dev yaml-dev && \
apk add --update --no-cache libxml2 libxslt tzdata && \
gem install bundler -v 2.4.22 && \
bundle install && \
apk del build-dependencies

ADD . ${APP_ROOT}

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
