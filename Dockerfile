# Build the site, then serve it. Nothing from the build stage ships except public/.
FROM hugomods/hugo:0.165.0 AS build
WORKDIR /src
COPY . .
RUN hugo --minify --gc

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
