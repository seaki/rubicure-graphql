# Rubicure-graphql

Rubicure-graphql is Precure, Japanese battle heroine "Pretty Cure (Precure)" GraphQL implementation based on [Rubicure gem](https://rubygems.org/gems/rubicure).

## Requirements

* ruby >= 2.5.0

* rails >= 6.0.3

* rubicure >= 2.0.0

## How to hack

### Using docker without mutagen integration

* Install Docker.

* Build a image. `docker-compose build`

* Run that image. `docker-compose up -d`

* Stop server with this: `docker-compose down`

### Using docker with mutagen integration

#### Install mutagen.io beta
For macOS with Homebrew, run this command.

`$ brew install mutagen-io/mutagen/mutagen-beta`

For Windows, download assets from mutagen release page, extract it and set the PATH.

#### Running rubicure-graphql with mutagen.io

* `mutagen compose -f mutagen-compose.yml build`

* `mutagen compose -f mutagen-compose.yml up -d`

#### Stopping rubicure-graphql with mutagen.io

* `mutagen compose -f mutagen-compose.yml down`

## How to deploy

### Running on-preises with Docker and Docker Compose

Run these commands.

```
$ docker-compose build
$ docker-compose run --rm web bundle install
$ docker-compose up -d
```

You have to set environment values if you wish to run in production env. It disables built-in GraphiQL frontend.

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

Call from your GraphQL client. This app includes rails-graphiql, but disabled by default. Set ENABLE_GRAPHIQL environment variable to any value except empty, and then restart app and access http(s)://(hostname):(port)/graphiql to try API in GraphiQL.

## You can try Rubicure-graphql in GraphiQL

Heroku

[https://rubicure-graphql.herokuapp.com/graphiql](https://rubicure-graphql.herokuapp.com/graphiql)

## How to test with head (or another) version of Rubicure gem

1. Clone this repo
2. Checkout "testing_new_precure" branch
3. Build your Docker image first ( docker-compose build [--no-cache] )
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
