# CSOT-DevOps Week01 Project


A unified DevOps infrastructure workspace combining automated system telemetry monitoring (Build 1), user management pipelines, and a production-tier web application deployment stack (Build 2). Designed to run on Linux environments, WSL, or standalone server blocks.

---

## System Architecture

The environment maps out a classic decoupled network footprint:

* **Edge Routing Layer:** Nginx acts as a high-performance Reverse Proxy facing public internet traffic on ports 80/443, handling SSL terminating tasks, and dropping diagnostic health endpoints (`/health`).
* **Application Service:** An isolated background Python HTTP server supervised natively via `systemd` daemon threads listening internally on a loopback socket (`127.0.0.1:8000`).

---

## Project Structure & Manifest

```text
├── README.md                 # Project introduction, architectural maps, and deployment usage guides
├── DEMO.md                   # Raw terminal execution output logs for verification metrics
├── .gitignore                # Restricts system binaries (.deb), logs, and secret files (.env)
├── .env.example              # Template environmental deployment flag configurations
├── LICENSE                   # Open-source MIT distribution rights framework
│
├── myapp/
│   └── server.py             # Micro Python API endpoint engine (CSOT Demo App)
│
├── nginx/
│   └── myapp                 # Nginx active reverse proxy virtual host file rule maps
│
├── systemd/
│   ├── myapp.service         # Systemd service unit controlling application lifecycle states
│   ├── healthmon.service     # One-shot data collection script driver service unit
│   └── healthmon.timer       # Automated chronometric system trigger ticking every 5 minutes
│
└── scripts/
    ├── backup.sh             # Compresses and timestamps directory backups into .tar.gz archives
    ├── log_parser.sh         # Scrapes web server access trails for explicit tracking insights
    ├── user_manager.sh       # Automates OS user creation/deletion using sequential CSV file data
    ├── sysreport.sh          # Captures resource usage, memory bounds, and network states
    └── deploy.sh             # Fully automated single-command machine provisioner
