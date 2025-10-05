FROM node:21-alpine3.18 AS builder
WORKDIR /frontend
COPY . .
RUN npm ci --silent
RUN npm run build
RUN npm prune --omit=dev

FROM node:21-alpine3.18 AS runner
WORKDIR /frontend

COPY --from=builder /frontend/.next /frontend/.next
COPY --from=builder /frontend/node_modules /frontend/node_modules
COPY --from=builder /frontend/package.json /frontend/
COPY --from=builder /frontend/public /frontend/public

ENV PORT 80
EXPOSE 80

ENTRYPOINT ["npm", "start"]

