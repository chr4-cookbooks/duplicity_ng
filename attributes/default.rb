default['duplicity_ng']['install_method'] = "package"
default['duplicity_ng']['source']['checksum'] = "5d4e9329a6d793880909d18b0736ff06"
default['duplicity_ng']['source']['version'] = "0.6.24"
default['duplicity_ng']['source']['url'] = "https://launchpad.net/duplicity/0.6-series/#{node['duplicity_ng']['source']['version']}/+download/duplicity-#{node['duplicity_ng']['source']['version']}.tar.gz"

case node['platform']
when "redhat", "centos", "amazon", "oracle"
  default['duplicity_ng']['install_method'] = "source" # Can be "source" or "package"
end
