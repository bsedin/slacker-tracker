FROM ruby:2.3.1-alpine

MAINTAINER Sergey Besedin

RUN \
  apk add --no-cache \
    file \
    imagemagick \
    build-base \
    linux-headers \
    libxml2-dev \
    libxslt-dev \
    xz \
    bash \
    git \
    nodejs \
    postgresql-dev \
    python

RUN \
  apk add --no-cache tzdata \
  && cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
  && echo "Europe/Moscow" >  /etc/timezone

ENV \
  APP_HOME=/slacker_tracker \
  RAKE_ENV=production \
  RACK_ENV=production

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* /$APP_HOME/

ADD . $APP_HOME

RUN \
  mkdir -p $APP_HOME/tmp/pids \
  && mkdir -p $APP_HOME/public/assets

RUN bundle install --deployment --without development test \

VOLUME [ "$APP_HOME/public", "$APP_HOME/log", "$APP_HOME/tmp" ]

EXPOSE 3000

CMD \
  bundle install --deployment --without development test \
  && npm i \
  && bundle exec rake assets:precompile \
  && bundle exec rake db:migrate \
  && bundle exec rails s -b 0.0.0.0 -p 3000
