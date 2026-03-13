FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/out ./out
COPY --from=builder /app/package.json ./
RUN npm install -g serve
EXPOSE 3000
CMD ["serve", "out", "-p", "3000"]
