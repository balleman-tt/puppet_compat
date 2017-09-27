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
  its(['test']) { should be_present }
  its(%w(test option_add)) { should eq 'added' }
  its(%w(test option_one)) { should eq 'will_stay' }
  its(%w(test option_chg)) { should eq 'nice' }
  its(%w(test option_two)) { should_not be_present }
end
