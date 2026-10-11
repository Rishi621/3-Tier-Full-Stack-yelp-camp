# Use Node 22 s parent image
FROM node:22-alpine

# Change the working directory on the Docker image to /app
WORKDIR /app

# Copy package.json and package-lock.json to the /app directory
COPY package.json package-lock.json ./

# In short: We copy package files first because dependencies change less frequently than application code. Docker can cache the expensive npm ci step and reuse it during ordinary code changes, making your YelpCamp builds faster.

# Install dependencies
RUN npm install --production

# Copy the rest of project files into this image
COPY . .

# Expose application port
EXPOSE 3000

# Start the application
CMD npm start

#
## Suppose your package.json contains:
#
#json
#{
#  "dependencies": {
#    "express": "^4.17.1",
#    "mongoose": "^5.13.23"
#  },
#  "devDependencies": {
#    "nodemon": "^3.0.0"
#  }
#}
#Package
#
#Purpose
#
#Installed in production?
#
#express
#
#Runs the web server
#
#Yes
#
#mongoose
#
#Connects to MongoDB
#
#Yes
#
#nodemon
#
#Automatically restarts the app during development
#
#No
#
#2. Why use it in Docker?
#Your production container only needs packages required to run the application.
#
#Smaller image: Avoids unnecessary development tools.
#
#Faster installation: Fewer packages to install.
#
#Reduced attack surface: Fewer unnecessary packages in the runtime environment.
#
#3. Important distinction
#Your current package.json lists most packages under dependencies, not devDependencies. Therefore, --omit=dev will still install those packages, including Express, Mongoose, Passport, and Cloudinary.
