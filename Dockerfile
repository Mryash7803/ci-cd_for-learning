FROM node:20-slim

WORKDIR /app

COPY package.json .
RUN npm install

RUN npm list tar

COPY . .

CMD ["npm", "start"]
