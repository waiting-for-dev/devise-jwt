# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.7.0] - 2020-06-03
### Fixed
- Replace whitelist/blacklist terminology with allowlist/denylist

## [0.6.0] - 2019-08-01
### Fixed
- Update warden-jwt_auth dependency to v0.4.0 so that now it is possible to configure algorithm.

## [0.5.9] - 2019-03-29
### Fixed
- Update dependencies.

## [0.5.8] - 2018-09-07
### Fixed
- Fix test helper to persist whitelisted tokens.

## [0.5.7] - 2018-06-22
### Added
- Use `primary_key` instead of `id` to fetch resource.

## [0.5.6] - 2018-02-22
### Fixed
- Work with more than one `sign_out_via` configured

## [0.5.5] - 2018-01-30
### Fixed
- Update `warden-jwt_auth` dependency to reenable JWT scopes being stored to
  the session and inform the user.

## [0.5.4] - 2018-01-09
### Fixed
- Update `warden-jwt_auth` dependency to allow a JWT scope to be fetched from
  session in a standard AJAX request

## [0.5.3] - 2017-12-31
### Fixed
- Do not crash for consecutive revocations of same token in blacklist &
  whitelist strategies
- Update `warden-jwt_auth` dependency to allow a JWT scope to be fetched from
  session in a html request

## [0.5.2] - 2017-12-23
### Added
- Added a test helper to authenticate request headers

## [0.5.1] - 2017-12-11
### Added
- Update `warden-jwt_auth` dependency to ensure JWT scopes are not fetched from
  session

## [0.5.0] - 2017-12-11
### Added
- Added whitelist strategy
- Update `warden-jwt_auth` dependency

## [0.4.4] - 2017-12-04
### Fixed
- Configure classes as strings to avoid problems with Rails STI

## [0.4.3] - 2017-11-23
### Fixed
- Return `nil` and not raise when user is not found in model

## [0.4.2] - 2017-11-21
### Fixed
- Update `warden-jwt_auth` dependency

## [0.4.1] - 2017-10-03
### Fixed
- Do not generate double slash paths when one segment is blank

## [0.4.0] - 2017-08-07

### Added
- Store `exp` in the blacklist strategy to easy cleaning tasks

## [0.3.0] - 2017-06-07
### Fixed
- Allow configuring request formats to take into account through
  `request_formats` configuration option

## [0.2.1] - 2017-04-13
### Fixed
- Ignore expired token revocation

## [0.2.0] - 2017-02-28
### Added
- Dispatch token on sign up
- Speed up initialization

### Fixed
- Do not depend on assumed helpers to build default paths
- Use `sign_out_via` devise option to set revocation request methods
- Take routes with scopes into account

## [0.1.1] - 2017-01-26
### Fixed
- Request method configuration for Rails < 5
