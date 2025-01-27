FROM node:18-alpine3.17

WORKDIR /app

COPY package*.json /app/

RUN npm cache clean --force && npm update && npm install --no-cache

COPY . /app/

EXPOSE 3000

CMD [ "npm", "start"]