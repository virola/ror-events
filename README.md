# A ruby-on-rails Website

一个基于 ruby on rails 写的小应用。
数据模型就是简单的
> 用户member => 日历事件events

初学ruby on rails，准备练习给小程序写API。

线上地址： http://ror-deploy.virola-eko.com
服务器使用 nginx + puma + mina 做部署。学习部署的过程非常的痛苦，有时间要写一篇文章讲述一下。

## 开发环境运行项目
### install ruby on rails
```
brew install ruby
sudo gem install rails --no-ri --no-rdoc
```
### install dependencies
```
bundle install
```
### Configuration
配置数据库，新建一个空数据库。
database: mysql  => config/database.yml

### Database initialization
初始化数据表，执行：
```
rake db:migrate
```

### dev server
启动本地服务器
```
rails server
```
访问： http://localhost:3000/

## 服务器部署
编辑`mina`配置文件 `config/deploy.rb`:
```ruby
set :domain, 'root@servername'
set :deploy_to, '/home/wwwroot/ror.deploy'
set :repository, 'git@github.com:virola/ror-events.git'
set :branch, 'master'
```
第一次部署前需要先执行 `mina setup`，建立部署目录结构。
执行 `mina deploy` ，自动部署并启动 puma 服务器。
另外需要配置nginx服务器。

### nginx 转发配置
```
upstream deploy {                                                                    server unix:///home/wwwroot/ror.deploy/shared/tmp/sockets/puma.sock;
}
server {   
  listen 80; 
  server_name ror-deploy.virola-eko.com ;
  root  /home/wwwroot/ror.deploy/current/public;

  access_log  /home/wwwlogs/deploy.virola-eko.com.log;

  location / { 
    # match the name of upstream directive which is defined above
    proxy_pass http://deploy; 
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }   

  location ~* ^/assets/ {
    # Per RFC2616 - 1 year maximum expiry
    expires 1y; 
    add_header Cache-Control public;
    # Some browsers still send conditional-GET requests if there's a
    # Last-Modified header or an ETag header even if they haven't
    # reached the expiry date sent in the Expires header.
    add_header Last-Modified ""; 
    add_header ETag ""; 
    break;
  }   
} 
```

## Versions
- ruby 2.5.1
- Rails 5.2.0 

