name: Flask CI/CD Pipeline

on:
  push:
    branches:
      - main  # This will trigger the workflow whenever there is a push to the main branch

jobs:
  build:
    runs-on: ubuntu-latest  # This will run the job on the latest version of Ubuntu

    steps:
      # Step 1: Checkout the repository
      - name: Checkout code
        uses: actions/checkout@v3  # This action checks out the code from the repository

      # Step 2: Set up Docker Buildx
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2  # This action sets up Docker Buildx to build multi-platform images

      # Step 3: Build the Docker image
      - name: Build Docker image
        run: |
          docker build -t flask-devops-app .  # This command builds the Docker image

      # Step 4: Run the Docker container (optional for testing)
      - name: Run Docker container
        run: |
          docker run -d -p 5000:5000 flask-devops-app  # Run the container in detached mode
          sleep 10  # Wait for 10 seconds to ensure the app starts
          curl http://localhost:5000  # Test if the app is running
