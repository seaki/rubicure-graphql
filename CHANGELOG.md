Changelog
=========

All notable changes to this project will be documented in this file.

## [3.3.3.1] - 2024-09-24

* Fix precureAllStars without argument returns error. (#636)

## [3.3.3.0] - 2024-09-18

* Update rubicure gem to 3.3.3 (#625)

### Breaking changes :bomb:
* Migrate to Compose V2 (#630)

## [3.2.6.0] - 2024-02-03

* Update rubicure gem to 3.2.6 (#602)

## [3.2.3.1] - 2023-09-22

Cure Wing is a boy... So we

* Add Query.member
* Add Query.member.memberName
* Add Query.color.members
* Add Query.movie.members
* Add Query.series.members
* Add deprecation warnings for
    * Query.girl
    * Query.girl.girlName
    * Query.color.girls
    * Query.movie.girls
    * Query.series.girls

## [3.2.3.0] - 2023-09-16

* Update rubicure gem to 3.2.3 (#560)

## [3.2.2.0] - 2023-07-19

* Update rubicure gem to 3.2.2 (#550)

## [3.2.1.0] - 2023-06-11

* Update rubicure gem to 3.2.1 (#545)

## [3.1.5.0] - 2023-02-02

* Update rubicure gem to 3.1.5 (#526)

## [3.1.4.0] - 2022-11-22

* Update rubicure gem to 3.1.4 (#499)

## [3.1.3.0] - 2022-07-22

* Update rubicure gem to 3.1.3 (#488)

## [3.1.2.0] - 2022-07-10

* Update rubicure gem to 3.1.2 (#487)

## [3.1.1.0] - 2022-05-25

* Update rubicure gem to 3.1.1 (#481)

## [3.1.0.0] - 2022-04-24

* Update rubicure gem to 3.1.0 (#476)

## [3.0.1.0] - 2022-01-30

### New Features
* Randomized Tropical-Rouge! Precure's #transform! (a.k.a. #precure_tropical_change!) transformation message (#446)

### Others
* Update rubicure gem to 3.0.1 (#449)

## [3.0.0.0] - 2022-01-02

### Breaking changes :bomb:
* Drop support for Ruby < 2.6 (#428)

### Others
* Update rubicure gem to 3.0.0 (#428)
* Add support for Ruby 3.1 (#429)

## [2.1.4.0] - 2021-11-30

* Update rubicure gem to 2.1.4 (#417)

## [2.1.3.0] - 2021-06-21

* Update rubicure gem to 2.1.3 (#390)

## [2.1.2.0] - 2021-06-21

* Update rubicure gem to 2.1.2 (#389)

## [2.1.1.0] - 2021-04-04

* Update rubicure gem to 2.1.1 (#368)

## [2.1.0.0] - 2021-03-28

* Update rubicure gem to 2.1.0 (#364)

## [2.0.1.0] - 2021-02-14

* Update rubicure gem to 2.0.1 (#342)

## [2.0.0.0] - 2021-01-06

### Breaking changes :bomb:
* Drop support for Ruby < 2.5 (#304)

### Others
* Update rubicure gem to 2.0.0 (#299)

## [1.3.5.1] - 2020-10-28

- Fix PrecureMiracleLeap returns 64 girls, 13 girls expected (#277)

## [1.3.5.0] - 2020-10-27

- Update rubicure gem to 1.3.5

## [1.3.4.0] - 2020-08-16

- Update rubicure gem to 1.3.4

## [1.3.2.0] - 2020-03-29

- Update rubicure gem to 1.3.2
- Add sample file using mutagen.io

## [1.3.1.0] - 2020-02-23

- Update rubicure gem to 1.3.1

## [1.3.0.0] - 2020-02-23

- Change versioning semantics, major, minor, patch versions  are based on 'rubicure' gem, hotfix versions are rubicure-sinatra-graphql's patch version
- Fix current series might raise Rubicure::NotOnAirError (#175)

## [0.9.10] - 2019-08-18

- Impl. cureCosmo.extraNames
- Update rubicure to 1.2.5

## [0.9.9] - 2019-07-09

### Introduced APIs

- now
- current

### Updated APIs

- series(seriesName: "") : accepts now, current

### Other improvements and fixes

- Disable GraphiQL by default ([#73](https://github.com/seaki/rubicure-graphql/pull/73))
- Update bundled gems

## [0.9.8] - 2019-06-30

- Update rubicure to 1.2.4

## [0.9.7] - 2019-06-23

- Disable CSRF protection when request.format is JSON ([#50](https://github.com/seaki/rubicure-graphql/pull/50))
- Update rubicure to 1.2.3

## [0.9.6] - 2019-06-05

### Introduced APIs

- Girl.heisei
- Girl.reiwa
- Series.heisei
- Series.reiwa
- version

### Other improvements and fixes

- Update rubicure to 1.2.1
- Update ruby to 2.6.3

## [0.9.5] - 2019-03-21

- Fix Cirrus CI config ([fkorotkov](https://github.com/seaki/rubicure-graphql/pull/37))
- Update ruby to 2.6.2

## [0.9.4] - 2019-03-18

### Updated APIs

- Fix precureDreamStars, precureSuperStars, precureMiracleUniverse not returning right girls

### Other improvements and fixes

- Update ruby to 2.5.4
- Update gems
- Setup Cirrus CI

## [0.9.3] - 2019-03-03

- Update rubicure to 1.2.0

## [0.9.2] - 2019-01-23

- Fix deploy problems
- Update ruby to 2.5.3

## [0.9.1] - 2019-01-20

### Introduced APIs

- Movie.girls
- Girl.transformMessages
- Girl.humanTurnoverName
- Girl.attackMessages
- colors
- Series.endedDate
- Girl.pikarinJanken

### Deprecated APIs

- Girl.transformMessage

### Other improvements and fixes

- Update rubicure to 1.1.9
- Add automated test
- Fix failing deploy caused by lack of migration

## [0.9.0] - 2019-01-11

First release
