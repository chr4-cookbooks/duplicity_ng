case node['platform']
when "redhat", "centos", "amazon", "oracle"
  default['duplicity_ng']['install_method'] = "package" # Can be "source" or "package"
  default['duplicity_ng']['rpm']['checksum'] = "e89c866b6f3fb0be6b84637cb9d09af5"
  default['duplicity_ng']['rpm']['url'] = "https://launchpad.net/duplicity/0.6-series/0.6.24/+download/duplicity-0.6.24-0.fdr.6.i386.rpm"
end
