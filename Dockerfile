FROM elixir:1.5.1-slim

RUN apt-get update \
    && apt-get install -y postgresql-client git

ENV APP_HOME /app
RUN mkdir -p $APP_HOME/tmp

ENV HISTFILE $APP_HOME/tmp/docker_histfile
ENV LANG C.UTF-8

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR $APP_HOME

CMD ["mix", "deps.get"]
CMD ["mix", "ecto.setup"]
CMD ["mix", "phx.server"]
