# Monitoring VM

Hosts our monitoring and analytics systems.

## Client

Contains states for the clients of our monitoring system (other VMs). Not run 
on the monitoring VM itself.

This is not currently enabled anywhere.

## Logging

Contains our logging setup. Each VM forwards all syslog entries to 
monitoring.vm, which stores them on-disk for six months and saves them to 
ElasticSearch for one month for viewing with Kibana.

There's currently some problem where rsyslogd uses 100% CPU.

## [Sentry](getsentry.com)

Sentry monitors our application errors. It requires PostgreSQL and Redis on the 
VM, and is available [here](sentry.habhub.org).
