FROM node:20-slim

WORKDIR /app

COPY package.json .
RUN npm install

COPY . .

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl=7.88.1-10+deb12u5 && \
    rm -rf /var/lib/apt/lists/*

CMD ["npm", "start"]
