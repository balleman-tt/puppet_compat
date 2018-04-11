# # encoding: utf-8

# Inspec test for recipe inifile::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# This is an example test, replace with your own test.
describe file('/tmp/test.cfg') do
  it { should exist }
  its('content') { should match /option: stay/ }
  its('content') { should match /tochange: changed/ }
  its('content') { should match /line: ADD/ }
  its('content') { should_not match /todelete: true/ }
  its('content') { should_not match /yetanother: delete/ }
end

describe ini('/tmp/test.ini') do
  # its('option_add') { should eq 'added' }
  its(['del']) { should_not be_present }
  its(['del1']) { should_not be_present }
  its(['del2']) { should_not be_present }
  its(['test']) { should be_present }
  its(%w(test option_add)) { should eq 'added' }
  its(%w(test option_one)) { should eq 'will_stay' }
  its(%w(test option_chg)) { should eq 'nice' }
  its(%w(test option_two)) { should_not be_present }
  its(%w(test away1)) { should_not be_present }
  its(%w(test away2)) { should_not be_present }
  its(['settings_test']) { should be_present }
  its(%w(settings_test one)) { should eq 'a' }
  its(%w(settings_test two)) { should eq 'b' }
  its(['testsec1']) { should be_present }
  its(%w(testsec1 set1)) { should eq '10' }
  its(%w(testsec1 set2)) { should eq '20' }
  its(['testsec2']) { should be_present }
  its(%w(testsec2 set21)) { should eq '100' }
  its(%w(testsec2 set22)) { should eq '200' }
end
