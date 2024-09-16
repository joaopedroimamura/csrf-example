FROM node:14-alpine
WORKDIR /app
COPY index.html .
COPY server.js .
RUN npm init -y && npm install express
EXPOSE 8080
CMD ["node", "server.js"]
