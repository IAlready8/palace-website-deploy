# Multi-stage build: build React app then serve via Nginx

FROM node:20-alpine AS builder
WORKDIR /app

# Install deps
COPY source/package*.json ./
RUN npm ci

# Copy source and build
COPY source/ .
RUN npm run build

FROM nginx:alpine

# Copy custom Nginx config
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Copy build to web root
COPY --from=builder /app/build/ /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

