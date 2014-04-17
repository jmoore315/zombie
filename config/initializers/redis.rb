# Explicitly set ENV["REDISTOGO_URL"] because Heroku currently
# ignores the config.initialize_on_precompile command.
ENV["REDISTOGO_URL"] = 'redis://redistogo:32d82bab3b4b20ae1799ab2c359c990d@dory.redistogo.com:10553/'

uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)