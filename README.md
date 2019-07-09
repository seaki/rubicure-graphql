# Rubicure-graphql

Rubicure-graphql is Precure, Japanese battle heroine "Pretty Cure (Precure)" GraphQL implementation based on [Rubicure gem](https://rubygems.org/gems/rubicure).

## Requirements

* ruby >= 2.3.0

* rails >= 5.2.2

* rubicure >= 1.2.1

## How to deploy

### Using docker-compose

```
$ docker-compose build
$ docker-compose run --rm web bundle install
$ docker-compose up -d
```

You have to set environment values if running in production env.

```
RAILS_ENV=production
SECRET_KEY_BASE=(generate with `docker-compose run --rm app rails secret`)
RAILS_SERVE_STATIC_FILES=true (or enabled)
```

### Deploy to heroku

With Heroku CLI

```
$ heroku login
$ heroku create
$ git push heroku master
```

### Deploy to Elastic Beanstalk

With EB CLI (using mini/eb-cli Docker image)
If you have EB CLI natively, feel free to use native EB CLI.

```
$ docker run --rm -it -v $HOME/.aws/:/home/aws/.aws -v $PWD:/data mini/eb-cli init
  ( answer some questions )
$ docker run --rm -it -v $HOME/.aws/:/home/aws/.aws -v $PWD:/data mini/eb-cli deploy
```

You have to set environment values if running in production env.

```
RAILS_ENV=production
RAILS_SERVE_STATIC_FILES=true (or enabled)
RAILS_SKIP_MIGRATIONS=true
SECRET_KEY_BASE=(generate with `rails secret` in your ruby env)
```

## How to use

Call from your GraphQL client. This app includes rails-graphiql, but disabled by default. Set ENABLE_GRAPHIQL environment value (any values are accepted), and then access http(s)://(hostname):(port)/graphiql to try API in GraphiQL.

## You can try Rubicure-graphql in GraphiQL

In Heroku

[https://rubicure-graphql.herokuapp.com/graphiql](https://rubicure-graphql.herokuapp.com/graphiql)

or AWS (Elastic Beanstalk)

[https://rubicure-graphql.aws.sastudio.jp/graphiql](#you-can-try-rubicure-graphql-in-graphiql) (Deprecated)

## How to test with head (or another) version of Rubicure gem

1. Clone this repo
2. Build your Docker image first ( docker-compose build [--no-cache] )
3. Checkout "testing_new_precure" branch
4. Fix "Gemfile" ( branch name, upstream repo )
5. Update "Gemfile.lock" by following commands:
```
$ docker-compose run --rm web bundle update --conservative rubicure
$ docker-compose run --rm web bundle install
```
6. Rebuild your Docker image ( docker-compose build )
7. Launch the development server ( docker-compose up )

## How to contribute

1. Fork this repo
2. Create your feature branch ( git checkout -b features_or_fix_or_chores_or_something/patch_name )
3. Fun with this code and commit your changes ( git commit -am "I have made some modifications" )
4. Push to your forked repo ( git push origin features_or_fix_or_chores_or_something/patch_name )
5. Create new pull request
