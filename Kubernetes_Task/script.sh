#!/bin/bash

APP1_IMAGE="rahulrajak/app1:latest"
APP2_IMAGE="rahulrajak/app2:latest"

NAMESPACE="default"


echo "Building Docker images..."

docker build -t $APP1_IMAGE ./app1
docker build -t $APP2_IMAGE ./app2


echo "Pushing Docker images to Docker Hub..."
docker push $APP1_IMAGE
docker push $APP2_IMAGE


echo "Deploying applications to Kubernetes..."


kubectl apply -f ./app1-deployment.yaml -n $NAMESPACE
kubectl apply -f ./app2-deployment.yaml -n $NAMESPACE


echo "Waiting for deployments to be ready..."

kubectl rollout status deployment/app1 -n $NAMESPACE
kubectl rollout status deployment/app2 -n $NAMESPACE

echo "Exposing services..."

kubectl expose deployment app1 --type=LoadBalancer --name=app1-service -n $NAMESPACE
kubectl expose deployment app2 --type=LoadBalancer --name=app2-service -n $NAMESPACE


echo "Waiting for services to be exposed..."
kubectl get svc -n $NAMESPACE


EXTERNAL_IP=""
while [ -z "$EXTERNAL_IP" ]; do
  EXTERNAL_IP=$(kubectl get svc app1-service -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  if [ -z "$EXTERNAL_IP" ]; then
    echo "Waiting for LoadBalancer IP to be assigned..."
    sleep 5
  fi
done

echo "App1 exposed at: http://$EXTERNAL_IP:5000"
echo "App2 exposed at: http://$EXTERNAL_IP:5001"


echo "Testing HTTP response from app1..."
curl "http://$EXTERNAL_IP:5000"

echo "Testing HTTP response from app2..."
curl "http://$EXTERNAL_IP:5001"

# End of script
echo "Deployment and testing complete."
