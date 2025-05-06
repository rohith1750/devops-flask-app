# Use official Python image from Docker Hub
FROM python:3.9-slim

# Set working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy the Flask app code into the container
COPY . .

# Expose the port the app will run on
EXPOSE 5000

# Command to run the Flask app
CMD ["python", "app/app.py"]
