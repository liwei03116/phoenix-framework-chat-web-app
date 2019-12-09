defmodule ChitChatEn.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :description, :string
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end
end
