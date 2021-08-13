# build stage
FROM nginx:alpine as build-stage
# Install npm and node
RUN apk add --update npm grep

# Add bash
RUN apk add --no-cache bash

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build


# production stage
FROM nginx:stable-alpine as production-stage
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build-stage /app/dist/. /usr/share/nginx/html/

CMD ["nginx", "-g", "daemon off;"]