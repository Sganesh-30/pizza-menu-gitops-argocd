# Use the node 18-alpine image as the base
FROM node:18-alpine3.17

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Upgrade npm to the latest version
RUN npm install -g npm@11.0.0

# Set npm configurations and install dependencies
RUN npm config set registry https://registry.npmjs.org/ \
    && npm config set fetch-timeout 120000 \
    && npm config set fetch-retries 5 \
    && npm install --no-cache

# Copy the rest of the application code
COPY . .

EXPOSE 3000

# Specify the command to start the application
CMD ["npm", "start"]
