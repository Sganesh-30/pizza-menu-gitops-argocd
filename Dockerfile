FROM node:18-alpine3.17

WORKDIR /app

COPY package*.json /app/

RUN npm config set registry https://registry.npmjs.org/ \
    && npm config set fetch-timeout 120000 \
    && npm config set fetch-retries 5 \
    && npm install --no-cache

COPY . /app/

EXPOSE 3000

CMD [ "npm", "start"]