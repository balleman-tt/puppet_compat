#
# Cookbook:: puppet_compat
# Library:: file_line_resource
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
require 'chef/resource'

class Chef
  class Resource
    # Resource decleration for IniSetting resource
    class FileLine < Chef::Resource
      identity_attr :name
      def initialize(name, run_context = nil)
        super
        @resource_name = :file_line
        @action = :ensure
        @allowed_actions = [:ensure, :delete, :nothing]
        @provider = Chef::Provider::FileLine
      end

      def path(arg = nil)
        set_or_return(
          :path,
          arg,
          kind_of: String,
          required: true
        )
      end

      def match(arg = nil)
        set_or_return(:match, arg, kind_of: String)
      end

      def match_for_absence(arg = nil)
        set_or_return(:match_for_absence, arg, kind_of: [TrueClass, FalseClass], default: false)
      end

      def multiple(arg = nil)
        set_or_return(:multiple, arg, kind_of: [TrueClass, FalseClass], default: true)
      end

      def after(arg = nil)
        set_or_return(:after, arg, kind_of: String)
      end

      def line(arg = nil)
        set_or_return(:line, arg, kind_of: String)
      end

      def replace(arg = nil)
        set_or_return(:replace, arg, kind_of: [TrueClass, FalseClass], default: true)
      end

      def encoding(arg = nil)
        set_or_return(:encoding, arg, kind_of: String, default: 'UTF-8')
      end
    end
  end
end
# vim:ts=2:sw=2:expandtab
