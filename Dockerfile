FROM ruby:3.0.3-slim as builder
WORKDIR /app
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends build-essential curl git vim libpq-dev \
  && curl -sSL https://deb.nodesource.com/setup_14.x | bash - \
  && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y --no-install-recommends nodejs yarn postgresql-client \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && useradd --create-home forecasts \
  && mkdir /node_modules && chown forecasts:forecasts -R /node_modules /app

USER forecasts

COPY --chown=forecasts:forecasts package.json *yarn* ./
RUN yarn install --frozen-lockfile

COPY --chown=forecasts:forecasts Gemfile Gemfile.lock ./

ENV BUNDLER_VERSION 2.2.32

# bundle install in deployment mode
# do not install dev and test dependencies
# install in vendor/bundle
RUN bundle config set --local deployment 'true' \
  && bundle config set --local without 'development test' \
  && bundle install --jobs "$(nproc)" \
  && rm -rf vendor/bundle/ruby/3.0.0/cache/*.gem \
  && find vendor/bundle/ruby/3.0.0/gems/ -name "*.c" -delete \
  && find vendor/bundle/ruby/3.0.0/gems/ -name "*.o" -delete

ARG RAILS_ENV="production"
ARG NODE_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    NODE_ENV="${NODE_ENV}" \
    PATH="${PATH}:/home/forecasts/.local/bin:/node_modules/.bin" \
    USER="forecasts"

ENV PATH="${PATH}:/app/bin"

COPY --chown=forecasts:forecasts . .

# precompile production app
# use dummy secret ket base value
RUN RAILS_ENV=production SECRET_KEY_BASE=`rails secret` rails assets:precompile \
  && yarn cache clean \
  && rm -rf tmp/cache vendor/assets test spec node_modules

CMD ["bash"]

# ------------ BUILD DONE ------------ #

FROM ruby:3.0.3-slim as app

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl git vim libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && useradd --create-home forecasts \
  && chown forecasts:forecasts -R /app

USER forecasts

ARG RAILS_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    PATH="${PATH}:/home/forecasts/.local/bin" \
    USER="forecasts"

ENV PATH="${PATH}:/app/bin"

COPY --chown=forecasts:forecasts --from=builder /usr/local/bundle /usr/local/bundle
COPY --chown=forecasts:forecasts --from=builder /app /app
RUN chmod 0755 bin/*

EXPOSE 3000

CMD ["rails", "server", "-p", "3000", "-b", "0.0.0.0"]

ENTRYPOINT ["/app/bin/entrypoint.sh"]