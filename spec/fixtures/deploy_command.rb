ruby_version = 'ruby-1.8.6'
rubygems_version = '1.3.5'
home_dir = '/home/sous_chef'

halt_on_failed_command

log do
  stdout "/root/stdout.log"
  stderr "/root/stderr.log"
end

file "/root/report.log" do
  action :delete
end

def report(message)
  command "echo '#{escape_string(message)}' >> /root/report.log"
end

file "/etc/config.yml" do
  content node[:config].to_yaml
  mode 0600
end

execute 'rvm' do
  report "Installing ruby version manager"
  creates "/usr/local/rvm/scripts/rvm"
  command "gem install rvm && rvm-install"
end

execute "source rvm" do
  command <<-EOS
RUBYOPT=""
source /usr/local/rvm/scripts/rvm
  EOS
end

file "/etc/profile.d/rvm.sh" do
  debugger
  echo "Setting up rvm source"
  content <<-EOS
# rvm configuration
RUBYOPT=""
if [[ -s /usr/local/rvm/scripts/rvm ]] ; then source /usr/local/rvm/scripts/rvm ; fi
  EOS
end

echo 'installing ruby'

execute 'install ruby' do
  command %{rvm install #{ruby_version}}
  not_if "rvm list | grep #{ruby_version}"
end

execute 'use ruby' do
  command "rvm use #{ruby_version}"
end

execute 'update rubygems' do
  report "upgrading rubygems"
  command <<-EOS
gem uninstall rubygems-update
gem install rubygems-update -v #{rubygems_version} --no-ri --no-rdoc
update_rubygems
gem uninstall rubygems-update
  EOS
  not_if "gem -v | grep #{rubygems_version}"
end

directory home_dir do
  mode 0755
end

gemfile home_dir do
  source "http://gemcutter.org/"

  gem 'chef'
  gem 'dbi',          '0.4.3'
  gem 'dbd-mysql',    '0.4.3'
  gem 'open4',        '0.9.6'
end

execute 'install bundler' do
  command "gem install bundler --no-ri --no-rdoc"
end

execute 'bundle gems' do
  cwd home_dir
  command "gem bundle"
end

file "/etc/profile.d/bin-path.sh" do
  echo "Setting up bin-path"
  content <<-EOS
# bundled gem bin path configuration
export PATH=#{home_dir}/bin:\$PATH
  EOS
end

execute 'run chef' do
  command "nohup #{home_dir}/bin/chef #{node[:chef_args]} &"
end
