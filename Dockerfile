# Use a lightweight Python 3.11 image
FROM python:3.11-slim

# Set working directory
WORKDIR /app/

# Install necessary system packages
RUN apt-get update && \
    apt-get install -y \
    python3-venv \
    build-essential \
    python3-dev \
    python3-setuptools \
    gcc \
    make

# Copy only requirements first for better caching
COPY src/requirements.txt /app/src/requirements.txt

# Create and activate virtual environment
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/python -m pip install --upgrade pip && \
    /opt/venv/bin/python -m pip install -r /app/src/requirements.txt

# Copy the rest of the application
COPY . /app

# Purge unnecessary build dependencies
RUN apt-get remove -y --purge make gcc build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Ensure entrypoint is executable
COPY /src/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Run the application
CMD ["/app/entrypoint.sh"]

