FROM node:18-alpine AS build
WORKDIR /opt/app
COPY . .
RUN npm install
RUN npm run build

FROM node:18-alpine
WORKDIR /opt/app
RUN npm install -g serve
COPY --from=build /opt/app/build ./build
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]