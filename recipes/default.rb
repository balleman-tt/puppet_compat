#
# Cookbook:: puppet_compat
# Recipe:: default
#
# Copyright:: 2017, Stanislav Voroniy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
chef_gem 'iniparse' do
  version node['iniparse']['gem_version'] if node['iniparse']['gem_version'] != 'latest'
  compile_time true
  clear_sources true if node['iniparse']['gem_source']
  source node['iniparse']['gem_source'] if node['iniparse']['gem_source']
  action :install
end
