[![Build Status](https://travis-ci.org/voroniys/puppet_compat.svg?branch=master)](https://travis-ci.org/voroniys/puppet_compat)

# puppet_compat Cookbook

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

## License & Authors

- Author:: Stanislav Voroniy ([stas@voroniy.com](mailto:stas@voroniy.com))
```text
Copyright 2017, Stanislav Voroniy

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
