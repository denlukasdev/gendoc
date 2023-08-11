FROM node:{~NODE_VERSION~}-alpine

# Install Python and other dependencies
RUN apk add --no-cache python3 python3-dev gcc g++ make

# Set working directory
WORKDIR /usr/src/app

# Run start command
COPY package.json ./
COPY package-lock.json ./
RUN npm i
COPY . ./
CMD ["npm", "start"]
#CMD ["sh", "/usr/src/npm_start.sh"]
