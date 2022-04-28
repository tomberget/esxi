# Prometheus-Operator crds

*Prometheus-Operator* crds are installed independently of `kube-prometheus-stack`. Before
*Prometheus-Operator* can be updated you need to fetch the updated crds using the
`update-crds.sh` script.

```bash
./update-crds.sh v0.54.0
```

This will create a new directory for the `v0.54.0` version crds and pull
all the crds for this version.
