FROM python:3.10-alpine

# Set arguments for UID and GID
ARG UID
ARG GID


RUN apk update && apk add --no-cache curl openssl-dev sudo && \
    addgroup -g $GID nonroot && \
    adduser -u $UID -G nonroot --disabled-password --gecos "" nonroot && \
    echo 'nonroot ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
# Set non-root user to run the application
USER nonroot

WORKDIR /home/nonroot/app

# Copy the application code and set the appropriate ownership
COPY --chown=nonroot:nonroot . /home/nonroot/app
RUN chmod -R 755 /home/nonroot/app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["python", "app.py"]