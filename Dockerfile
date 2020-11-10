FROM node:12-slim

WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn

COPY . . 

EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint.sh"]
CMD ["yarn", "dev"]
