require 'serverspec'

set :backend, :exec

context 'commands' do
  describe command('ldapsearch -x -b "dc=example, dc=com" uid=johnls') do
    its(:stdout) { is_expected.to match /result: 0 Success/ }
  end
end
