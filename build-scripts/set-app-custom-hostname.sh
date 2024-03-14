#!/usr/bin/env bash

# Parse command line parameters
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --site-name) site_name="$2"; shift ;;
    --dns-resource-group) dns_resource_group="$2"; shift ;;
    --zone-name) zone_name="$2"; shift ;;
    --record-set-name) record_set_name="$2"; shift ;;
    --app-id) app_id="$2"; shift ;;
    --dns-subscription-id) dns_subscription_id="$2"; shift ;;
    --azure-subscription-id) azure_subscription_id="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

# Set active subscription
az account set --subscription "$dns_subscription_id"

# Set DNS CNAME alias record
cname_record_id=$(az network dns record-set cname list \
  -g "$dns_resource_group" \
  -z "$zone_name" \
  -o json \
  | jq -r '.[] | select(.name == "'"$record_set_name"'") | .id')

az resource update \
  --ids "$cname_record_id" \
  --set \
    properties.targetResource.id="$app_id" \
    properties.TTL=600

# Reset active subscription
az account set --subscription "$azure_subscription_id"

# Add custom domain
az staticwebapp hostname set \
  --name "$site_name" \
  --hostname "$record_set_name.$zone_name"
