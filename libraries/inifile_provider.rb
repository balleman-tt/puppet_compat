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
      def set_one(ini, section, setting, value)
        if ini.has_section?(section) && ini[section].has_option?(setting) && ini[section][setting] == value
          Chef::Log.debug "Option '#{section}/#{setting}' == '#{value}', not setting..."
          false
        else
          old_value = if ini.has_section?(section) && ini[section].has_option?(setting)
                        ini[section][setting]
                      else
                        'unset'
                      end
          converge_by("Set '#{setting}' in section '#{section}' of '#{@new_resource.path}' file to '#{value}', was '#{old_value}'") do
            ini.section(section) unless ini.has_section?(section)
            ini[section][setting] = value
            ini[section].option(setting).instance_variable_set(:@option_sep, @new_resource.separator) unless @new_resource.separator.nil?
          end
          true
        end
      end

      def action_ensure
        ini = IniParse.open(new_resource.path)
        updated = false
        if new_resource.section.is_a?(Hash)
          Chef::Application.fatal!("If options 'section' is a hash options 'setting'/'value' are may not be used", 2) unless new_resource.setting.nil? && new_resource.value.nil?
          new_resource.section.each do |sect, settings|
            Chef::Application.fatal!("Option 'section' must be a hash of hashes", 2) unless settings.is_a?(Hash)
            settings.each do |setting, value|
              updated = set_one(ini, sect, setting, value)
            end
          end
        else
          Chef::Application.fatal!("Option 'section' must be a hash or a string", 2) if new_resource.section.is_a?(Array)
          section = if new_resource.section.nil? || new_resource.section.empty?
                      '__anonymous__'
                    else
                      new_resource.section
                    end
          if new_resource.setting.is_a?(Hash)
            new_resource.setting.each do |setting, value|
              updated = set_one(ini, section, setting, value)
            end
          else
            Chef::Application.fatal!("Option 'setting' must be a hash or a string", 2) if new_resource.setting.is_a?(Array)
            Chef::Application.fatal!("Option 'setting' may not be empty", 2) if new_resource.setting.nil? || new_resource.setting.empty?
            Chef::Application.fatal!("Option 'value' must be present", 2) if new_resource.value.nil?
            updated = set_one(ini, section, new_resource.setting, new_resource.value)
          end
        end
        ini.save(new_resource.path) if updated
      end

      # The delete action
      #
      def delete_section(ini, section)
        if ini.has_section?(section)
          converge_by("Remove section '#{section}' from '#{@new_resource.path}' file") do
            ini.delete(section)
          end
          true
        else
          Chef::Log.debug "Section '#{section}' not present in file '#{@new_resource.path}', skipping..."
          false
        end
      end

      def delete_setting(ini, section, setting)
        if ini[section].has_option?(setting)
          converge_by("Remove option '#{setting}' from section '#{section}' of '#{@new_resource.path}' file") do
            ini[section].delete(setting)
          end
          true
        else
          Chef::Log.debug "Section '#{section}' in file '#{@new_resource.path}' has no setting '#{setting}', skipping..."
          false
        end
      end

      def action_delete
        ini = IniParse.open(new_resource.path)
        updated = false
        if new_resource.section.is_a?(Hash)
          new_resource.section.each do |sect, settings|
            Chef::Application.fatal!("Option 'section' must be a hash of arrays", 2) unless settings.is_a?(Array)
            settings.each do |setting|
              updated = delete_setting(ini, sect, setting)
            end
          end
        elsif new_resource.section.is_a?(Array)
          Chef::Application.fatal!("If option 'section' is an array option 'setting' may not be defined", 2) unless new_resource.setting.nil?
          new_resource.section.each do |section|
            updated = delete_section(ini, section)
          end
        elsif new_resource.setting.nil?
          updated = delete_section(ini, new_resource.section)
        elsif new_resource.setting.is_a?(Hash)
          Chef::Application.fatal!("Option 'setting' must be an array", 2)
        elsif new_resource.setting.is_a?(Array)
          new_resource.setting.each do |setting|
            updated = delete_setting(ini, new_resource.section, setting)
          end
        else
          Chef::Application.fatal!("Option 'setting' may not be empty", 2) if new_resource.setting.empty?
          updated = delete_setting(ini, new_resource.section, new_resource.setting)
        end
        ini.save(new_resource.path) if updated
      end
    end
  end
end
# vim:ts=2:sw=2:expandtab
