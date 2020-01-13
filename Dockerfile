FROM ubuntu:16.04

RUN export RUBY_GC_STATS=1

RUN apt-get update\
  && apt-get install -y wget build-essential libyaml-dev zlib1g-dev libreadline-gplv2-dev libssl-dev libffi-dev\
  && wget http://ftp.ruby-lang.org/pub/ruby/2.4/ruby-2.4.4.tar.gz\
  && tar xvzf ruby-2.4.4.tar.gz\
  && cd ruby-2.4.4\
  && ./configure --prefix=/usr/local --disable-install-doc --enable-load-relative --enable-shared\
  && make\
  && make install\
  && gem install bundler -v 1.16.5 --no-rdoc --no-ri\
  && apt-get install -y git-core libxml2-dev libxslt1-dev libmagickwand-dev libsqlite3-dev libmysqlclient-dev yasm vim curl imagemagick tzdata\
  && apt-get install -y openssh-server\
  && apt-get install -y libreoffice \
  && mkdir /webapp && mkdir -p /usr/local/src\
  && mkdir -p /var/run/sshd\
  && rm -rf /ruby-2.4.4 /ruby-2.4.4.tar.gz

RUN apt-get install -y netcat

RUN mkdir /rabbit
WORKDIR /rabbit

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

RUN bundle install

RUN gem env
