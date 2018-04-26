# A ruby-on-rails Website

一个基于 ruby on rails 写的小应用。
数据模型就是简单的
> 用户member => 日历事件events

初学ruby on rails，准备练习给小程序写API。

## Build Setup
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
database: mysql  => config/database.yml

需要在数据库里新建好数据库。

### Database initialization
```
rake db:migrate
```

### dev server
```
rails server
```
## Versions
- ruby 2.5.1
- Rails 5.2.0 

## dependencies
```yml
# Gemfile
# 分页插件
gem 'kaminari'
# 密码加密
gem 'bcrypt', '~> 3.1.7'
# 国际化 i18n
gem 'rails-i18n', '~> 5.1'
```
