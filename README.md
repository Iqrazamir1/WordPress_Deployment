# WordPress_Deployment

**Overview**

The Bash scripts automate the deployment of the WordPress website running on a LEMP stack. The setup consists of two main scripts: frontend.sh for configuring the web server and backend.sh for setting up the database server.

The frontend script sets up the WordPress environment and web server by updating system packages, installing necessary software such as AWS CLI, Nginx, PHP, and required PHP extensions. It also configures Nginx and enables it as a system service. Additionally, it sets up a SSL certificate using Certbot and the Nginx plugin, downloads and configures WordPress, updates wp-config.php with database credentials, generates secure salts, and ensures correct file permissions. To enhance security and disaster recovery, it backs up the WordPress configuration file to an AWS S3 bucket.

The backend script automates the database setup, including the installation of the MariaDB database server and client. It configures MariaDB to allow external connections, restarts the database service, and verifies its status. Furthermore, it creates a new database and user, grants necessary permissions, and restores a WordPress database dump from an AWS S3 bucket. To maintain security, database credentials are securely stored in AWS S3.

The scripts also manage key configuration files, such as nginx.conf, which defines the Nginx server block settings and is moved to /etc/nginx/conf.d/epa-domain.conf. The wp-config.php file, storing WordPress database credentials, is dynamically updated within the script. Additionally, the MariaDB configuration file (50-server.cnf) is adjusted to allow remote connections.

These scripts ensure an automated and streamlined deployment process, integrating cloud storage for backups, security best practices, and troubleshooting measures for enhanced reliability.
