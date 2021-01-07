FROM ruby:3.0.0-alpine3.12

ENV LANG C.UTF-8
ENV APP_ROOT /usr/src/rubicure-graphql

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

ADD Gemfile      ${APP_ROOT}/Gemfile
ADD Gemfile.lock ${APP_ROOT}/Gemfile.lock

RUN apk update && \
apk upgrade && \
apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm gmp-dev && \
apk add --update --no-cache nodejs sqlite-libs tzdata git && \
gem install bundler -v 2.2.4 && \
npm -g install yarn && \
bundle config force_ruby_platform true && \
bundle install -j4 && \
yarn install && \
apk del build-dependencies

ADD . ${APP_ROOT}
RUN bin/rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
