set :application, "eventstore"
set :repository,  "https://github.com/belhyun/eventstore.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "nginx"                          # Your HTTP server, Apache/etc
role :app, "unicorn"                          # This may be the same as your `Web` server
role :db,  "localhost", :primary => true # This is where Rails migrations will run

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  namespace :assets do
    desc "Run the precompile task locally"
    task :precompile, :roles => :web, :except => { :no_release => true } do
      %x{bundle exec rake assets:precompile}
      %x{bundle exec rake assets:clean}
    end
  end
end
