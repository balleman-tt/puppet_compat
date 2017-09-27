#
# Cookbook:: puppet_compat
# Library:: matchers
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
if defined?(ChefSpec)
  ChefSpec.define_matcher :ini_setting

  def ensure_ini_setting(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ini_setting, :set, resource_name)
  end

  def delete_ini_setting(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ini_setting, :delete, resource_name)
  end

  ChefSpec.define_matcher :file_line

  def ensure_file_line(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:file_line, :set, resource_name)
  end

  def delete_file_line(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:file_line, :delete, resource_name)
  end
end
# vim:ts=2:sw=2:expandtab
