# -------------------------------------------------------------------
# Stage 1: Build & Dependencies
# -------------------------------------------------------------------
FROM node:20-bookworm-slim AS builder

WORKDIR /app

COPY package*.json ./

# Install all dependencies
RUN npm ci

# Copy application source
COPY . .

# If you have a build step (TypeScript, Next.js, etc.), uncomment:
# RUN npm run build

# Remove development dependencies
RUN npm prune --production

# -------------------------------------------------------------------
# Stage 2: Minimal Production Runtime
# -------------------------------------------------------------------
FROM node:20-bookworm-slim AS runner

WORKDIR /app

ENV NODE_ENV=production

# 1. Update OS packages safely without interactive prompts
# 2. Remove npm and yarn completely from runtime (eliminates npm CVEs entirely)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx /opt/yarn* /usr/local/bin/yarn*

# Copy production artifacts from builder stage
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app ./

# Run as non-root user
USER node

EXPOSE 3000

# Start directly with node (change index.js to your actual entry file if different)
CMD ["node", "index.js"]