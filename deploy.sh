#!/bin/bash

BUCKETNAME="crud-api-bucket"

if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]; then

    echo "Arguments must be exactly 4. Try: create, read, update, delete"

    exit 1

else
  
    echo "Compressing...."

    sleep 2

    cd $(pwd)/functions/
    zip ${1}.zip ${1}.py
    
    cd -

    cd $(pwd)/functions/
    zip ${2}.zip ${2}.py
    
    cd -

    cd $(pwd)/functions/
    zip ${3}.zip ${3}.py
    
    cd -

    cd $(pwd)/functions/
    zip ${4}.zip ${4}.py
    
    cd -

    read -p "Enter Region: " REGION

    echo "Creating S3 Bucket..."

    sleep 2

    aws s3api create-bucket --bucket $BUCKETNAME --region $REGION

    echo "Copying Function Artifacts to S3 Bucket..."

    sleep 2

    aws s3 cp $(pwd)/functions/${1}.zip  s3://$BUCKETNAME/v1.0.0/${1}.zip

    aws s3 cp $(pwd)/functions/${2}.zip  s3://$BUCKETNAME/v1.0.0/${2}.zip

    aws s3 cp $(pwd)/functions/${3}.zip  s3://$BUCKETNAME/v1.0.0/${3}.zip

    aws s3 cp $(pwd)/functions/${4}.zip  s3://$BUCKETNAME/v1.0.0/${4}.zip

    echo "Creating Infrastructure..."

    sleep 2

    terraform init
    terraform apply 

    echo "DONE"
    
    exit 0

fi