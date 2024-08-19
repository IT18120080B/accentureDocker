# Use an official Python image as the base
FROM python:3.10-slim

# Install system dependencies including OpenSSL
RUN apt-get update && \
    apt-get install -y \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the application code into the container
COPY . /app

# Install the required dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 5000
EXPOSE 5000

# Run the Flask application when the container starts
CMD ["python", "app.py"]

