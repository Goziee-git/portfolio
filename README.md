# Django Portfolio Website

A production-ready Django portfolio website with Gunicorn and Nginx.

## Features

- Responsive design with Bootstrap
- Static file serving with WhiteNoise
- Production-ready configuration
- Gunicorn WSGI server
- Nginx reverse proxy configuration

## Quick Start

1. **Setup and run locally:**
   ```bash
   source venv/bin/activate
   python manage.py runserver
   ```

2. **Production deployment:**
   ```bash
   ./deploy.sh
   ```

3. **Start with Gunicorn:**
   ```bash
   source venv/bin/activate
   gunicorn --config gunicorn.conf.py portfolio_site.wsgi:application
   ```

## Production Setup

1. **Copy Nginx configuration:**
   ```bash
   sudo cp nginx.conf /etc/nginx/sites-available/portfolio
   sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
   sudo nginx -t && sudo systemctl reload nginx
   ```

2. **Setup systemd service:**
   ```bash
   sudo cp portfolio.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable portfolio
   sudo systemctl start portfolio
   ```

## Environment Variables

- `SECRET_KEY`: Django secret key (required in production)
- `DEBUG`: Set to 'false' in production
- `ALLOWED_HOSTS`: Comma-separated list of allowed hosts

## Project Structure

```
portfolio/
├── portfolio_site/          # Django project settings
├── portfolio/               # Main app
├── templates/               # HTML templates
├── static/                  # Static files (CSS, JS)
├── staticfiles/            # Collected static files
├── gunicorn.conf.py        # Gunicorn configuration
├── nginx.conf              # Nginx configuration
├── portfolio.service       # Systemd service file
└── deploy.sh               # Deployment script
```
