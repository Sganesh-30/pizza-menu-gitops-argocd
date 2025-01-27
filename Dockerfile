FROM node:18-alpine3.17

WORKDIR /app

COPY package*.json ./

RUN npm install -g npm@11.0.0

RUN npm install -g npm@11.0.0 \
    && npm config set registry https://registry.npmjs.org/ \
    && npm config set fetch-timeout 120000 \
    && npm config set fetch-retries 5 \
    && npm install --prefer-online

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
