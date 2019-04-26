FROM node
WORKDIR /objVault-webApp
COPY package.json .
RUN npm install
COPY public/ ./public/
COPY src/ ./src/
RUN npm run build
CMD npm start
