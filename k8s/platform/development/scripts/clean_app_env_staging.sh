cd ../../../applications

cd catalog-service/staging
kubectl delete -k .

cd ../..

cd order-service/staging
kubectl delete -k .

cd ../..

cd dispatcher-service/staging
kubectl delete -k .

cd ../..

cd edge-service/staging
kubectl delete -k .