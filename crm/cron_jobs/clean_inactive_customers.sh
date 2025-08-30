#!/bin/bash
# Path: /d/alx/alx-backend-graphql_crm/crm/cron_jobs/clean_inactive_customers.sh


# Set Django settings
export DJANGO_SETTINGS_MODULE=crm_project.settings

# Run Django shell to delete inactive customers and save count
DELETED_COUNT=$(python manage.py shell -c "
from crm.models import Customer
from django.utils import timezone
from datetime import timedelta

one_year_ago = timezone.now() - timedelta(days=365)
deleted, _ = Customer.objects.filter(orders__isnull=True, created__lt=one_year_ago).delete()
print(deleted)
")

# Log the number of deleted customers with timestamp
echo \"\$(date): Deleted \$DELETED_COUNT inactive customers\" >> /tmp/customer_cleanup_log.txt
