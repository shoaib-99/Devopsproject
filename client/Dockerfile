FROM node:14-apline as build
RUN mkdir -p /home/app
RUN npm install
RUN npm run build
COPY . /home/app
CMD ["node", "home/app/App.js"]
