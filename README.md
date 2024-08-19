# Flask Application with Snowflake Integration

This project demonstrates how to create a Flask application that connects to Snowflake, retrieves logs, and displays them. The application is containerized using Docker for easy deployment and scalability.

## Prerequisites

- **Docker**: Make sure Docker is installed on your machine. You can follow the installation guide for your operating system from the [Docker documentation](https://docs.docker.com/get-docker/).

- **Snowflake Account**: Ensure you have access to a Snowflake account and replace the placeholder connection details in the `app.py` file with your actual credentials.

## Project Structure

- `Dockerfile`: Defines the Docker image for the Flask application.
- `requirements.txt`: Lists the Python dependencies for the application.
- `app.py`: The main Flask application script.
- `setup.sh`: Bash script to automate Docker setup.

## Setup and Running the Application

### 1. **Build the Docker Image**

To build the Docker image for the Flask application, run the following command:

```bash
docker build -t flask-app .
