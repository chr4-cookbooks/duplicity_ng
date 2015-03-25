# duplicity\_ng cookbook

Cookbook for installing [duplicity](http://duplicity.nongnu.org/) backup cronjobs

## Supported Platforms

It should work on most Linux distributions.

Tested on Ubuntu and CentOS.

Note: *On RHEL (CentOS) 5.x, make sure you have python, python::package or python::source in your run_list or include them in your wrapper cookbook. Otherwise the process may fail.*

## Usage

### Attributes

See the `attributes/default.rb` file for default values.

```ruby
# Path to duplicity executable (by default "/usr/bin/duplicity").
node['duplicity_ng']['path']

# Use pyhton pip to install duplicity dependencies (defaults to false)
node['duplicity_ng']['use_pip'] = true

# The following attributes are only used when using the "duplicity_ng::source" recipe
node['duplicity_ng']['source']['checksum'] #  duplicity remote source file checksum.
node['duplicity_ng']['source']['version']  #  duplicity version (only for "source" install method).

node['duplicity_ng']['source']['gnupg']['checksum'] #  GnuPGInterface remote source file checksum.
node['duplicity_ng']['source']['gnupg']['version']  #  GnuPGInterface version.
```

### Recipes

#### package

Install duplicity using packages provided by the system. If you need newer versions, you can include
`duplicity_ng::ppa` before running this recipe to setup the official duplicity ppa (on Ubuntu)

#### ppa

Setup Ubuntu repositories with latest version of `duplicity`.
Run this recipe before you use the `duplicity_ng::install` recipe.


### Helper recipes

These recipes you probably do not need to call manually.
The providers run them in case they are required.

#### install\_swift

Helper recipe, installs `python-swiftclient`.
Uses the system package if `node['duplicity_ng']['use_pip'] = false`, otherwise uses pip.

#### install\_boto

Helper recipe, installs `python-boto`.
Uses the system package if `node['duplicity_ng']['use_pip'] = false`, otherwise uses pip.

#### install\_azure

Helper recipe, installs MS Azure SDK on Python.
Recommended option: `default['duplicity_ng']['use_pip'] = true`
Minimum `python` version: 2.7.0.
Note: *`duplicity` works well with Azure starting from 0.7 and up versions. Use it on your own risk.*

#### install\_ftp

Helpe recipe, installs `ncftp`.



### Providers

To use the providers, append the following to your metadata.rb

```ruby
depends 'duplicity_ng'
```

#### duplicity\_ng\_cronjob

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

  # In case you use Google Cloud Storage as your backend, your credentials go here
  gs_access_key_id     'MY_ACCESS_ID'
  gs_secret_access_key 'MY_SECRET'

  # In case you use MS Azure Blob Storage as your backend, your credentials go here
  azure_account_name 'MY_ACCOUNT_NAME'
  azure_account_key  'MY_ACCOUNT_KEY'

  # Alternatively, you can specify your own template to use
  cookbook         'duplicity_ng'          # Cookbook to take erb template from
  source           'cronjob.sh.erb'     # ERB template to use
  variables        {}                   # Custom variables for ERB template
end
```

Feel free to specify additional (backend related) duplicity arguments to the backend attribute.
For example, to use europe buckets with S3, use the following

```ruby
duplicity_ng 's3 europe' do
  backend '--s3-use-new-style --s3-european-buckets s3+http://bucket[/prefix]'

  # You can also specify a specific server to use
  # backend '--s3-use-new-style --s3-european-buckets s3://server.com/bucket[/prefix]'

  # Additional configuration here, see example above
end
```

#### duplicity\_ng\_boto

Deploys boto configuration. With this you can skip keys in `cronjob` provider.

```ruby
duplicity_ng_boto 'mybotoconfig' do
  # In case you use S3, your credentials go here
  aws_access_key_id     'MY_ACCESS_ID'
  aws_secret_access_key 'MY_SECRET'

  # In case you use Google Cloud Storage, your credentials go here
  gs_access_key_id     'MY_ACCESS_ID'
  gs_secret_access_key 'MY_SECRET'

  # In case you need additional options for Boto
  options {
    debug: 0,
    num_retries: 10,
    ec2_region_name: 'us-west-1',
    autoscale_endpoint: 'autoscaling.us-west-1.amazonaws.com'
  }

  # Alternatively, you can specify your own template to use
  cookbook  'duplicity_ng' # Cookbook to take erb template from
  source    'boto.cfg.erb' # ERB template to use
  variables {}
end
```

## Checking status

Since version 1.1.2, you can run commands like `collection-status` conveniently.

```bash
# Source the configuration
. /etc/default/duplicity-$jobname   # on Debian familiy
. /etc/sysconfig/duplicity-$jobname # on RHEL familiy
. /etc/duplicity-$jobname           # On other families

$DUPLICITY_PATH collection-status $DUPLICITY_ARGUMENTS
```


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request


## License and Authors

Author: Chris Aumann <me@chr4.org>

Contributors: Alexander Merkulov <sasha@merqlove.ru>
