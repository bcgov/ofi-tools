#Build production frontend
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY ./package*.json ./
RUN npm ci --no-optional

COPY ./ ./
ENV NODE_ENV "production"
RUN npm run build


#Actual container

FROM caddy:2.1.1-alpine

WORKDIR /app
COPY --from=build-stage /app/dist /app
RUN chmod 777 /app
RUN chmod 777 /app/js
RUN mv /app/js/app*.js /tmp/
RUN chmod 777 /tmp/*

ENV NODE_ENV "production"

EXPOSE 8080

WORKDIR /etc
COPY Caddyfile /etc/caddy/Caddyfile
COPY entrypoint.sh /etc/entrypoint.sh
RUN chmod ugo+x /etc/entrypoint.sh
ENTRYPOINT [ "/etc/entrypoint.sh" ]