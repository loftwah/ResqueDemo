# lib/tasks/resque.rake

namespace :resque do
    desc "Enqueue ExampleJob immediately"
    task enqueue: :environment do
      Resque.enqueue(ExampleJob, "Immediate")
      puts "Enqueued job to run immediately."
    end
  
    desc "Enqueue ExampleJob to run in 5 seconds"
    task enqueue_in: :environment do
      Resque.enqueue_in(5.seconds, ExampleJob, "In 5 seconds")
      puts "Enqueued job to run in 5 seconds."
    end
  
    desc "Enqueue ExampleJob to run at a specific time"
    task enqueue_at: :environment do
      time = Time.now + 1.minute
      Resque.enqueue_at(time, ExampleJob, "At #{time}")
      puts "Enqueued job to run at #{time}."
    end
  end
  