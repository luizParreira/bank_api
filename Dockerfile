FROM bitwalker/alpine-elixir-phoenix:1.4.2

EXPOSE 4000
ENV PORT=4000

RUN mix local.hex --force && mix local.rebar --force
RUN apk --no-cache --update add postgresql-client inotify-tools bash git build-base libstdc++ python erlang-snmp erlang-dev \
    && rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app
ADD . .

RUN mix deps.get

CMD ["mix", "phoenix.server"]
