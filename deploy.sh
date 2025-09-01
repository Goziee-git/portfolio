#!/bin/bash

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --noinput

# Create superuser (optional)
echo "To create a superuser, run: python manage.py createsuperuser"

echo "Deployment complete!"
echo ""
echo "To start the application:"
echo "1. Start Gunicorn: gunicorn --config gunicorn.conf.py portfolio_site.wsgi:application"
echo "2. Configure Nginx with the provided nginx.conf"
echo "3. Or use systemd service: sudo cp portfolio.service /etc/systemd/system/ && sudo systemctl enable portfolio && sudo systemctl start portfolio"
