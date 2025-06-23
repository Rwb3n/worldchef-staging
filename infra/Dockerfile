# Stage 1 – build
FROM node:18-alpine AS build
WORKDIR /usr/src/app
COPY backend/package.json ./backend/package.json
COPY backend/package-lock.json ./backend/package-lock.json
RUN npm --prefix backend install

# Stage 2 – runtime
FROM node:18-alpine
WORKDIR /usr/src/app/backend
COPY --from=build /usr/src/app/backend /usr/src/app/backend
EXPOSE 3000
CMD ["node", "src/server.js"] 