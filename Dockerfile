# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./

# Use npm install if no package-lock.json, otherwise npm ci
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

# Stage 2: Production
FROM node:20-alpine
WORKDIR /app

# Copy node_modules from builder
COPY --from=builder /app/node_modules ./node_modules

# Copy application code
COPY . .

# Remove any example env files if they exist
RUN rm -f .env.example || true

# Expose the port your app actually uses
EXPOSE 3000

# Set environment
ENV NODE_ENV=production

# Start the app
CMD ["node", "server.js"]