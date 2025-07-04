#!/bin/bash

# This script starts the Rails server and keeps the container running
# for VS Code dev container development

echo "Starting Rails development server with debug..."

# Start Rails server with debug in the background
bundle exec rails server -b 0.0.0.0 --debug &

# Store the PID so we can manage it if needed
echo $! > /tmp/rails_server.pid

echo "Rails server started with PID $(cat /tmp/rails_server.pid) in debug mode"
echo "Server should be accessible at http://localhost:3000"
echo "Container will remain running for VS Code development..."

# Keep the container running
sleep infinity
