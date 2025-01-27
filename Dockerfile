FROM node:18-alpine3.17

WORKDIR /app

COPY package*.json /app/

RUN npm config set registry https://registry.npmmirror.com/ && \
    npm install --retry=3 --no-optional --timeout=30000

COPY . /app/

EXPOSE 3000

CMD [ "npm", "start"]