#!/usr/bin/env puma

environment ENV['RAILS_ENV'] || 'development'

daemonize true

pidfile "//root/wwwroot/ror.deploy/shared/tmp/pids/puma.pid"
stdout_redirect "//root/wwwroot/ror.deploy/shared/log/stdout", "//root/wwwroot/ror.deploy/shared/log/stderr"

threads 0, 16

bind "unix:///root/wwwroot/ror.deploy/shared/tmp/deploy.sock"
