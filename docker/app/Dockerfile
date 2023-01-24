FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp
COPY ./src/Gemfile /myapp/Gemfile
COPY ./src/Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --redownload

# Add a script to be executed every time the container starts.
COPY ./src/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]

