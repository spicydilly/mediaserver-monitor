FROM python:3.13-alpine

# Setting the working directory in the Docker container
WORKDIR /app/

# Install required Alpine packages
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    zlib-dev \
    jpeg-dev \
    freetype-dev \
    ttf-dejavu \
    tzdata \
    busybox-suid \
    && rm -rf /var/cache/apk/*

# Copy the needed resources
COPY resources/ resources/

# Copy and install Python dependencies
COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy Python source code
COPY src/ src/

# Install cron (Alpine uses busybox crond)
# Copy cron job
COPY crontab /etc/crontabs/root
RUN chmod 0644 /etc/crontabs/root

# Set timezone
ENV TZ="Europe/London"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
