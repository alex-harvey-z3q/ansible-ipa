require 'serverspec'

set :backend, :exec

context 'commands' do

  options = '+nocmd +noquestion +nocomments +nostats +noaa +noadditional +noauthority'
  refresh = 3600

  [
    ['ipa1', '10.0.0.11'],
    ['ipa2', '10.0.0.12']
  ]
  .each do |ipa, ipaddr|
    describe command("dig #{ipa}.example.com #{options}") do
      its(:stdout) { is_expected.to match /#{ipa}.example.com..*#{refresh}.*IN.*A.*#{ipaddr}/ }
    end
  end

  [
    ['_ldap._tcp', 389],
    ['_kerberos._tcp', 88],
    ['_kerberos._udp', 88],
    ['_kerberos-master._tcp', 88],
    ['_kerberos-master._udp', 88],
    ['_kpasswd._tcp', 464],
    ['_kpasswd._udp', 464],
  ]
  .each do |name, port|
    
    describe command("dig #{name}.example.com SRV #{options}") do
      its(:stdout) { is_expected.to match /#{name}.example.com..*#{refresh}.*IN.*SRV.*0 0 #{port} ipa1.example.com./ }
      its(:stdout) { is_expected.to match /#{name}.example.com..*#{refresh}.*IN.*SRV.*0 0 #{port} ipa2.example.com./ }
    end
  end
end
