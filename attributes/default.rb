default['duplicity_ng']['install_method'] = "package" # Can be "source" or "package"
default['duplicity_ng']['bin_path'] = "/usr/bin/duplicity"
default['duplicity_ng']['source']['checksum'] = "5d4e9329a6d793880909d18b0736ff06"
default['duplicity_ng']['source']['version'] = "0.6.24"
default['duplicity_ng']['source']['url'] = "https://launchpad.net/duplicity/0.6-series/#{node['duplicity_ng']['source']['version']}/+download/duplicity-#{node['duplicity_ng']['source']['version']}.tar.gz"
default['duplicity_ng']['source']['gnupg']['version'] = "0.3.2"
default['duplicity_ng']['source']['gnupg']["url"] = "http://switch.dl.sourceforge.net/project/py-gnupg/GnuPGInterface/#{node['duplicity_ng']['source']['gnupg']['version']}/GnuPGInterface-#{node['duplicity_ng']['source']['gnupg']['version']}.tar.gz"
default['duplicity_ng']['source']['gnupg']["checksum"] = "d4627d83446f96bd8c22f8d15db3f7c2"

case node['platform_family']
when "debian"
  default['duplicity_ng']['source']['dev']['packages'] = ["librsync-dev"]
  default['duplicity_ng']['source']['python']['packages'] = ["python-dev", "python-lockfile", "python-gnupginterface", "python-paramiko"]
when "rhel", "fedora", "suse"
  default['duplicity_ng']['install_method'] = "source"
  default['duplicity_ng']['source']["dev"]['packages'] = ["librsync-devel"]
  default['duplicity_ng']['source']["python"]['packages'] = ["python-devel", "python-lockfile", "python-GnuPGInterface", "python-paramiko"]
end
