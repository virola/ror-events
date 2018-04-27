#!/usr/bin/env puma
environment 'production'
threads 2, 32 # minimum 2 threads, maximum 64 threads
workers 2

app_name = 'ror.deploy'

application_path = "/root/wwwroot/#{app_name}"

directory "#{application_path}/current"

pidfile "#{application_path}/shared/tmp/pids/puma.pid"
state_path "#{application_path}/shared/tmp/sockets/puma.state"
stdout_redirect "#{application_path}/shared/log/puma.stdout.log", "#{application_path}/shared/log/puma.stderr.log"
#绑定sock
bind "unix://#{application_path}/shared/tmp/sockets/puma.sock"
#绑定端口,nginx 是这个端口
bind 'tcp://127.0.0.1:3000'
worker_timeout 60
daemonize true

preload_app!
