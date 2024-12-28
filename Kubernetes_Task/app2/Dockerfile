# Dockerfile for the second app
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Python application code into the container
COPY app2.py .

# Install Flask and requests in the container
RUN pip install Flask requests

# Expose the port that Flask will run on
EXPOSE 5001

# Run the application
CMD ["python", "app2.py"]
