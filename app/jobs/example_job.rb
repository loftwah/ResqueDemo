class ExampleJob
    @queue = :example
  
    def self.perform(name)
      puts "Hello, #{name}"
    end
  end
  