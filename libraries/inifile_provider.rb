#
# Cookbook:: puppet_compat
# Library:: inifile_provider
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
require 'chef/provider'
require 'iniparse'

class Chef
  class Provider
    class IniSetting < Chef::Provider
      include IniParse
      def load_current_resource
        @current_resource ||= Chef::Resource::IniSetting.new(@new_resource.name)
        Chef::Application.fatal!("File #{@new_resource.path} should exists", 2) unless ::File.exist?(@new_resource.path)
        @current_resource
      end

      # The set action
      #
      def action_ensure
        ini = IniParse.open(new_resource.path)
        updated = false
        section = if new_resource.section.nil? || new_resource.section.empty?
                    '__anonymous__'
                  else
                    new_resource.section
                  end
        setting = new_resource.setting
        value = new_resource.value
        if ini.has_section?(section) && ini[section].has_option?(setting) && ini[section][setting] == value
          Chef::Log.debug "Option '#{section}/#{setting}' == '#{value}', not setting..."
        else
          old_value = if ini.has_section?(section) && ini[section].has_option?(setting)
                        ini[section][setting]
                      else
                        'unset'
                      end
          converge_by("Set '#{setting}' in section '#{section}' of '#{new_resource.path}' file to '#{value}', was '#{old_value}'") do
            ini.section(section) unless ini.has_section?(section)
            ini[section][setting] = value
            ini[section].option(setting).instance_variable_set(:@option_sep, new_resource.separator) unless new_resource.separator.nil?
          end
          updated = true
        end
        ini.save(new_resource.path) if updated
      end

      # The delete action
      #
      def action_delete
        ini = IniParse.open(new_resource.path)
        section = new_resource.section
        setting = new_resource.setting
        updated = false
        if ini.has_section?(section)
          if setting.nil?
            converge_by("Remove section '#{section}' from '#{new_resource.path}' file") do
              ini.delete(section)
            end
            updated = true
          elsif ini[section].has_option?(setting)
            converge_by("Remove option '#{setting}' from section '#{section}' of '#{new_resource.path}' file") do
              ini[section].delete(setting)
            end
            updated = true
          else
            Chef::Log.debug "Section '#{section}' in file '#{new_resource.path}' has no setting '#{setting}', skipping..."
          end
        else
          Chef::Log.debug "Section '#{section}' not present in file '#{new_resource.path}', skipping..."
        end
        ini.save(new_resource.path) if updated
      end
    end
  end
end
# vim:ts=2:sw=2:expandtab
