# -------------------------------------------------------------------
# Stage 1: Build & Dependencies
# -------------------------------------------------------------------
FROM node:20-bookworm-slim AS builder

WORKDIR /app

# Copy dependency definitions
COPY package*.json ./

# Install all dependencies (clean install) and clear npm cache
RUN npm ci && npm cache clean --force

# Copy source code
COPY . .

# If you have a build step (e.g. TypeScript, React/Vite/Next), uncomment:
# RUN npm run build

# Prune devDependencies to keep only production dependencies
RUN npm prune --production

# -------------------------------------------------------------------
# Stage 2: Production Runtime
# -------------------------------------------------------------------
FROM node:20-bookworm-slim AS runner

WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# 1. Patch any system-level vulnerabilities in Debian
# 2. Update global npm to patch bundled CLI vulnerabilities (tar, minimatch, etc.)
RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g npm@latest \
    && npm cache clean --force

# Copy production node_modules and built code from builder stage
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app ./

# Switch to non-root user provided by the official Node image
USER node

# Expose your application port (adjust as needed)
EXPOSE 3000

# Run the app directly with node instead of npm to avoid process wrapping
CMD ["node", "index.js"]