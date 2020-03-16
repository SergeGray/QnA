app_path = '/home/deployer/qna'
working_directory "#{app_path}/current"
pid               "#{app_path}/current/tmp/pids/unicorn.pid"

listen "#{app_path}/shared/tmp/sockets/unicorn.qna.sock", backlog: 64

stderr_path 'log/unicorn.stderr.log'
stdout_path 'log/unicorn.stdout.log'

worker_processes 2

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

preload_app true

before_fork do |server, _worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      nil
    end
  end
end

after_fork do |_server|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
