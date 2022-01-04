FROM node:12-alpine as builder

WORKDIR /build

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

COPY ./graphql-api/package.json .
COPY ./graphql-api/yarn.lock .

RUN yarn install \
      --frozen-lockfile \
      --only=production \
      --silent \
      --no-progress \
      --no-audit

COPY ./graphql-api/src ./src
COPY ./graphql-api/ormconfig.js .
COPY ./graphql-api/doc ./doc
COPY ./graphql-api/tsconfig.json .
COPY ./graphql-api/release-scripts ./release-scripts

RUN DISABLE_ESLINT_PLUGIN=true yarn run build

FROM node:12-alpine as app

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&&  echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" >> /etc/apk/repositories \
&&  apk upgrade \
&& apk add --no-cache \
    curl \
    libstdc++ \
    chromium \
    harfbuzz \
    nss \
    freetype \
    ttf-freefont \
    font-noto-emoji \
    wqy-zenhei \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk

COPY --from=builder /build/node_modules/ /srv/node_modules/
COPY --from=builder /build/dist/ /srv/www/

USER node

EXPOSE 8080

CMD node --max-old-space-size=6144 /srv/www/src/cron-index.js
