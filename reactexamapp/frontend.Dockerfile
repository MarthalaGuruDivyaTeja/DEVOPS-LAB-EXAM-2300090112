# Stage 1: Build
FROM node:18-alpine AS build

WORKDIR /app

# Copy only package files first for caching
COPY package*.json ./

RUN npm install

# Copy the rest of the app
COPY . .

# Ensure vite has execute permissions
RUN chmod +x node_modules/.bin/vite

# Build the app
RUN npm run build

# Stage 2: Serve production build
FROM nginx:stable-alpine

# Copy built assets
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
