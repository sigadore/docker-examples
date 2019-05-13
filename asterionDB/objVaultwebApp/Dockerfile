# Building of NodeJS App
FROM node as build-phase
WORKDIR /objVault-webApp
COPY package.json .
RUN npm install
COPY . .
RUN npm run build \
 && chmod -R a+r build \
 && find build -type d -exec chmod a+x {} \;
CMD npm start

# Production harvest
FROM nginx
COPY --from=build-phase /objVault-webApp/build /usr/share/nginx/html
