echo "installation du cluster polar"
minikube start --cpus 2 --memory 4g --driver docker --kubernetes-version v1.30.5 --profile polar
echo "******installation du contrôleur Ingress dans le cluster polar"
minikube addons enable ingress -p polar
echo "assignation de polar comme cluster par défaut"
minikube profile polar