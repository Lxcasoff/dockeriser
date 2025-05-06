// websocket/server.js
const zmq = require('zeromq');
const WebSocket = require('ws');

const sub = new zmq.Subscriber();
const wss = new WebSocket.Server({ port: 5555 });

(async () => {
  sub.connect('tcp://backend:5555'); 
  sub.subscribe('new_post');
  console.log("✅ WebSocket-ZeroMQ bridge listening...");

  for await (const [topic, msg] of sub) {
    const post = msg.toString();

    // Broadcast à tous les clients connectés
    wss.clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(post);
      }
    });
  }
})();