#!/bin/bash

## It can be only executed by root user
#if [ "`whoami`" != "root" ]; then
#  echo "Require root privilege"
#  exit 1
#fi

# Check OS type
DIST_TYPE=$(lsb_release -i | sed 's/.*\s\(.*\)$/\1/')
DIST_VER=$(lsb_release -r | sed 's/.*\s\(.*\)\.\(.*\)$/\1/')

# Ubuntu: 0
# CentOS: 1
OS_FLAG=0
case "$DIST_TYPE" in
  "Ubuntu" ) OS_FLAG=0 ;;
  # "CentOS" ) OS_FLAG=1 ;;
  * ) echo "error: Not support this OS." 1>&2
      exit 1 ;;
esac

# Install required library
echo ''
echo '############################'
echo 'Start installing required library ...'
echo '############################'
echo ''

sudo apt update
sudo apt install -y build-essential bison libyaml-dev libreadline6-dev \
  zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev libreadline-dev \
  libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev openssl \
  libbz2-dev libsqlite3-dev python3-tk tk-dev python-tk libfreetype6-dev \
  llvm libncursesw5-dev xz-utils autoconf asciidoc xmlto docbook2x make gcc


##################
# Install Git
##################
echo ''
echo '############################'
echo 'Start installing Git ...'
echo '############################'
echo ''

if [ " `which git`" != " " ]; then
  echo 'Git is already installed.'
else
#  GIT_VERSION=$(curl -sL https://github.com/git/git/releases | sed -nre 's:\s*<span class="tag-name">.*v([0-9]+\.[0-9]+\.[0-9]+)</span>:\1:p' | sort -dr | head -n 1)
#  wget https://github.com/git/git/archive/v${GIT_VERSION}.tar.gz
#  tar -zxf v${GIT_VERSION}.tar.gz
#  cd git-${GIT_VERSION}
#  make configure
#  ./configure --prefix=/usr
#  make all doc info
#  make install install-doc install-html install-info
#
#  # cleanup
#  cd ../
#  rm -rf git-${GIT_VERSION}/ v${GIT_VERSION}.tar.gz
#  unset GIT_VERSION

  sudo apt install git
fi

echo ''
echo 'Finished installing Git!'
echo ''
echo ''

##################
# Install Node.js
##################
echo ''
echo '############################'
echo 'Start installing Node.js ...'
echo '############################'
echo ''

if [ " `which node`" != " " ]; then
  echo 'Node.js is already installed.'
else
  sudo apt install -y nodejs npm
  sudo npm cache clean
  sudo npm i -g n

  sudo n lts
  sudo ln -s /usr/local/bin/node /usr/bin/node
  if [ $DISTVER -lt 18 ] ; then
    # when ubuntu version is less than 18.xx
    sudo apt --purge remove -y nodejs npm
  else
    sudo apt autoremove -y nodejs npm
  fi
fi

echo ''
echo 'Finished installing Node.js!'
echo ''
echo ''

##################
# Install Ruby
##################
echo ''
echo '############################'
echo 'Start installing Ruby ...'
echo '############################'
echo ''

if [ " `which rbenv`" != " " ]; then
  echo 'Ruby is already installed.'
else
  RBENV_PATH='~/.rbenv'
  RBBUILD_PATH="${RBENV_PATH}/plugins/ruby-build"
  if [ ! -e $RBENV_PATH ] ; then
    git clone https://github.com/sstephenson/rbenv.git RBENV_PATH
  fi
  if [ ! -e $RBBUILD_PATH ] ; then
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  fi

  # write configuration to .bashrc
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  
  # reflect configuration
  #source ~/.bashrc
#   if [ $DIST_VER -lt 18 ] ; then
#     # when ubuntu version is less than 18.xx
#     bash ~/.bashrc
#   else
#     exec $SHELL -l
#   fi
  exec $SHELL -l


  # search for latest version of ruby
  RUBY_VERSION=`rbenv install -l | grep '\s[0-9]\+\.[0-9]\+\.[0-9]\+$' | tail -n 1 | sed 's/\s//g'`

  # install ruby by rbenv
  rbenv install ${RUBY_VERSION}
  rbenv global ${RUBY_VERSION}

  # cleanup
  unset RUBY_VERSION
  unset RBENV_PATH
  unset RBBUILD_PATH
fi

echo ''
echo 'Finished installing Ruby!'
echo ''
echo ''


##################
# Install Python
##################
echo ''
echo '############################'
echo 'Start installing Python ...'
echo '############################'
echo ''

if [ " `which pyenv`" != " " ]; then
  echo 'Python is already installed.'
else
  PYENV_PATH='~/.rbenv'
  VENV_PATH="${PYENV_PATH}plugins/pyenv-virtualenv"
  if [ ! -e $PYENV_PATH ] ; then
    git clone https://github.com/yyuu/pyenv.git ~/.pyenv
  fi
  if [ ! -e $VENV_PATH ] ; then
    git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
  fi

  # write configuration to .bashrc
  echo 'export PYENV_ROOT=$HOME/.pyenv' >> ~/.bashrc
  echo 'export PATH=$PYENV_ROOT/bin:$PATH' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

  # reflect configuration
  #source ~/.bashrc
#   if [ $DIST_VER -lt 18 ] ; then
#     # when ubuntu version is less than 18.xx
#     bash ~/.bashrc
#   else
#     exec $SHELL -l
#   fi
  exec $SHELL -l

  # search for latest version of python
  PYTHON_VERSION=`pyenv install -l | grep '\s[0-9]\+\.[0-9]\+\.[0-9]\+$' | tail -n 1 | sed 's/\s//g'`

  # install python by pyenv
  pyenv install ${PYTHON_VERSION}
  pyenv global ${PYTHON_VERSION}

  # cleanup
  unset PYTHON_VERSION
  unset PYENV_PATH
  unset VENV_PATH
fi

echo ''
echo 'Finished installing Python!'
echo ''

# cleanup
unset DIST_TYPE
unset DIST_VER
unset OS_FLAG

echo 'All Done!!!!!!!!'

exit 0
