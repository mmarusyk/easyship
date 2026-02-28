## [Unreleased]

## [v0.6.0](https://github.com/mmarusyk/easyship/tree/v0.6.0) - 2026-02-28

### Added
- Secure logging module with configurable logger support
- `NullLogger` as default (quiet by default) to avoid log pollution
- Abstract logging methods: `log_info`, `log_debug`, `log_warn`, `log_error`, `log_request`, `log_response`
- Logger configuration option to allow custom loggers (Rails.logger, custom Logger, etc.)
- Integration tests for logging functionality
- Security-first logging: no API keys, headers, or request/response bodies logged

## [v0.5.1](https://github.com/mmarusyk/easyship/tree/v0.5.1) - 2026-01-24

### Fixed
- Set SOURCE_DATE_EPOCH in Rakefile to ensure proper gem release dates are detected by Ruby Toolbox

## [v0.5.0](https://github.com/mmarusyk/easyship/tree/v0.5.0) - 2026-01-24

### Added
- Ruby 4.0 support

### Changed
- **BREAKING**: Minimum Ruby version increased from 3.0.0 to 3.2.0


### Fixed
- Updated unicode-emoji to 4.2.0 for Ruby 4.0 compatibility

## [v0.4.0](https://github.com/mmarusyk/easyship/tree/v0.4.0) - 2026-01-24

### Added
- Support for custom headers by @mmarusyk in https://github.com/mmarusyk/easyship/pull/14


## [v0.3.0](https://github.com/mmarusyk/easyship/tree/v0.3.0) - 2025-11-29

### Added
- Rate limiting for cursor by @mmarusyk in https://github.com/mmarusyk/easyship/pull/13


## [v0.2.0](https://github.com/mmarusyk/easyship/tree/v0.2.0) - 2025-05-04

### Added
- Add response_body and response_header to Easyship::Error
- Deprecate body_error by @mmarusyk in https://github.com/mmarusyk/easyship/pull/9
- Add badges by @mmarusyk in https://github.com/mmarusyk/easyship/pull/10


## [v0.1.5](https://github.com/mmarusyk/easyship/tree/v0.1.5) - 2025-05-03

### Fixed
- update docs by @troyizzle in https://github.com/mmarusyk/easyship/pull/5
- Add test coverage by @mmarusyk in https://github.com/mmarusyk/easyship/pull/6
- Automate release by @mmarusyk in https://github.com/mmarusyk/easyship/pull/7

## [v0.1.4](https://github.com/mmarusyk/easyship/tree/v0.1.4) - 2024-10-16

### Fixed
- Handle JSON::Parser Error

## [v0.1.3](https://github.com/mmarusyk/easyship/tree/v0.1.3) - 2024-06-27

### Fixed
- Error from v1 is not handled by @mmarusyk

## [v0.1.2](https://github.com/mmarusyk/easyship/tree/v0.1.2) - 2024-06-24

### Features
- Handle Handle different responses of errors from Easyship (v1, v2,...) by @mmarusyk in https://github.com/mmarusyk/easyship/pull/3

### Fixed
- Updated README.md by @mmarusyk in https://github.com/mmarusyk/easyship/pull/2


## [v0.1.1](https://github.com/mmarusyk/easyship/tree/v0.1.1) - 2024-06-08

### Features
- Add pagination cursor by @mmarusyk in https://github.com/mmarusyk/easyship/pull/1


## [v0.1.0](https://github.com/mmarusyk/easyship/tree/v0.1.0) - 2024-06-08

- Initial release
