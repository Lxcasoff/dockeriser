const zmq = require("zeromq");
const sock = new zmq.Publisher;

(async () => {
  await sock.bind("tcp://0.0.0.0:5555");
  console.log("ZeroMQ Pub socket bound to port 5555");
  setInterval(() => {
    const msg = `Hello ${new Date().toISOString()}`;
    sock.send(["updates", msg]);
  }, 1000);
})();

