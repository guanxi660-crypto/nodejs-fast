FROM node:20-alpine

WORKDIR /app

COPY package.json ./
RUN npm install

COPY index.js index.html ./

EXPOSE 3000

CMD ["node", "index.js"]
