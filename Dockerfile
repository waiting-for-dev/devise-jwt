FROM ruby:2.3.1
ENV APP_HOME /app/
ENV LIB_DIR lib/devise/jwt/
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libxml2-dev libxslt1-dev nodejs
RUN mkdir -p $APP_HOME/$LIB_DIR
WORKDIR $APP_HOME
COPY Gemfile *gemspec $APP_HOME
COPY $LIB_DIR/version.rb $APP_HOME/$LIB_DIR
RUN bundle install
