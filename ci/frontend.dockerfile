FROM node:12-alpine as builder

ENV NEW_RELIC_DISTRIBUTED_TRACING_ENABLED = true
ENV NEW_RELIC_APP_NAME = Signatry
ENV NEW_RELIC_LICENSE_KEY = c0fd2080f79bcabc41e78215bc54f39a841eNRAL
ENV NEW_RELIC_NO_CONFIG_FILE = true

RUN apk add --no-cache \
      python3 \
      make \
      gcc \
      g++

WORKDIR /source

COPY ./react-client/package.json .
COPY ./react-client/yarn.lock .

RUN yarn install \
      --frozen-lockfile \
      --only=production \
      --silent \
      --no-progress \
      --no-audit

COPY ./react-client/src ./src
COPY ./react-client/amplify ./amplify
COPY ./react-client/public ./public
COPY ./react-client/tsconfig.json .

RUN DISABLE_ESLINT_PLUGIN=true yarn run build:ci \
&&  rm -rf ./node_modules

FROM nginx:stable-alpine as app

COPY --from=builder /source/build/ /srv/www/
COPY ./ci/frontend.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
