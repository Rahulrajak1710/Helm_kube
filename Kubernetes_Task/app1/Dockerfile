# Dockerfile for the first app
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Python application code into the container
COPY app1.py .

# Install Flask in the container
RUN pip install Flask

# Expose the port that Flask will run on
EXPOSE 5000

# Run the application
CMD ["python", "app1.py"]
