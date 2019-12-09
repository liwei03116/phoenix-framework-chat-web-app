defmodule ChitChatEnWeb.RoomChannel do
  use ChitChatEnWeb, :channel

  alias ChitChatEn.Repo
  alias ChitChatEn.Accounts.User
  alias ChitChatEnWeb.Presence

  def join("rooms:" <> room_id, _payload, socket) do
    send(self, :after_join)
    {:ok, assign(socket, :room_id, String.to_integer(room_id))}
  end

  def handle_in("new_chat", payload, socket) do
    user = Repo.get(User, socket.assigns.user_id)
    broadcast!(socket, "new_chat", %{user: user.name, body: payload["body"]})

    {:reply, :ok, socket}
  end

  def handle_info(:after_join, socket) do
    user = Repo.get(User, socket.assigns.user_id)

    {:ok, _} =
      Presence.track(socket, user.name, %{
        online_at: inspect(System.system_time(:seconds))
      })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end
