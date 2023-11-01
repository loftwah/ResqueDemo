# Resque and Resque Scheduler Demo with Rails on macOS

This README outlines how to set up a basic Rails application with Resque for background jobs and Resque Scheduler for scheduling those jobs.

## Prerequisites

* Ruby 3.2.2
* Rails 7.x
* PostgreSQL
* Redis

## Setup Steps

### 1. Create New Rails Application

```bash
rails new ResqueDemo --database=postgresql --css=tailwind
```

### 2. Add Gems

Add the following gems to your `Gemfile`:

```ruby
gem 'resque'
gem 'resque-scheduler'
```

Then run:

```bash
bundle install
```

### 3. Set up Redis

Install Redis if you haven't:

```bash
brew install redis
```

Start Redis:

```bash
redis-server
```

### 4. Configure Resque and Resque Scheduler

Create an initializer at `config/initializers/resque.rb`:

```ruby
require 'resque'
require 'resque-scheduler'
require 'resque/scheduler/server'
```

### 5. Update Routes

In `config/routes.rb`, add:

```ruby
require 'resque/server'
Rails.application.routes.draw do
  mount Resque::Server, at: "/resque"
end
```

### 6. Create Example Job

Create a file `app/jobs/example_job.rb`:

```ruby
class ExampleJob
  @queue = :example

  def self.perform(name)
    puts "Hello, #{name}"
  end
end
```

### 7. Create Rake Task

Create a new file `lib/tasks/resque.rake`:

```ruby
namespace :resque do
  task enqueue: :environment do
    Resque.enqueue(ExampleJob, "Immediate")
  end

  task enqueue_in: :environment do
    Resque.enqueue_in(5.seconds, ExampleJob, "In 5 seconds")
  end

  task enqueue_at: :environment do
    time = Time.now + 1.minute
    Resque.enqueue_at(time, ExampleJob, "At #{time}")
  end
end
```

### 8. Create Resque Schedule Configuration

Create a `config/resque_schedule.yml`:

```yaml
ExampleJob:
  cron: "* * * * *"
  class: "ExampleJob"
  args: "Loftwah"
  description: "I'm an example job!"
```

### 9. Run Servers and Worker

> NOTE: run `bin/setup` to set up the database and run migrations.

In separate terminals:

1. Run Rails server: `rails server`
2. Run Resque worker: `QUEUE=* rake resque:work`
3. Run Resque scheduler: `rake resque:scheduler`

OR

1. Run `bin/setup` and `bin/dev` to run all three in one terminal.

### 10. Test Jobs

Run the custom rake tasks to enqueue jobs:

* `rake resque:enqueue`
* `rake resque:enqueue_in`
* `rake resque:enqueue_at`

## Monitoring

You can monitor the jobs at `http://localhost:3000/resque`.