FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

# 1. Update Alpine packages
# 2. Install dependencies & clean cache
# 3. Delete npm CLI to wipe all 18 npm vulnerabilities
RUN apk update && apk upgrade --no-cache && \
    npm install && \
    npm cache clean --force && \
    rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

COPY . .

EXPOSE 3000

# Start directly with node instead of npm
CMD ["node", "index.js"]