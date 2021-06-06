FROM mhart/alpine-node:16@sha256:828042a9a8f37e47147f7b74c6bb91d230ee3ba6d34674cde1bbc61f1f55c14e

MAINTAINER Leonardo Gatica <lgatica@protonmail.com> (https://about.me/lgatica)

# Native dependencies
RUN apk add --update make gcc g++ python curl git imagemagick
RUN apk add sane --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
# NPM dependencies (cache)
ADD package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/
# Remove Native dependencies
RUN apk del make gcc g++ python curl && rm -rf /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp

ADD . /opt/app
WORKDIR /opt/app
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
