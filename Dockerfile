FROM ruby:2.4-alpine

ENV LANG C.UTF-8
ENV APP_ROOT /usr/src/rubicure-graphql

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}
ADD Gemfile      ${APP_ROOT}/Gemfile
ADD Gemfile.lock ${APP_ROOT}/Gemfile.lock

RUN apk update
# && \
RUN apk upgrade
# && \
RUN apk add --update --no-cache --virtual=.build-dependencies \
build-base \
curl-dev \
libxml2-dev \
postgresql-dev \
ruby-dev \
sqlite-dev
# && \
RUN apk add --update --no-cache \
bash \
imagemagick \
nodejs \
sqlite-libs \
tzdata
# && \
RUN bundle install -j4
# && \
#apk del .build-dependencies

ADD . ${APP_ROOT}

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
