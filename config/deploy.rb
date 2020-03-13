lock '~> 3.12.1'

set :application, 'qna'
set :repo_url, 'git@github.com:sergegray/qna.git'

set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

append :linked_files, 'config/database.yml', 'config/master.key'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
       'public/system', 'storage'
