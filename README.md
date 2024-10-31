# 🚀 A sample YAML configuration for deploying your Strapi image in Kubernetes

```
# Strapi Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: strapi
  name: strapi
spec:
  replicas: 1  # Number of replicas for scalability
  selector:
    matchLabels:
      app: strapi
  template:
    metadata:
      labels:
        app: strapi
    spec:
      volumes:
      - name: strapi-storage
        persistentVolumeClaim:
          claimName: strapi-pv-claim  # Link to PersistentVolumeClaim
      containers:
      - name: strapi
        image: ghcr.io/vpowler/strapi-image:latest  # Replace with your image URL
        imagePullPolicy: "Always"  # Always pull the latest image; change to "IfNotPresent" for stability
        volumeMounts:
          - name: strapi-storage
            mountPath: /opt/app/src/api
            subPath: "api"
          - name: strapi-storage
            mountPath: /opt/app/public/uploads
            subPath: "uploads"
        env:
        - name: HOST
          value: "0.0.0.0"  # Host binding
        - name: PORT
          value: "1337"  # Strapi default port
        # Strapi secrets and keys
        - name: APP_KEYS
          value: ""  # Set the application keys (comma-separated for production)
        - name: API_TOKEN_SALT
          value: ""  # Set API token salt
        - name: ADMIN_JWT_SECRET
          value: ""  # Admin panel JWT secret
        - name: TRANSFER_TOKEN_SALT
          value: ""  # Transfer token salt
        - name: JWT_SECRET
          value: ""  # JWT secret for user authentication
        # Database configuration
        - name: DATABASE_CLIENT
          value: "postgres"  # e.g., postgres, mysql, sqlite
        - name: DATABASE_HOST
          value: ""  # Database host
        - name: DATABASE_PORT
          value: ""  # Database port (5432 for PostgreSQL)
        - name: DATABASE_NAME
          value: ""  # Database name
        - name: DATABASE_USERNAME
          value: ""  # Database username
        - name: DATABASE_PASSWORD
          value: ""  # Database password
        - name: DATABASE_SSL
          value: "false"  # Enable SSL if required
---
# Strapi Service
apiVersion: v1
kind: Service
metadata:
  name: strapi-service
spec:
  type: NodePort  # Use LoadBalancer for external access if supported
  externalTrafficPolicy: Local
  selector:
    app: strapi
  ports:
  - name: web
    protocol: TCP
    port: 1337  # Strapi default port
    targetPort: 1337
---
# PersistentVolume for Strapi Data Storage
apiVersion: v1
kind: PersistentVolume
metadata:
  name: strapi-pv-volume
  labels:
    app: strapi
spec:
  capacity:
    storage: 40Gi  # Define the storage size
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce  # Adjust based on access needs
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual  # Storage class; adjust as needed
  hostPath:
    path: /mnt/strapi  # Local path on the Kubernetes node for storage
---
# PersistentVolumeClaim for Strapi Deployment
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: strapi-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 40Gi  # Request the same amount as the PersistentVolume
  storageClassName: manual

```
