FROM node:18 as build

# Declare the ARG before usage
ARG localconfig

# Set the working directory
WORKDIR /app

# Set the PATH
ENV PATH /app/node_modules/.bin:$PATH

# Copy the source code
COPY . .

# Dynamically create local_config.js if ARG is provided
RUN echo "$localconfig" > /app/src/local_config.js

# Install dependencies
RUN yarn install

# Build the application
RUN yarn build

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy nginx configuration files
COPY deploy/default.conf /etc/nginx/conf.d/default.conf
COPY deploy/nginx.conf /etc/nginx/nginx.conf

# Copy the built application
COPY --from=build /app/dist /usr/share/nginx/html

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
