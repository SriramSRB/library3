FROM node:20
WORKDIR /library3
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD [ "node", "server.js" ]