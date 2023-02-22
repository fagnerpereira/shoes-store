FROM ruby:3.2.1-slim-bullseye AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_PATH="vendor/bundle" \
    BUNDLE_WITHOUT="development:test"

# Update gems and preinstall the desired version of bundler
ARG BUNDLER_VERSION=2.4.6
RUN gem update --system --no-document && \
    gem install -N bundler -v ${BUNDLER_VERSION}

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libpq-dev redis

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle _${BUNDLER_VERSION}_ install && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE=DUMMY ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y postgresql-client redis && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Run and own the application files as a non-root user for security
ARG UID=1000 \
  GID=1000
RUN groupadd -f -g $GID rails && \
  useradd -u $UID -g $GID rails
USER rails:rails

# Copy built application from previous stage
COPY --from=build --chown=rails:rails /rails /rails

# Deployment options
ENV RAILS_LOG_TO_STDOUT="1" \
  RAILS_SERVE_STATIC_FILES="true"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
#RUN apt-get update \
#  && apt-get install -y --no-install-recommends build-essential libpq-dev \
#  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
#  && apt-get clean \
#  && useradd --create-home ruby \
#  && chown ruby:ruby -R /app
#
#
#USER ruby
#
#COPY --chown=ruby:ruby bin/ ./bin
#RUN chmod 0755 bin/*
#ARG RAILS_ENV="production"
#ENV RAILS_ENV="${RAILS_ENV}" \
#    PATH="${PATH}:/home/ruby/.local/bin" \
#    USER="ruby"

#COPY --chown=ruby:ruby --from=assets /usr/local/bundle /usr/local/bundle
#COPY --chown=ruby:ruby --from=assets /app/public /public
#COPY --chown=ruby:ruby . .

#ENTRYPOINT ["/app/bin/docker-entrypoint-web"]

#EXPOSE 8000

#CMD ["rails", "s"]
