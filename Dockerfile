# Use Ruby 3.2.2 image
FROM ruby:3.2.2

# Install Node.js and Yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install build dependencies and libraries
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn

# Set up working directory in container
WORKDIR /app

# Copy Gemfile and Gemfile.lock for bundle install
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install Gems
RUN bundle install

# Copy the whole application into the container
COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000 to interact with the application
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
