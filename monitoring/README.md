# Monitoring VM

Hosts our monitoring and analytics systems.

## Client

Contains states for the clients of our monitoring system (other VMs). Not run 
on the monitoring VM itself.

## rsyslog

Contains the rsyslog configuration to enable the monitoring VM to collect logs 
from all the other VMs, store them locally and send them into ElasticSearch for 
Kibana's use.

## [Sentry](getsentry.com)

Sentry monitors our application errors. It requires PostgreSQL and Redis on the 
VM, and is available [here](sentry.habhub.org).
