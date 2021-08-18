ARG VARIANT
FROM ruby:${VARIANT}
RUN apk --no-cache add make gcc musl-dev git bash \
  g++ sqlite-dev tzdata nodejs yarn
## install ruby package
RUN gem install solargraph rubocop rails rspec \
  ruby-debug-ide debase