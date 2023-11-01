require 'resque'
require 'resque-scheduler'
require 'resque/scheduler/server'

Resque.redis = 'localhost:6379'
