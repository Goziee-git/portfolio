# EC2 Deployment Commands

## Critical Fix: Rename secrets.py to avoid Python module conflict
```bash
cd /path/to/your/portfolio
mv secrets.py generate_secret_key.py
```

## 1. Update Service File for Your EC2 User
```bash
# If your EC2 user is 'ubuntu', run this:
sudo sed -i 's/prospa/ubuntu/g' /etc/systemd/system/portfolio.service

# If your EC2 user is 'ec2-user', run this:
sudo sed -i 's/prospa/ec2-user/g' /etc/systemd/system/portfolio.service
```

## 2. Update Nginx Config for EC2 Access
```bash
# Allow access via EC2 public IP (not just localhost)
sudo sed -i 's/server_name localhost;/server_name _;/' /etc/nginx/sites-available/portfolio

# If your portfolio is at /home/ubuntu/portfolio, update paths:
sudo sed -i 's/prospa/ubuntu/g' /etc/nginx/sites-available/portfolio

# If your portfolio is at /home/ec2-user/portfolio, update paths:
sudo sed -i 's/prospa/ec2-user/g' /etc/nginx/sites-available/portfolio
```

## 3. Deploy Services
```bash
# Copy and enable service
sudo cp portfolio.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable portfolio
sudo systemctl start portfolio

# Setup nginx
sudo cp nginx.conf /etc/nginx/sites-available/portfolio
sudo ln -sf /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 4. Check Status
```bash
sudo systemctl status portfolio nginx
curl -I http://localhost
```

## 5. MOST IMPORTANT: Open EC2 Security Group
- AWS Console → EC2 → Security Groups
- Find your instance's security group
- Add inbound rule: **Type: HTTP, Port: 80, Source: 0.0.0.0/0**

## Troubleshooting Commands
```bash
# Check service logs
sudo journalctl -u portfolio -f

# Check nginx logs
sudo tail -f /var/log/nginx/error.log

# Test socket connection
ls -la /path/to/your/portfolio/portfolio.sock
```

ERROR
```bash
2025/09/01 14:44:46 [crit] 4247#4247: *18 connect() to unix:/home/ubuntu/Python_Static_website/gunicorn.sock failed (13: Permission denied) while connecting to upstream, client: 54.157.34.25, server: your-domain.com, request: "HEAD / HTTP/1.1", upstream: "http://unix:/home/ubuntu/Python_Static_website/gunicorn.sock:/50x.html", host: "54.157.34.25"
```
The main issues are:

1. Wrong socket path: Nginx is looking for ```gunicorn.sock``` but your portfolio creates ```portfolio.sock```
2. Permission denied: Nginx can't access the socket file
3. Different project: This appears to be a different Django project

Let's fix this step by step:

### 1. Check what's actually running on your EC2:
### Check what services are running
```bash
sudo systemctl status --no-pager
```
### Check what's listening on your system
```sudo netstat -tlnp | grep :80```
```sudo find /home -name "*.sock" 2>/dev/null```


## 2. Fix the socket permissions issue:
### Add nginx user to your project user's group
```sudo usermod -a -G ubuntu www-data```

### Make sure the socket directory is accessible
```chmod 755 /home/ubuntu```



### If the socket exists, check its permissions
```ls -la /home/ubuntu/*.sock```


## 3. Update your Gunicorn configuration:

Your gunicorn.conf.py should include:

python
```bash
bind = "unix:/home/ubuntu/Python_Static_website/gunicorn.sock"
user = "ubuntu"
group = "ubuntu"
umask = 0o007  # This allows group access to the socket
```

## 4. Update Nginx configuration:

Make sure your Nginx config matches the actual socket path:

### Check current nginx config
```nano /etc/nginx/sites-enabled/gunicorn.sock```

### The proxy_pass should match your actual socket:

```bash
proxy_pass http://unix:/home/ubuntu//gunicorn.sock;
```
### 5. Restart services in correct order:


### Stop everything first
```bash
sudo systemctl stop nginx
sudo systemctl stop portfolio
```
### Start Django service first (creates socket)
```bash
sudo systemctl start portfolio
```
### Then start nginx
```bash
sudo systemctl start nginx
```
### Check status
```bash
sudo systemctl status portfolio nginx
```

Can you run these commands and share:
1. What services are currently running?
2. What socket files exist and their permissions?
3. Your current Nginx configuration?

This will help me give you the exact fix for your specific setup.