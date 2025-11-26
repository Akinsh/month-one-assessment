#!/bin/bash
# Update system
yum update -y

# Install Apache
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create custom webpage with server identification
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>TechCorp Web Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .server-info { background: #e8f4fd; padding: 15px; border-radius: 5px; margin: 15px 0; }
        .header { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🌐 TechCorp Web Application</h1>
            <p>Load Balanced Infrastructure</p>
        </div>
        
        <div class="server-info">
            <h2>Server Information</h2>
            <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
            <p><strong>Availability Zone:</strong> $AVAILABILITY_ZONE</p>
            <p><strong>Server Time:</strong> $(date)</p>
        </div>

        <div>
            <h3>Request handled by:</h3>
            <p style="color: #e74c3c; font-size: 24px; font-weight: bold;">
                $(if [[ "$INSTANCE_ID" == *"1"* ]]; then echo "🟢 WEB SERVER 1"; else echo "🔵 WEB SERVER 2"; fi)
            </p>
        </div>
    </div>
</body>
</html>
EOF

# Create health check endpoint
echo "OK" > /var/www/html/health.html

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Ensure Apache is listening on all interfaces
echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

# Restart Apache to apply changes
systemctl restart httpd

# Install and configure firewall if needed
yum install -y firewalld
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload