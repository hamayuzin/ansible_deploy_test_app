
shared_path = File.expand_path("../../../../shared", __FILE__)

worker_processes 4
timeout 150
preload_app true

listen      "#{shared_path}/tmp/sockets/unicorn.sock"
pid         "#{shared_path}/tmp/pids/unicorn.pid"
stdout_path "#{shared_path}/log/unicorn.log"
stderr_path "#{shared_path}/log/unicorn-err.log"

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = File.join(File.expand_path("../../../../", __FILE__), "current", "Gemfile")
end

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{ server.config[:pid] }.oldbin"
  unless old_pid == server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  sleep 1
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
