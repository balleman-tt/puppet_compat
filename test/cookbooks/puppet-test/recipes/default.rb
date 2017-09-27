include_recipe 'puppet_compat'
# place test files
%w(cfg ini).each do |ext|
  cookbook_file "/tmp/test.#{ext}" do
    mode 0666
    source "test.#{ext}"
  end
end
# tests for file_line
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
end
file_line 'Change one line with match' do
  path   '/tmp/test.cfg'
  match  '^tochange'
  line   'tochange: changed'
end
# tests for ini_setting
ini_setting 'Set option' do
  path      '/tmp/test.ini'
  section   'test'
  setting   'option_add'
  value     'added'
  separator '='
end
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
  section   'del'
  action    :delete
end
