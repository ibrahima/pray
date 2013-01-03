bundle install --path vendor/bundle

mkdir -p tmp/pids
mkdir tmp/sockets

bundle exec puma --config config/puma.rb