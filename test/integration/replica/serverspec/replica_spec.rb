require 'serverspec'

set :backend, :exec

context 'install' do
  [
    'ipa-server',
    'ipa-client',
  ]
  .each do |pkg|
    describe package(pkg) do
      it { is_expected.to be_installed }
    end
  end
end

context 'directories' do
  [
    '/etc/ipa/',
    '/etc/pki/ca-trust/',
    '/var/lib/dirsrv/slapd-EXAMPLE-COM',
    '/var/cache/krb5rcache/',
    '/var/lib/ipa/sysrestore/',
    '/var/lib/ipa-client/sysrestore/',
  ]
  .each do |dir|
    describe file(dir) do
      it { is_expected.to be_directory }
    end
  end
end

context 'config files' do
  [
    '/etc/ipa/default.conf',
    '/etc/ipa/ca.crt',
    '/etc/httpd/conf.d/ipa.conf',
    '/etc/httpd/conf.d/ipa-rewrite.conf',
    '/etc/krb5.conf',
    '/etc/sssd/sssd.conf',
  ]
  .each do |file|
    describe file(file) do
      it { is_expected.to be_file }
    end
  end
end

context 'log files' do
  [
    '/var/log/ipareplica-install.log',
    '/var/log/ipaclient-install.log',
    '/var/log/httpd/access_log',
    '/var/log/httpd/error_log',
    '/var/log/dirsrv/slapd-EXAMPLE-COM/access',
    '/var/log/dirsrv/slapd-EXAMPLE-COM/audit',
    '/var/log/dirsrv/slapd-EXAMPLE-COM/errors',
    '/var/log/krb5kdc.log',
    '/var/log/kadmind.log',
  ]
  .each do |file|
    describe file(file) do
      it { is_expected.to be_file }
    end
  end
end

context 'ports' do
  [22, 80, 88, 389, 443, 464, 636, 749].each do |port|
    describe port(port) do
      it { is_expected.to be_listening }
    end
  end
end

context 'commands' do
  describe command('ipa-replica-manage list -p dspass12') do
    its(:stdout) { is_expected.to match /ipa1.example.com: master/ }
    its(:stdout) { is_expected.to match /ipa2.example.com: master/ }
  end

  describe command('ipa-replica-manage re-initialize --from ipa1.example.com -p dspass12') do
    its(:stdout) { is_expected.to match /Update succeeded/ }
  end
end
