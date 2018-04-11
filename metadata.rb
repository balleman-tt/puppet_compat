name 'puppet_compat'
maintainer 'Stanislav Voroniy'
maintainer_email 'stas@voroniy.com'
license 'Apache-2.0'
description 'HWRP for ini_setting and file_line resources'
long_description 'Creates puppet-like resource ini_setting and file_line for easier migration'
version '1.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
issues_url 'https://github.com/voroniys/puppet_compat/issues'
source_url 'https://github.com/voroniys/puppet_compat'
%w( centos debian fedora redhat ubuntu ).each do |os|
  supports os
end
