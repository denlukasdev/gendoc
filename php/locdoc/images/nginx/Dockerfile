FROM nginx:alpine

# build arguments defined in docker-compose.yml
ARG PROJECT_TAG
ARG HOST_NAME

COPY nginx.conf /etc/nginx/nginx.conf
COPY app.conf /etc/nginx/conf.d/app.conf

# Set application host name and php-fpm container to the nginx app configuraion
RUN cat /etc/nginx/conf.d/app.conf && \
    sed -i \
    -e "s/HOST_NAME/${HOST_NAME}/g" \
    -e "s/PROJECT_TAG/${PROJECT_TAG}/g" \
    /etc/nginx/conf.d/app.conf && \
    cat /etc/nginx/conf.d/app.conf