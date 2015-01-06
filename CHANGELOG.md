1.2.0
-----

- Use configuration file, so one can use credentials and arguments like temporary directories or
  backend information easily in interactive sessions (See README for details)

1.1.0
-----

- Add support for CentOS 5.x

1.0.0
-----

- Add support for Google Cloud Storage
- Add ability to install duplicity from source
- Add provider to configure boto
- Add integration tests (for install recipes)
- A lot of internal improvements and fixes

0.2.2
-----

- Fix issue with properly detecting S3 backend
  - When specifying additional arguments in front of the s3:// backend, backend dependencies weren't properly detected

0.2.1
-----

- Fix an issue with directory permissions when using `/dev/null` as logfile

0.2.0
-----

- Public release

0.1.0
-----

- Initial release of duplicity\_ng (internal)
