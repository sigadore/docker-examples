# Building of NodeJS App
FROM node:12 as build-phase

ARG version="1.9.3"
ARG buildpath="asteriondb/oracle/objVault/javaScript/objVault-webapp-"${version}

EXPOSE 3000

RUN apk update \
 && apk add --no-cache tini

WORKDIR /objVault-webApp

COPY ${buildpath}/package*.json ./
RUN npm install \
 && npm cache clean --force

COPY ${buildpath}/. .
RUN npm run build \
 && chmod -R a+r build \
 && find build -type d -exec chmod a+x {} \;

# --> Alternative to handle signals correctly
# ENTRYPOINT [ "/sbin/tini", "--" ]
# CMD [ "node", "app.js" ]

CMD [ "npm", "start" ]

# Production harvest
FROM nginx
COPY --from=build-phase /objVault-webApp/build /usr/share/nginx/html
