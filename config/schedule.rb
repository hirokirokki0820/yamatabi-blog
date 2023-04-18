require File.expand_path(File.dirname(__FILE__) + "/environment") # Rails.root(Railsメソッド)を使用するために必要
rails_env = ENV['RAILS_ENV'] || :production # cronを実行する環境変数(:development, :production, :test)
set :environment, rails_env # cronを実行する環境変数をセット
set :output, "#{Rails.root}/log/crontab.log" # cronのログ出力用ファイル

# サイトマップの生成
every 1.day, at: '5:00 am' do
  rake "-s sitemap:refresh"
end

# 紐付けされていないアップロードファイルの削除
every :sunday, at: '5:00 am' do  # 指定した曜日、時間に実行
  rake "unattached_images:purge"
end
