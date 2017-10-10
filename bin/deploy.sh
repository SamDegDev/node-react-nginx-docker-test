#!/bin/bash
if git diff-index --quiet HEAD --; then
    set -o errexit; # Exit on error
echo Step 1/4: Creating production build;
    npm run deploy:prod;
echo Step 2/4: Archiving previous production image;
    now=$(date +"%m_%d_%Y");
    docker tag samdegdev/node-react-nginx-prod:latest samdegdev/node-react-nginx-prod:$now;
    docker push samdegdev/node-react-nginx-prod:$now;
echo Step 3/4: Creating new production image;
    mv Dockerfile.prod.off Dockerfile;
    npm run build:prod;
    mv Dockerfile Dockerfile.prod.off;
    docker push samdegdev/node-react-nginx-prod;
echo Step 4/4: Creating elastic beanstalk environment;
eb $1 node-react-nginx-prod;
else
    echo Please commit your changes first.;
fi