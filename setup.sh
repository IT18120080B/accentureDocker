#!/bin/bash

# Default values
DEFAULT_IMAGE_NAME="flask-app"
DEFAULT_PORT=5000
ACTION="start"

# Function to display usage
usage() {
    echo "Usage: $0 [-i IMAGE_NAME] [-p PORT] [-a ACTION]"
    echo "  -i IMAGE_NAME   Name of the Docker image (default: $DEFAULT_IMAGE_NAME)"
    echo "  -p PORT         Host port to map to the container’s port (default: $DEFAULT_PORT)"
    echo "  -a ACTION       Action to perform: start or stop (default: $ACTION)"
    exit 1
}

# Parse command-line arguments
while getopts ":i:p:a:" opt; do
    case $opt in
        i) IMAGE_NAME="$OPTARG" ;;
        p) PORT="$OPTARG" ;;
        a) ACTION="$OPTARG" ;;
        \?) usage ;;
    esac
done

# Set default values if not provided
IMAGE_NAME=${IMAGE_NAME:-$DEFAULT_IMAGE_NAME}
PORT=${PORT:-$DEFAULT_PORT}
ACTION=${ACTION:-$ACTION}

# Function to install Docker
install_docker() {
    echo "Docker is not installed. Installing Docker..."
    
    # Update package index
    sudo apt-get update
    
    # Install prerequisite packages
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    
    # Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Set up the Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index again
    sudo apt-get update
    
    # Install Docker Engine
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    
    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    
    echo "Docker installed successfully."
}

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    install_docker
else
    echo "Docker is already installed."
fi

# Build the Docker image
if [ "$ACTION" = "start" ]; then
    echo "Building Docker image..."
    docker build -t $IMAGE_NAME .
    
    # Remove any existing container with the same name
    if [ "$(docker ps -q -f name=$IMAGE_NAME)" ]; then
        echo "Stopping and removing existing container..."
        docker stop $IMAGE_NAME
        docker rm $IMAGE_NAME
    fi
    
    # Run the Docker container
    echo "Running Docker container..."
    docker run -d --name $IMAGE_NAME -p $PORT:5000 $IMAGE_NAME
    
    # Verify that the container is running
    echo "Verifying that the container is running..."
    sleep 5  # Wait for a few seconds to ensure the container starts
    
    if docker ps -q -f name=$IMAGE_NAME
    then
        echo "Container is running."
        echo "You can access your Flask application at http://localhost:$PORT"
    else
        echo "Container failed to start."
        exit 1
    fi
elif [ "$ACTION" = "stop" ]; then
    echo "Stopping and removing Docker container..."
    if [ "$(docker ps -q -f name=$IMAGE_NAME)" ]; then
        docker stop $IMAGE_NAME
        docker rm $IMAGE_NAME
        echo "Container stopped and removed."
    else
        echo "No running container found with the name $IMAGE_NAME."
    fi
else
    usage
fi

