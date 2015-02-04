set -e

exec 1>/root/stdout.log 2>/root/stderr.log

if test -e /root/report.log; then
  rm /root/report.log
fi

if ! test -e /etc/config.yml; then
  cat <<'SousChefHeredoc' > /etc/config.yml
--- {}

SousChefHeredoc
fi
chmod 0600 /etc/config.yml

if ! test -e /usr/local/rvm/scripts/rvm; then
  echo 'Installing ruby version manager' >> /root/report.log
  gem install rvm && rvm-install
fi

RUBYOPT=""
source /usr/local/rvm/scripts/rvm

if ! test -e /etc/profile.d/rvm.sh; then
  echo 'Setting up rvm source'
  cat <<'SousChefHeredoc' > /etc/profile.d/rvm.sh
# rvm configuration
RUBYOPT=""
if [[ -s /usr/local/rvm/scripts/rvm ]] ; then source /usr/local/rvm/scripts/rvm ; fi

SousChefHeredoc
fi

echo 'installing ruby'

if ! rvm list | grep ruby-1.8.6; then
  rvm install ruby-1.8.6
fi

rvm use ruby-1.8.6

if ! gem -v | grep 1.3.5; then
  echo 'upgrading rubygems' >> /root/report.log
  gem uninstall rubygems-update
  gem install rubygems-update -v 1.3.5 --no-ri --no-rdoc
  update_rubygems
  gem uninstall rubygems-update
fi

mkdir -p /home/sous_chef
chmod 0755 /home/sous_chef

if ! test -e /home/sous_chef/Gemfile; then
  cat <<'SousChefHeredoc' > /home/sous_chef/Gemfile
source "http://gemcutter.org/"

gem "chef"
gem "dbd-mysql", "0.4.3"
gem "dbi",       "0.4.3"
gem "open4",     "0.9.6"
SousChefHeredoc
fi

gem install bundler --no-ri --no-rdoc

cd /home/sous_chef
gem bundle

if ! test -e /etc/profile.d/bin-path.sh; then
  echo 'Setting up bin-path'
  cat <<'SousChefHeredoc' > /etc/profile.d/bin-path.sh
# bundled gem bin path configuration
export PATH=/home/sous_chef/bin:$PATH

SousChefHeredoc
fi

nohup /home/sous_chef/bin/chef --main &
