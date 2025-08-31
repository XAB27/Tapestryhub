# 🚀 Ansible EC2 DevOps Environment Setup

This Ansible project automates the installation and configuration of a complete DevOps environment on your EC2 instance, including Docker, Jenkins, SonarQube, monitoring tools, and Kubernetes utilities.

## 🎯 What Gets Installed

### 🐳 **Containerization**
- **Docker CE** - Container platform
- **Docker Compose** - Multi-container orchestration

### 🔄 **CI/CD**
- **Jenkins LTS** - Automation server
- **SonarQube** - Code quality and security analysis

### 🔍 **Security & Monitoring**
- **Trivy** - Vulnerability scanner
- **Prometheus** - Metrics collection
- **Node Exporter** - System metrics
- **Grafana** - Data visualization

### ☸️ **Kubernetes Tools**
- **AWS CLI v2** - AWS command line interface
- **kubectl** - Kubernetes cluster management
- **eksctl** - Amazon EKS CLI
- **Helm** - Kubernetes package manager

### 🛠️ **System & Common Tools**
- **Java 17** - Runtime environment
- **Git** - Version control
- **Essential packages** - curl, wget, unzip, vim, htop, etc.

## 📋 Prerequisites

- **EC2 instance** running Ubuntu 24.04 or Amazon Linux
- **SSH access** with key-based authentication
- **Ansible** installed on your local machine (any OS)

## 🚀 Quick Start

### Step 1: Clone the Repository
```bash
git clone <repository-url>
cd ansible-ec2-setup
```

### Step 2: Run the Setup Script
```bash
# Make the script executable
chmod +x setup.sh

# Run the setup script (works on Windows, Mac, and Linux)
./setup.sh
```

The setup script will:
- ✅ **Detect your OS** automatically
- ✅ **Install Ansible** if not already installed
- ✅ **Guide you through EC2 setup**

### Step 3: Configure Your EC2 Instance
1. **Launch an EC2 instance** (Ubuntu 24.04 recommended)
2. **Get the public IP address**
3. **Ensure your SSH key is accessible**
4. **Update `inventory/hosts.yml`** with your details:
   ```yaml
   ansible_host: YOUR_EC2_IP
   ansible_user: ubuntu (or ec2-user for Amazon Linux)
   ansible_ssh_private_key_file: ~/.ssh/YOUR_KEY.pem
   ```

### Step 4: Deploy to EC2
```bash
# Test connection
ansible ec2-instance -m ping

# Run the complete deployment
ansible-playbook playbooks/main.yml
```

## 🎛️ Individual Service Installation

You can also install services individually:

```bash
# Docker only
ansible-playbook playbooks/docker.yml

# Jenkins only
ansible-playbook playbooks/jenkins.yml

# SonarQube only
ansible-playbook playbooks/sonarqube.yml

# Monitoring stack (Prometheus, Node Exporter, Grafana)
ansible-playbook playbooks/monitoring.yml

# Kubernetes tools (AWS CLI, kubectl, eksctl, Helm)
ansible-playbook playbooks/kubernetes_tools.yml

# Trivy vulnerability scanner
ansible-playbook playbooks/trivy.yml
```

## 🌐 Access URLs

After deployment, access your services at:
- **Jenkins**: `http://YOUR_EC2_IP:8080`
- **SonarQube**: `http://YOUR_EC2_IP:9000`
- **Prometheus**: `http://YOUR_EC2_IP:9090`
- **Grafana**: `http://YOUR_EC2_IP:3000`

## 🔐 Default Credentials

### Jenkins:
- **Username**: `admin`
- **Password**: Check the playbook output for initial admin password

### SonarQube:
- **Username**: `admin`
- **Password**: `admin`

### Grafana:
- **Username**: `admin`
- **Password**: `admin`

## 🔧 Configuration

### Environment Variables
Key variables are defined in `inventory/group_vars/all.yml`:

```yaml
# Service versions
jenkins_version: "2.414.3"
sonarqube_version: "10.4.1.87192"
docker_version: "24.0.7"
prometheus_version: "2.48.0"
node_exporter_version: "1.7.0"
grafana_version: "10.2.0"

# Ports
jenkins_port: 8080
sonarqube_port: 9000
prometheus_port: 9090
node_exporter_port: 9100
grafana_port: 3000

# Credentials
sonarqube_admin_password: "admin123"
sonarqube_database_password: "sonarqube123"
```

## 📊 Monitoring Setup

### Prometheus Targets
- **Prometheus**: `localhost:9090`
- **Node Exporter**: `localhost:9100`
- **Jenkins**: `localhost:8080`
- **SonarQube**: `localhost:9000`

### Grafana Dashboards
1. Access Grafana at `http://YOUR_EC2_IP:3000`
2. Login with `admin/admin`
3. Add Prometheus as a data source: `http://localhost:9090`
4. Import dashboards for:
   - Node Exporter (system metrics)
   - Jenkins (CI/CD metrics)
   - SonarQube (code quality metrics)

## 🔍 Troubleshooting

### Common Issues:

1. **Permission Denied Errors:**
   ```bash
   # Make sure your SSH key has correct permissions
   chmod 600 ~/.ssh/your-key.pem
   ```

2. **Connection Refused:**
   ```bash
   # Check if services are running
   sudo systemctl status jenkins
   sudo systemctl status sonarqube
   ```

3. **Port Already in Use:**
   ```bash
   # Check what's using the port
   sudo netstat -tlnp | grep :8080
   ```

4. **Java Version Issues:**
   ```bash
   # Verify Java installation
   java -version
   echo $JAVA_HOME
   ```

### Logs Location:
- **Jenkins**: `/var/log/jenkins/`
- **SonarQube**: `/opt/sonarqube/logs/`
- **Prometheus**: `/opt/prometheus/`
- **Grafana**: `/var/log/grafana/`

## 🛡️ Security Notes

- Change default passwords after first login
- Configure security groups to allow access to required ports
- Use HTTPS in production environments
- Regularly update service versions
- Monitor security advisories

## 📈 Next Steps

1. **Configure Jenkins Jobs:**
   - Set up your first pipeline
   - Configure Git integration
   - Add build tools

2. **Set up SonarQube Projects:**
   - Connect your repositories
   - Configure quality gates
   - Set up automated analysis

3. **Create Grafana Dashboards:**
   - Import existing dashboards
   - Create custom visualizations
   - Set up alerts

4. **Integrate with CI/CD:**
   - Connect Jenkins with SonarQube
   - Set up automated testing
   - Configure deployment pipelines

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**�� Juice4Tech! 🚀**
