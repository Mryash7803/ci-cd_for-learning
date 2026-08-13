FROM node:20-slim

WORKDIR /app

COPY package.json .
RUN npm install

COPY . .

RUN apt-get update && \
    apt-get install -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

CMD ["npm", "start"]
