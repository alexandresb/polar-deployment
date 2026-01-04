echo "\n📦 Déploiement de Keycloak..."

kubectl apply -f ../services/keycloak-config.yaml
kubectl apply -f ../services/keycloak.yaml

sleep 5

echo "\n⌛ en attente du déploiement complet keycloak..."

while [ $(kubectl get pod -l app=polar-keycloak | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ en attente Keycloak en état READY..."

kubectl wait \
  --for=condition=ready pod \
  --selector=app=polar-keycloak \
  --timeout=300s

#echo "\n⌛ Ensuring Keycloak Ingress is created..."
#kubectl apply -f services/keycloak.yml

echo "\n📦 Déploiement PostgreSQL..."

kubectl apply -f ../services/postgresql.yaml

sleep 5

echo "\n⌛ en attente Postgres complètement déployé ..."

while [ $(kubectl get pod -l db=polar-postgres | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ En attente Postgres en état READY..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=polar-postgres \
  --timeout=180s

echo "\n📦 Déploiement Redis..."

kubectl apply -f ../services/redis.yaml

sleep 5

echo "\n⌛ En attente Redis complètement deployé..."

while [ $(kubectl get pod -l db=polar-redis | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ En attente Redis en état READY..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=polar-redis \
  --timeout=180s

echo "\n📦 Déploiement RabbitMQ..."

kubectl apply -f ../services/rabbitmq.yaml

sleep 5

echo "\n⌛ En attente RabbitMQ complètement deployé..."

while [ $(kubectl get pod -l db=polar-rabbitmq | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ En attente Redis en état READY ..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=polar-rabbitmq \
  --timeout=180s

echo "\n📦 Déploiement Polar UI..."

kubectl apply -f ../services/polar-ui.yaml

sleep 5

echo "\n⌛ En attente Polar UI complètement déployé..."

while [ $(kubectl get pod -l app=polar-ui | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ En attente Polar UI en état READY ..."

kubectl wait \
  --for=condition=ready pod \
  --selector=app=polar-ui \
  --timeout=180s