FROM node:20-alpine
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev git py3-setuptools

ENV NODE_ENV=production
ENV SCRIPT_NAME=start

WORKDIR /opt/

COPY . .

RUN npm install -g node-gyp
RUN yarn install --production
RUN yarn build

RUN chown -R node:node /opt
USER node

EXPOSE 1337

CMD yarn $SCRIPT_NAME
