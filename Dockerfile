FROM node:18-alpine3.17

WORKDIR /app

COPY package*.json /app/

RUN npm install --retry=3


COPY . /app/

EXPOSE 3000

CMD [ "npm", "start"]