# puppet_compat Cookbook

[![Build Status](https://travis-ci.org/voroniys/puppet_compat.svg?branch=master)](https://travis-ci.org/voroniys/puppet_compat)
[![Cookbook Version](https://img.shields.io/cookbook/v/puppet_compat.svg)](https://supermarket.chef.io/cookbooks/puppet_compat)

While doing migration from Puppet to Chef I can easily map all Puppet resources to the Chef ones. All except two:
- file_line
- ini_setting (pe_ini_setting)

These two just don't have a counterpart in the Chef world. This cookbook provides exactly these two resources as HWRP.

## Requirements

This cookbook need iniparse GEM to be installed.

### Platforms

- Debian-family Linux Distributions
- RedHat-family Linux Distributions
- Fedora
- openSUSE

### Chef

- Chef 12.1+
- Chef 13+
- Chef 14+

### Recipes

- default 
takes care that iniparse GEM used by the HWPR is installed

## Usage

Just add to your cookbook metadata.rb
```ruby
depends 'puppet_compat'
```

and you can use file_line and ini_setting resources in you recipes.

### file_line
The file line resource has the same properties, like in puppet except it has action instead of ensure.
```ruby
file_line 'Add a line' do
  path   '/tmp/test.cfg'
  line   'line: ADD'
end

file_line 'Delete with match' do
  path   '/tmp/test.cfg'
  match  '^todelete'
  match_for_absence true
  action :delete
end

file_line 'Delete the line' do
  path   '/tmp/test.cfg'
  line   'yetanother: delete'
  action :delete
enda

file_line 'Change one line with match' do
  path   '/tmp/test.cfg'
  match  '^tochange'
  line   'tochange: changed'
end
```
### ini_setting
Usage of ini_setting is also pretty close to the Puppet one. Ensure is also replaced with action.
The only one addition - you may provide the format of parameter=value separator. 
Although it is against INI standard some software is sensitive to it, so
param=value
or
param = value
for some software packeges is important. For these non-standard following software you cat provide separator property:
```ruby
ini_setting 'Set option' do
  path      '/tmp/test.ini'
  section   'test'
  setting   'option_add'
  value     'added'
  separator '='
end
ini_setting 'Set option with spaces' do
  path      '/tmp/test.ini'
  section   'test'
  setting   'option_add'
  value     'added'
  separator ' = '
end
```
The rest of usage cases are selfexplanatory:
```ruby
ini_setting 'Delete option' do
  path      '/tmp/test.ini'
  section   'test'
  setting   'option_two'
  action :delete
end
ini_setting 'Change option' do
  path      '/tmp/test.ini'
  section   'test'
  setting   'option_chg'
  value     'nice'
end
ini_setting 'Delete section' do
  path      '/tmp/test.ini'
  section   'bad_section'
  action    :delete
end
```
Known bug - the following resource will fail if file `/tmp/test.ini` does not contain any options without a section:
```ruby
ini_setting 'Set option outside sections' do
  path      '/tmp/test.ini'
  setting   'option_add'
  value     'added'
end
```
This is caused by the bug in iniparse GEM, see:
   https://github.com/antw/iniparse/issues/20

#### ini_setting extensions
Based on practical use of the ini_setting resource I've made some extensions, which are not supported by puppet version of the resource.
This extension is useful when you need to do a number of changes in ini file. In puppet inplementation it is usualy solved by calling
`ini_settings` using `create_resources()` function. For Chef implementation I've decided to make it easy: properties `section` and `setting`
may by a hash or array.

##### set multiple setting within one section
In this case you need to pass to `setting` property the hash of key-value pairs like this one:
```ruby
default['settings_test'] = {
  'one' => 'a',
  'two' => 'b',
}
```
Property `value` should not be used in this case.

##### set multiple settings in multiple sections
In this case you need to pass to `section` property the hash, where keys are section names and values are hashes like in previous case.
For example:
```ruby
default['sections_test'] = {
  'testsec1' => {
    'set1' => 10,
    'set2' => 20,
  },
  'testsec2' => {
    'set21' => 100,
    'set22' => 200,
  },
}
```
With both methods above it is possible to change existing settings/sections or add a new ones.

##### delete multiple settings within a section
Just pass to `setting` property array with the settings names that should be deleted

##### delete multiple settings in multiple sections
In this case you need to pass to `section` property the hash, where keys are section names and values are arrays with settings names to delete.

##### delete multiple sections
Also possible. For this pass to `section` property array with section names to be deleted.

## License & Authors

- Author:: Stanislav Voroniy ([stas@voroniy.com](mailto:stas@voroniy.com))
```text
Copyright 2017-2018, Stanislav Voroniy

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
