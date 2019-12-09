defmodule ChitChatEn.Repo do
  use Ecto.Repo,
    otp_app: :chit_chat_en,
    adapter: Ecto.Adapters.Postgres
end
