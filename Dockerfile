FROM ruby:3.0.3-slim
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
  && chown forecasts:forecasts -R /app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# potential workaround for older docker versions
# access each file as root prior to changing users
# to avoid broken permissions
RUN ls -R .

USER forecasts
ENV BUNDLER_VERSION 2.2.32
COPY --chown=forecasts:forecasts Gemfile Gemfile.lock ./

RUN bundle config set --local deployment 'true' \
  && bundle config set --local without 'development test' \
  && bundle install \
  && rm -rf vendor/bundle/ruby/3.0.0/cache/*.gem \
  && find vendor/bundle/ruby/3.0.0/gems/ -name "*.c" -delete \
  && find vendor/bundle/ruby/3.0.0/gems/ -name "*.o" -delete

COPY --chown=forecasts:forecasts package.json yarn.lock ./
RUN yarn install --frozen-lockfile --non-interactive --production

COPY --chown=forecasts:forecasts . .
RUN rm entrypoint.sh

ENV PATH="${PATH}:/app/bin"

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# precompile production app
RUN RAILS_ENV=production SECRET_KEY_BASE=`rails secret` rails assets:precompile --trace \
  && yarn cache clean \
  && rm -rf tmp/cache vendor/assets test spec node_modules

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]