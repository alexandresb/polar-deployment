cd ../../../applications

cd catalog-service/staging
kubectl apply -k .

cd ../..

cd order-service/staging
kubectl apply -k .

cd ../..

cd dispatcher-service/staging
kubectl apply -k .

cd ../..

cd edge-service/staging
kubectl apply -k .