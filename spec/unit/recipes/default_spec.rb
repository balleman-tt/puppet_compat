#
# Cookbook::puppet_compat
# Spec:: default
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

require 'spec_helper'
describe 'puppet-test::default' do
  cfg = <<-EOF
# This comment should stay
#
option: stay
todelete: true
yetanother: delete
tochange: not_changed
EOF
  ini = <<-EOF
[test]
option_one=will_stay
option_two=delete
option_chg=ugly
away1=10
away2=20
[del]
a=b
[del1]
c=d
e=f
[del2]
g=h
i=j
EOF
  before(:each) do
    allow(File).to receive(:exist?).with(anything).and_call_original
    allow(File).to receive(:exist?).with('/tmp/test.cfg').and_return true
    allow(File).to receive(:exist?).with('/tmp/test.ini').and_return true
    # allow(IO).to receive(:read).with(anything).and_call_original
    # allow(IO).to receive(:read).with('/tmp/test.cfg').and_return cfg
    # allow(IO).to receive(:read).with('/tmp/test.ini').and_return ini
  end
  context 'When all attributes are default' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    it 'installs a chef_gem iniparse' do
      expect(chef_run).to install_chef_gem('iniparse').with(version: '1.4.4')
    end
    it 'renders the files' do
      expect(chef_run).to render_file('/tmp/test.cfg')
        .with_content(cfg)
      expect(chef_run).to render_file('/tmp/test.ini')
        .with_content(ini)
    end
  end
  context 'When all gem version specification' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.normal['iniparse']['gem_version'] = '1.2.3'
      end
      runner.converge(described_recipe)
    end

    it 'installs a chef_gem iniparse' do
      expect(chef_run).to install_chef_gem('iniparse').with(version: '1.2.3')
    end
  end
end
