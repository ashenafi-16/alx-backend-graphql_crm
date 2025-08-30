#!/bin/bash
# crm/cron_jobs/clean_inactive_customers.sh

# Activate virtual environment (adjust path if needed)
source /path/to/venv/bin/activate

# Set Django project settings
export DJANGO_SETTINGS_MODULE=crm_project.settings

# Run Django shell command to delete inactive customers
DELETED_COUNT=$(python manage.py shell -c "
from crm.models import Customer
from django.utils import timezone
from datetime import timedelta

one_year_ago = timezone.now() - timedelta(days=365)
deleted, _ = Customer.objects.filter(orders__isnull=True, created__lt=one_year_ago).delete()
print(deleted)
" )

# Log the number of deleted customers with timestamp
echo \"\$(date): Deleted \$DELETED_COUNT inactive customers\" >> /tmp/customer_cleanup_log.txt
