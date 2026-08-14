FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN apk update && \
    apk upgrade --no-cache && \
    npm install && \
    npm cache clean --force && \
    rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

COPY . .

EXPOSE 3000

CMD ["node", "index.js"]