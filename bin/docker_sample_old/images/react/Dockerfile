FROM node:12.14.1-alpine

# Install Python and other dependencies
RUN apk add --no-cache python3 python3-dev gcc g++ make

# Set working directory
WORKDIR /usr/src/app
# Run start command
CMD ["sh", "/usr/src/npm_start.sh"]