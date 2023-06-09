# config valid for current version and patch releases of Capistrano
lock "~> 3.17.2"

set :application, "yamatabi"
set :repo_url, "git@github.com:hirokirokki0820/yamatabi-blog.git"
set :rbenv_ruby, File.read('.ruby-version').strip
set :branch, ENV['BRANCH'] || "main"

# Nginxの設定ファイル名と置き場所を修正
set :nginx_config_name, "#{fetch(:application)}.conf"
set :nginx_sites_enabled_path, "/etc/nginx/conf.d"

append :linked_files, "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "node_modules"
# ***** 以上を追加 *****
