//Cria o role de segurança na aws

aws iam create-role \
    --role-name lambda-exemplo \
    --assume-role-policy-document file://politicas.json \
    | tee logs/role.log

//cria o arquivo e zipa
zip function.zip index.js

aws lambda create-function \
    --function-name hello-cli \
    --zip-file fileb://function.zip \
    --handler index.handler \
    --runtime nodejs12.x \
    --role arn:aws:iam::445818628006:role/lambda-exemplo \
    | tee logs/lambda-create.log

//invoca a lambda 
aws lambda invoke \
    --function-name hello-cli \
    --log-type Tail \
    logs/lambda.exec.log

//atualiza lambda
aws lambda update-function-code \
    --zip-file fileb://function.zip \
    --function-name hello-cli \
    --publish \
    | tee logs/lambda-update.log

//invoca e ver resultado
aws lambda invoke \
    --function-name hello-cli \
    --log-type Tail \
    logs/lambda-exec-update.log

//remove
aws lambda delete-function \
    --function-name hello-cli 

aws iam delete-role \
    --role-name lambda-exemplo 