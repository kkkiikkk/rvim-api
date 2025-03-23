FROM ruby:3.3.4

RUN apt-get update -qq && \
    apt-get install -y \
    nodejs \
    build-essential \
    libvips \
    libvips-dev \
    ffmpeg \
    file \
    git \
    curl \
    libpq-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 4 --retry 5

COPY . .

RUN bundle exec rake assets:precompile

RUN mkdir -p /app/public/videos

ENV PATH="/app/bin:/app/vendor/bundle/bin:$PATH"

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
