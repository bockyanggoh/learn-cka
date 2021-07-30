etcd is the backend data storage solution for kubernetes.
All objects, applications and configurations are stored in etcd.

Therefore it is crucial to back it up for restoration usage.

## Backup
To Backup use the etcdctl commandline tool.

```ETCDCTL_API=3 etcdctl snapshot save <file_name>```

## Restore
To Restore
```ETCDCTL_API=3 etcdctl snapshot restore <file_name>```