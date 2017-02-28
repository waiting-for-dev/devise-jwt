# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

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
