# Use at least one worker per core if you're on a dedicated server,
# more will usually shorten waits on databases/caches.
worker_processes 3

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# Preloading the app saves memory
preload_app true

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end