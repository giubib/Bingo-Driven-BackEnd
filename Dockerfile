############ Build stage ############
FROM node:20-alpine3.18 AS builder      
WORKDIR /usr/src/app

COPY package*.json prisma ./
RUN npm ci
COPY . .
RUN npx prisma generate
RUN npx tsc
RUN npm prune --omit=dev                

############ Runtime stage ###########
FROM node:20-alpine3.18                 
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/dist         ./dist
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/prisma       ./prisma

ENV NODE_ENV=production
EXPOSE 5000
CMD ["node", "dist/src/server.js"]
