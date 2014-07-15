# duplicity\_ng cookbook

Cookbook for installing [duplicity](http://duplicity.nongnu.org/) backup cronjobs

## Supported Platforms

All platforms with a duplicity package available, and support for `/etc/cron.*/` directories.

Tested on Ubuntu.


## Usage

### Attributes

See the `attributes/default.rb` file for default values.

* `node['duplicity_ng']['install_method']` - Install method, can be "package" or "source" (by default "package")
* `node['duplicity_ng']['bin_path']` - Path to `duplicity` binary.
* `node['duplicity_ng']['source']['checksum']` - `duplicity` remote source file checksum.
* `node['duplicity_ng']['source']['version']` - `duplicity` version (only for "source" install method)
* `node['duplicity_ng']['source']['gnupg']['checksum']` - `GnuPGInterface` remote source file checksum.
* `node['duplicity_ng']['source']['gnupg']['version']` - `GnuPGInterface` version.


### Recipes

#### default

Blank recipe

#### install

Installs main packages

#### install_swift

Installs `python-swiftclient` package

#### install_boto

Installs python `boto` package

#### install_ftp

Installs `ncftp` package

#### install_ppa

Ubuntu repositories with latest version of `duplicity`.


### Providers

To use the providers, append the following to your metadata.rb

```ruby
depends 'duplicity_ng'
```

#### duplicity_ng\_cronjob

Installs a duplicity cronjob

```ruby
duplicity_ng_cronjob 'myduplicity' do
  name 'myduplicity' # Cronjob filename (name_attribute)

  # Attributes for the default cronjob template
  interval         'daily'              # Cron interval (hourly, daily, monthly)
  duplicity_path   '/usr/bin/duplicity' # Path to duplicity
  configure_zabbix false                # Automatically configure zabbix user paremeters
  logfile          '/dev/null'          # Log cronjob output to this file

  # duplicity parameters
  backend    'ftp://server.com/folder' # Backend to use (default: nil, required!)
  passphrase 'supersecret'             # duplicity passphrase (default: nil, required!)

  include        %w(/etc/ /root/ /var/log/) # Default directories to backup
  exclude        %w()                       # Default directories to exclude from backup
  archive_dir    '/tmp/duplicity-archive'   # duplicity archive directory
  temp_dir       '/tmp/duplicity-tmp'       # duplicity temp directory
  keep_full      5                          # Keep 5 full backups
  nice           10                         # Be nice (cpu)
  ionice         3                          # Ionice class (3 => idle)
  full_backup_if_older_than '7D'            # Take a full backup after this interval

  # Command(s) to run at the very beginning of the cronjob (default: empty)
  exec_pre %(if [ -f "/nobackup" ]; then exit 0; fi)

  # Command(s) to run after cleanup, but before the backup (default: empty)
  exec_before ['pg_dumpall -U postgres |bzip2 > /tmp/dump.sql.bz2']

  # Command(s) to run after the backup has finished (default: empty)
  exec_after  ['touch /backup-sucessfull', 'echo yeeeh']

  # In case you use Swift as you backend, specify the credentials here
  swift_username 'mySwiftUsername'
  swift_password 'mySwiftPassword'
  swift_authurl  'SwiftAuthURL'

  # In case you use S3 as your backend, your credentials go here
  aws_access_key_id     'MY_ACCESS_ID'
  aws_secret_access_key 'MY_SECRET'

  # Alternatively, you can specify your own template to use
  cookbook         'duplicity_ng'          # Cookbook to take erb template from
  source           'cronjob.sh.erb'     # ERB template to use
  variables        {}                   # Custom variables for ERB template
end
```


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request


## License and Authors

Author:: Chris Aumann (<me@chr4.org>)
