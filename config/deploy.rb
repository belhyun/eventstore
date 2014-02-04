set :application, "eventstore"
set :repository,  "https://github.com/belhyun/eventstore.git"

#set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
#set :branch, "master"
#set :user, "belhyun"
#set :scm_passphrase, "whdgus2"

set :rails_env, "production"

role :web, "localhost"                          # Your HTTP server, Apache/etc
role :app, "localhost"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true }  do
  end
  #task :stop do ; end
  #task :restart, :roles => :app, :except => { :no_release => true } do
    #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  #end
end
