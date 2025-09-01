#!/bin/bash

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --noinput

# Setup systemd service for auto-start
sudo cp portfolio.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable portfolio

# Setup Nginx configuration
sudo cp nginx.conf /etc/nginx/sites-available/portfolio
sudo ln -sf /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Start the service
sudo systemctl start portfolio

echo "Deployment complete!"
echo "Portfolio service is now running and will auto-start on boot."
