#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Navigate to the project directory
cd "$PROJECT_DIR"

# Execute Python command to delete inactive customers and log the results
echo "Running customer cleanup at $(date)" >> /tmp/customer_cleanup_log.txt
python3 manage.py shell << EOF >> /tmp/customer_cleanup_log.txt 2>&1
from django.utils import timezone
from datetime import timedelta
from customers.models import Customer
from orders.models import Order

# Calculate date one year ago
one_year_ago = timezone.now() - timedelta(days=365)

# Find customers with no orders in the past year
inactive_customers = Customer.objects.filter(
    orders__isnull=True
) | Customer.objects.filter(
    orders__created_at__lt=one_year_ago
).distinct()

count = inactive_customers.count()
inactive_customers.delete()

print(f"Deleted {count} inactive customers at {timezone.now()}")
EOF

echo "Cleanup completed at $(date)" >> /tmp/customer_cleanup_log.txt