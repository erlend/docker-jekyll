#
#
# Base image
#
FROM ruby:alpine AS base

ENV JEKYLL_VAR_DIR=/var/jekyll
ENV JEKYLL_DATA_DIR=/srv/jekyll
ENV JEKYLL_ENV=development

ENV BUNDLE_HOME=/usr/local/bundle
ENV RUBYOPT=-W0

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TZ=America/Chicago
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US

RUN mkdir -m777 -p $JEKYLL_DATA_DIR/.jekyll-cache $JEKYLL_VAR_DIR

CMD ["--help"]
ENTRYPOINT ["jekyll"]

EXPOSE 4000
EXPOSE 35729

#
#
# Build image
#
FROM base AS build

RUN apk add --no-cache build-base

ARG JEKYLL_VERSION=">1"
RUN gem install --no-document jekyll -v "$JEKYLL_VERSION"

#
#
# Minimal image
#
FROM base AS minimal
COPY --from=build $GEM_HOME $GEM_HOME

#
#
# Standard image
#
FROM minimal
RUN apk add --no-cache yarn imagemagick
