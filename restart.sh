export RAILS_ENV=production
bundle install --deployment
rake db:migrate
rake assets:clean assets:precompile
service nginx restart
