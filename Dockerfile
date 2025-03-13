FROM node:18 as builder

WORKDIR /app

COPY . .

COPY package.json .

RUN apk add --no-cache python3 make g++

RUN npm ci

RUN npm run build

FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/ststic ./.next/static
COPY --from=builder /app/public ./public

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

CMD ["node", "server.js"]

