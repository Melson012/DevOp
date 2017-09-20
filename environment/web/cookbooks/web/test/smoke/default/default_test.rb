# # encoding: utf-8

# Inspec test for recipe web::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

describe package 'nginx' do
    it { should be_installed }
end

describe service 'nginx' do
    it { should be_running }
    it { should be_enabled }
end


# This is an example test, replace it with your own test.
describe port(80) do
  it { should be_listening }
end

describe package 'nodejs' do
	it {should be_installed}
	its('version') {should match /6\../}
end

describe npm('pm2') do
	it {should be_installed}
end