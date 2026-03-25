#!/bin/bash

# Script to load secrets from .env file and create/update a Kubernetes secret in kube-system namespace
# This script is idempotent - re-running it will update the existing secret

set -euo pipefail

SECRET_NAME="app-secrets"
NAMESPACE="kube-system"

# Load all non-comment, non-empty lines from .env
# Build the --from-literal arguments for kubectl
from_literal_args=()
while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^#.* ]] && continue
    
    # Split on first '=' only
    key="${line%%=*}"
    value="${line#*=}"
    
    # Trim whitespace
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    
    # Remove surrounding quotes from value
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"
    
    # Skip if key is empty
    [[ -z "$key" ]] && continue
    
    from_literal_args+=("--from-literal=${key}=${value}")
done < "scripts/.env"

# Check if we found any secrets
if [ ${#from_literal_args[@]} -eq 0 ]; then
    echo "Warning: No secrets found in $ENV_FILE"
    exit 0
fi

kubectl create secret generic "$SECRET_NAME" \
    -n "$NAMESPACE" \
    "${from_literal_args[@]}" \
    --dry-run=client \
    -o yaml | kubectl apply -f -

echo "Secret '$SECRET_NAME' in namespace '$NAMESPACE' has been created/updated successfully"
