const http = require("http");
http.createServer((_, res) => {
  res.end(`multi-arch ok arch=${process.arch}\n`);
}).listen(3000, "0.0.0.0");
