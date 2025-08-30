#!/bin/bash
# /d/alx/alx-backend-graphql_crm/crm/cron_jobs/clean_inactive_customers.sh


# Add Django project root to PYTHONPATH
export PYTHONPATH=/d/alx/alx-backend-graphql_crm

# Set Django settings using the folder with dashes in quotes
export DJANGO_SETTINGS_MODULE="alx-backend-graphql_crm.settings"

# Move to project root
cd /d/alx/alx-backend-graphql_crm

# Delete inactive customers
DELETED_COUNT=$(python manage.py shell -c "
from crm.models import Customer
from django.utils import timezone
from datetime import timedelta

one_year_ago = timezone.now() - timedelta(days=365)
deleted, _ = Customer.objects.filter(orders__isnull=True, created_at__lt=one_year_ago).delete()
print(deleted)
")

# Log deleted count
echo "$(date): Deleted $DELETED_COUNT inactive customers" >> /tmp/customer_cleanup_log.txt
