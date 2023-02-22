#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM ruby:3.2.1-slim-bullseye AS app

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && useradd --create-home ruby \
  && chown ruby:ruby -R /app
  # && apt-get install curl

USER ruby

COPY --chown=ruby:ruby bin/ ./bin
RUN chmod 0755 bin/*
ARG RAILS_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    PATH="${PATH}:/home/ruby/.local/bin" \
    USER="ruby"

#COPY --chown=ruby:ruby --from=assets /usr/local/bundle /usr/local/bundle
#COPY --chown=ruby:ruby --from=assets /app/public /public
#COPY --chown=ruby:ruby . .

#ENTRYPOINT ["/app/bin/docker-entrypoint-web"]

#EXPOSE 8000

#CMD ["rails", "s"]
