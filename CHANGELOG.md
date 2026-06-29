## [Unreleased]
- URL-encode query and option values to prevent broken requests with special characters
- Fixed empty options producing `&{}` in the request URL
- Added single article lookup via `#find_article` and `ArticleResult` parser
- Added `TagResult` and `EditionResult` parser classes for tags and editions endpoints
- Parse results and return an exception based on the Guardian API response

## [0.1.4] - 2026-06-28
- Moved API key from URL query string to request header to prevent leakage in logs

## [0.1.0] - 2022-10-01

- Initial release

## [0.1.1] - 2022-10-01

- Fix dependency warnings

## [0.1.2] - 2022-10-04

- Moved options parse in their Options class
- Updated readme

## [0.1.3] - 2022-10-23

- Added Content class
- Added Helpers classes ( Generator & Util)
- Added some additional methods to Base class - search tags and editons endpoints
- Improved code coverage (Happy Paths only for now)
