############ Build stage ############
FROM node:20-alpine3.18 AS builder     
WORKDIR /usr/src/app

COPY package*.json prisma ./
RUN npm ci
COPY . .
RUN npx prisma generate
RUN npx tsc

############ Test stage #
# — used only by CI / docker‑compose‑test.yml —
FROM builder AS test                    
CMD ["npm","run","test:ci"]

########## Runtime (prod) #
FROM node:20-alpine3.18 AS prod
WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/dist         ./dist
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/prisma       ./prisma
RUN npm prune --omit=dev                      

ENV NODE_ENV=production
EXPOSE 5000
CMD ["node","dist/src/server.js"]
