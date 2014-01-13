# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
set :output, "/home/www/rails_app/eventmoayo/log/cron_log.log"
set :environment, 'production'
every 1.days do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
  #
    runner "Product.removeExpireProducts"
    #runner "GroupProduct.removeExpireProducts"
    #runner "Product.updateProductsScoreByTime"
    #rake "create:run_all"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

every 30.minutes do
  #runner "User.refreshToken"
end

# Learn more: http://github.com/javan/whenever
