#!/usr/bin/env bash
set -euo pipefail

echo "Starting automated deployment pipeline..."

echo "Copying systemd service and Nginx rules..."
sudo cp /home/lenovo/csot-devops/project01/systemd/myapp.service /etc/systemd/system/myapp.service
sudo cp /home/lenovo/csot-devops/project01/nginx/myapp.conf /etc/nginx/sites-available/myapp

chmod +x myapp/server.py

echo "Reloading systemd service configurations..."
sudo systemctl daemon-reload
sudo systemctl enable --now myapp.service
sudo systemctl restart myapp.service

# 4. Enable Nginx reverse proxy routing profiles
echo "Reconfiguring Nginx web routing layers..."
sudo ln -sf /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/myapp
sudo nginx -t
sudo systemctl reload nginx

echo "Deployment complete! Testing local app endpoint..."
curl -I http://localhost/health || echo "⚠️ Warning: Health check endpoint did not respond."