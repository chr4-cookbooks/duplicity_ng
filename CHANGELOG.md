1.5.0
-----

- Install lftp when using `ftp://` backend. Duplicity changed the default backend from ncftp to lftp

1.4.0
-----

- Automatically install `python-paramiko` when using SSH backends

1.3.0
-----

- Add support for the `FTP_PASSWORD` environment variable (Thanks, Tom Ward)

1.2.6
-----

- Install `python-paramiko` packages when installing from source
- Check whether duplicity is installed in zabbix-check

1.2.5
-----

- Prevent duplicate duplicity processes using lockfiles
- Add `lockfile` attribute

1.2.4
-----

- Migrate to `zabbix_ng` cookbook

1.2.3
-----

- Fix path when compiling GPG from source
- Fix dependencies for Azure users

1.2.2
-----

- Use `senstive true` attribute for duplicity environment files, so credentials won't end up in
  Chef logs
- Fix escaping issue with `--gpg-options`

1.2.1
-----

- Add attribute to set encryption algorithms (defaults to aes256, sha512)
- Add attribute to set compression algorithm and level (defaults to bzip2, level 6)
- Add support or Microsoft Azure storage

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
