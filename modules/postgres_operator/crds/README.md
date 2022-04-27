# Postgres-Operator crds

*Postgres-Operator* crds are installed independently of `postgres-operator`. Before
*Postgres-Operator* can be updated you need to fetch the updated crds using the
`update-crds.sh` script.

```bash
./update-crds.sh v1.X.Y
```

This will create a new directory for the `v1.X.Y` version crds and pull
all the crds for this version.
