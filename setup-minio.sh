#!/bin/sh

# Display default environment variables
declare user="${MINIO_ROOT_USER}"
declare password="${MINIO_ROOT_PASSWORD}"
declare host="http://localhost:9000"

# Check if the environment variables are set, if not, set them to default values
minio server /data --console-address :9001 &

echo "⏳ Waiting for MinIO..."
until curl -s $host/minio/health/live > /dev/null; do
  sleep 2
done
echo "✅ MinIO is ready."

# define the alias for the MinIO server
mc alias set minio $host $user $password

# Create a bucket named 'public' to store public datas
mc mb minio/public 
mc anonymous set download minio/public

# Create a private bucket to store private datas
mc mb minio/private 
mc anonymous set none minio/private

# Wait that 
wait