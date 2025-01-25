FROM node:18-alpine3.17

WORKDIR /app

COPY package*.json /app/

RUN npm install --no-cache

COPY . /app/

EXPOSE 4000

CMD [ "npm", "start"]