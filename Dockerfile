FROM elixir:1.8-alpine

RUN apk update && \
    apk upgrade && \
    apk add build-base && \
    apk add --no-cache git openssh && \
    apk add --update nodejs nodejs-npm && \
    /usr/local/bin/mix local.hex --force && \
    /usr/local/bin/mix local.rebar --force
