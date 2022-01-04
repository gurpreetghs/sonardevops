
# Review Tags here https://hub.docker.com/r/bitnami/pgbouncer/tags/
# Changelog:
# Initial PGBouncer release to Signatry - 1.16.1-debian-10-r17 (Published 11-30-21)
FROM docker.io/bitnami/pgbouncer:1.16.1-debian-10-r17

COPY ./cd/userlist.txt /etc/pgbouncer/
