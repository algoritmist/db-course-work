#!/bin/bash
psql -h pg -d studs -f drop.sql
psql -h pg -d studs -f create.sql
psql -h pg -d studs -f populate.sql
