FROM node:18-alphine3.17

WORKDIR /app

COPY package*.json /app/

RUN npm install

COPY . /app/

EXPOSE 4000

CMD [ "npm", "start"]