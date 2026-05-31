from http.server import HTTPServer, BaseHTTPRequestHandler
import os, json, datetime

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        body = json.dumps({
            "service": "csot-demo",
            "time": datetime.datetime.now().isoformat(),
            "path": self.path,
        }).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)
    def log_message(self, fmt, *args):
        print(f"{self.address_string()} - {fmt%args}", flush=True)

if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8000"))
    print(f"listening on :{port}", flush=True)
    HTTPServer(("127.0.0.1", port), H).serve_forever()