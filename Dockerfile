FROM docker.io/library/ubuntu:22.04

RUN apt-get update -y
RUN apt-get install -y  ruby-dev zlib1g-dev npm tmux curl vim

## to get latest node per: https://stackoverflow.com/questions/10075990/upgrading-node-js-to-latest-version
RUN npm install -g n
RUN n latest
RUN gem install bundler 

RUN mkdir /tmp/bundle.work
WORKDIR /tmp/bundle.work

COPY Gemfile Gemfile.lock minima.gemspec ./
RUN bundle install

RUN git config --global --add safe.directory /site

WORKDIR /site
CMD ["./serve.bash"]
