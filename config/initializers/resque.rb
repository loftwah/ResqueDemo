require 'resque'
require 'resque-scheduler'
require 'resque/scheduler/server'

Resque.redis = 'redis:6379'
