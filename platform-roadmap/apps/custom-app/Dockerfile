# Step 1: Inherit from an optimized base image tier
FROM nginx:alpine

# Step 2: Inject custom metadata documentation parameters
LABEL maintainer="stevenjo5"
LABEL layer="application"

# Step 3: Overlay the local code artifact directly into the server engine path
COPY index.html /usr/share/nginx/html/index.html

# Step 4: Expose the core networking boundary port for documentation
EXPOSE 80
