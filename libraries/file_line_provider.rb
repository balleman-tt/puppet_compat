#
# Cookbook:: puppet_compat
# Library:: file_line_provider
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

class Chef
  class Provider
    class FileLine < Chef::Provider
      def load_current_resource
        @current_resource ||= Chef::Resource::FileLine.new(@new_resource.name)
        @match_regex = @new_resource.match.nil? ? nil : Regexp.new(@new_resource.match)
        @after_regex = @new_resource.after.nil? ? nil : Regexp.new(@new_resource.after)
        @match_count = 0
        @after_count = 0
        @line_count = 0
        Chef::Application.fatal!("File #{@new_resource.path} should exists", 2) unless ::File.exist?(@new_resource.path)
        @lines ||= ::File.readlines(@new_resource.path, encoding: @new_resource.encoding)
        @lines.each do |line|
          l = line.delete("\n")
          @match_count += 1 if !@match_regex.nil? && @match_regex.match(l) && l != @new_resource.line
          @after_count += 1 if !@after_regex.nil? && @after_regex.match(l)
          @line_count += 1 if l == @new_resource.line
        end
        if (@match_count > 1 || @after_count > 1) && !@new_resource.multiple
          Chef::Application.fatal!("More than one line in file '#{@new_resource.path}' matches pattern '#{@new_resource.match}'", 2)
        end
        @current_resource
      end

      # The set action
      #
      def action_ensure
        converge_by("File_line adds line '#{new_resource.line}'") do
          ::File.open(new_resource.path, 'w') do |fh|
            @lines.each_with_index do |l, idx|
              if !@match_regex.nil? && @match_regex.match(l)
                fh.puts(new_resource.line)
                @line_count += 1
              else
                fh.puts(l)
              end
              next if @after_regex.nil?
              if @after_regex.match(l) && @lines[idx + 1].chomp != new_resource.line
                fh.puts(new_resource.line)
                @line_count += 1
              end
            end
            fh.puts(new_resource.line) if @line_count == 0
          end
        end if (@match_count > 0 && new_resource.replace) || @after_count > @line_count || @line_count == 0
      end

      # The delete action
      #
      def action_delete
        if new_resource.match_for_absence && @match_count > 0
          converge_by("Destroyed lines matching '#{new_resource.match}'") do
            ::File.open(new_resource.path, 'w') do |fh|
              fh.write(@lines.reject { |l| @match_regex.match(l) }.join(''))
            end
          end
        elsif @line_count > 0
          converge_by("Destroyed lines == '#{new_resource.line}'") do
            ::File.open(new_resource.path, 'w') do |fh|
              fh.write(@lines.reject { |l| l.chomp == new_resource.line }.join(''))
            end
          end
        end
      end
    end
  end
end
# vim:ts=2:sw=2:expandtab
