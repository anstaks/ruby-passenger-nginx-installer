# One line installer for Ruby 2.0, Phusion Passenger and Nginx on Ubuntu 12.04 LTS

If rebuild server, you will need: ssh-keygen -R hostname

Enter to your server as root, and run this one command:

```bash
sudo apt-get install -y git && git clone git://github.com/anstaks/ruby-passenger-nginx-installer.git && bash ./ruby-passenger-nginx-installer/install.sh
```

It will run through an auto install process. You will need set password for Mysql.

Once it is finished, you should set
```bash
source /usr/local/rvm/scripts/rvm
rvm list
```

Then you should generate ssh-key, and put it into git repository
```bash
ssh-keygen
cat ~/.ssh/id_rsa.pub
```

Then you will be need git clone your project in custom folder, for example /home/. And setting up nginx server for your app.

Edit your Nginx config file at /opt/nginx/conf/nginx.conf. Add this in:

```bash
server {
    listen 80;
    server_name www.your_host_name.com;
    root /home/app/public; 
    passenger_enabled on;

    # For file uploads
    client_max_body_size 20m;
}
```

If you using Mysql, you should set up user and db, let's do that:
```bash
sudo apt-get install mysql-server mysql-client

mysql -u root -p
CREATE USER 'username'@'localhost' IDENTIFIED BY 'userpassword';
CREATE DATABASE `dbname` CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON dbname.* TO 'username'@'localhost' IDENTIFIED BY 'userpassword';
exit;
```

For deploying:
```bash
export RAILS_ENV=production
bundle install --deployment
rake db:migrate
rake assets:clean assets:precompile
```

For look in log file, you can use: tail -f /opt/nginx/logs/error.log

Enjoy!

Anton Borzenko  
Front-end Developer, Ruby Developer  

## What this will install

* Ruby 2.0 with RVM
* Nginx (including init.d and logrotate tasks)
* Phusion Passenger
* ImageMagick (which we use all the time for things like Paperclip)

## Starting/Stopping Nginx

```bash
sudo service nginx start
sudo service nginx stop
sudo service nginx restart
```

### Credits

* The base of this came from [Leonard Teo](http://www.leonardteo.com/2012/11/install-ruby-on-rails-on-ubuntu-server/).
