FROM ruby:2.5-alpine

ENV LANG C.UTF-8
ENV APP_ROOT /usr/src/rubicure-graphql

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

RUN apk update
RUN apk upgrade
RUN apk add --update --no-cache --virtual=build-dependencies build-base sqlite-dev npm
RUN apk add --update --no-cache nodejs sqlite-libs tzdata

RUN npm -g install yarn

ADD Gemfile      ${APP_ROOT}/Gemfile
ADD Gemfile.lock ${APP_ROOT}/Gemfile.lock

RUN bundle install -j4
RUN yarn install

RUN apk del build-dependencies

ADD . ${APP_ROOT}

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
