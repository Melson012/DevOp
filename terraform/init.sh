#!/bin/bash
echo "Starting App"
export DB_HOST=mongodb://11.6.2.60/posts
cd /home/ubuntu/app
npm install
pm2 start app.js
