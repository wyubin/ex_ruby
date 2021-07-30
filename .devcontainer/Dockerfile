ARG VARIANT
FROM ruby:${VARIANT}
RUN apk --no-cache add make gcc musl-dev git bash
## install ruby package
RUN gem install solargraph rubocop