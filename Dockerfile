# # Use the official Python image from the Docker Hub
# FROM python:3.9

# # Set the working directory in the container
# WORKDIR /app

# # Copy the current directory contents into the container at /app
# COPY . /app

# # Copy the requirements.txt file into the container
# COPY requirements.txt .

# # Install the dependencies from requirements.txt
# RUN pip install --no-cache-dir -r requirements.txt

# # Make port 80 available to the world outside this container
# EXPOSE 80

# # Run the application
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]

# Stage 1: Build stage
FROM python:3.9-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Install build dependencies
# In Dockerfiles, the --no-cache-dir flag is typically used when installing dependencies using package managers like pip (Python) or npm (Node.js) to prevent caching of downloaded packages and dependencies. This can be useful in scenarios where you want to ensure that the latest version of dependencies is always installed without relying on cached versions.
# In this example, when building the Docker image, the pip install command will not use any cached packages, ensuring that the dependencies listed in requirements.txt are freshly installed every time the Docker image is built.
RUN apk add --no-cache gcc musl-dev libffi-dev

# Copy the requirements file into the container
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final stage
FROM python:3.9-alpine

# Set the working directory in the container
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy the FastAPI application files
COPY . .

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]


# Docker build and run commands:
# sudo docker build -t fastapi-app .
# sudo docker run -d -p 8000:80 fastapi-app
