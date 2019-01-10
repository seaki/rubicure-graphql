# Rubicure-graphql

Rubicure-graphql is Precure, Japanese battle heroine "Pretty Cure (Precure)" GraphQL implementation based on Rubicure gem.

## Requirements

* ruby >= 2.4.4

* rails >= 5.2.1

## Dependencies

* rubicure >= 1.1.7

## How to deploy

### Using docker-compose

```
$ docker-compose build
$ docker-compose run --rm app bundle install
$ docker-compose run --rm app yarn install
```

### Deploy to heroku

With Heroku CLI

```
$ heroku login
$ heroku create
$ git push heroku master
```

## How to use

Call from your GraphQL client. For your convenient, this app including rails-graphiql, access http(s)://(hostname):(port)/graphiql to try API in GraphiQL.
