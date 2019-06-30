Changelog
=========

All notable changes to this project will be documented in this file.

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
