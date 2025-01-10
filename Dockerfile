FROM ruby:3.3.6-alpine3.19

ENV LANG C.UTF-8
ENV APP_ROOT /usr/src/rubicure-graphql
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

ADD Gemfile      ${APP_ROOT}/Gemfile
ADD Gemfile.lock ${APP_ROOT}/Gemfile.lock

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm gmp-dev libxml2-dev libxslt-dev && \
apk add --update --no-cache nodejs sqlite-libs tzdata libxml2 libxslt && \
npm -g install yarn && \
bundle config force_ruby_platform true && \
bundle install -j4 && \
yarn install && \
apk del build-dependencies

ADD . ${APP_ROOT}
RUN bin/rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
