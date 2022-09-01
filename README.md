# HNAggregator

[![build](https://github.com/cgerling/hn-aggregator/actions/workflows/build.yml/badge.svg)](https://github.com/cgerling/hn-aggregator/actions/workflows/build.yml)

The Hacker News aggregator fetches data from the Hacker News API for further
analysis or consumption.

## Usage

You can either use the [hn-aggregator.fly.dev](https://hn-aggregator.fly.dev),
or run it locally (check the instructions below) and access it through
[`localhost:4000`](http://localhost:4000/).

See the [routes documentation](docs/routes.md) to see the available routes and
how to use them.

### Docker Compose

Simply run the command below and Docker will build an image and start a
container with the application.
```bash
docker compose up
```

### From scratch

To run the application locally you will need to have installed `elixir >=1.14.0`
and `erlang >=23.0.0`.

1. Fetch the dependencies
    ```bash
    mix deps.get
    ```
1. Compile and start the application
    ```bash
    mix phx.server
    ```

