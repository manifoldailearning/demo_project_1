#!/bin/bash
# Update packages
sudo yum update -y

# Install Docker
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

# Install prerequisites for CodeDeploy agent
sudo yum install -y ruby wget

# Switch to a writable directory (optional, you can choose another)
cd /home/ec2-user

# Download the CodeDeploy agent install script.
# Replace "us-east-1" with your region if necessary.
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install

# Make the install script executable
chmod +x ./install

# Run the installer in auto mode
sudo ./install auto

# Start the CodeDeploy agent service (if it’s not started automatically)
sudo service codedeploy-agent start

# (Optional) Check the status of the CodeDeploy agent
sudo service codedeploy-agent status
