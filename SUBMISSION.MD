# Insider Trading

### Project Structure

- [insider_trading(Backend)](insider_trading)
- [insider_trading_client(Frontend)](insider_trading_client)

## How to Run

### Backend - Elixir, Phoenix, Postgress

- Install deps inside [backend directory](insider_trading) - `mix deps.get`
- Configure DB credentials - `insider_trading/config/dev.exs`
- Run Migration/Setup Db - `mix ecto.migrate` or `mix ecto.setup`

- Run Server - `iex -S mix phx.server`

#### How to Fetch Companies and Transactiopns -

- Run `InsiderTrading.FetchExternalData.run()` for fetching companies and start 20 companies transactions.

  Note - If you want fetch more companies transactions you can update limit by passing with company limits``InsiderTrading.FetchExternalData.run(50)`

- Companies data will automatic fetch on daily basis using scheduler. You can find configuration in `config.exs`

### Frontend - React, Redux

- Install Node modules inside [frontend directory](insider_trading_client) `npm install`
- Start Server `npm start`
