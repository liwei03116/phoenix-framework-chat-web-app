import { Presence } from "phoenix";
let Room = {
  init(socket, el) {
    let roomId = el.getAttribute("data-id");
    console.log(`element: ${el}, roomId: ${roomId}`);
    socket.connect();
    this.onReady(roomId, socket);
  },
  onReady(roomId, socket) {
    let msgContainer = document.getElementById("msg-container");
    let msgInput = document.getElementById("msg-input");
    let postButton = document.getElementById("msg-submit");
    let roomChannel = socket.channel("rooms:" + roomId);
    let username = "anonymous";
    // Added variables
    let presences = {};
    let onlineUsers = document.getElementById("online-users");

    // Added block
    let listUsers = user => {
      return {
        user: user
      };
    };
    // Added block
    let renderUsers = presences => {
      onlineUsers.innerHTML = Presence.list(presences, listUsers)
        .map(
          presence => `
    <li>${presence.user}</li>`
        )
        .join("");
    };

    postButton.addEventListener("click", e => {
      roomChannel
        .push("new_chat", { body: msgInput.value, user: username })
        .receive("error", e => console.log(e));

      msgInput.value = "";
    });

    roomChannel.on("new_chat", resp => {
      console.log(resp);
      this.renderChat(msgContainer, resp);
    });

    // Added block
    roomChannel.on("presence_state", state => {
      presences = Presence.syncState(presences, state);
      renderUsers(presences);
    });

    // Added block
    roomChannel.on("presence_diff", diff => {
      presences = Presence.syncDiff(presences, diff);
      renderUsers(presences);
    });

    roomChannel
      .join()
      .receive("ok", resp => console.log("joined room channel", resp))
      .receive("error", reason => console.log("failed to join", reason));
  },

  esc(input) {
    let div = document.createElement("div");
    div.appendChild(document.createTextNode(input));
    return div.innerHTML;
  },

  renderChat(msgContainer, { body, user }) {
    let div = document.createElement("div");

    div.innerHTML = `
      <b>${this.esc(user)}</b>: ${this.esc(body)}
      `;
    msgContainer.appendChild(div);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  }
};
export default Room;
