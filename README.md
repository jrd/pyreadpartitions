pyreadpartitions
================

Read MBR and GPT partitions directly in python.

Examples:

```python
from pyreadpartitions import get_disk_partitions_info
with open('/dev/sda', 'rb') as fp:
    info = get_disk_partitions_info(fp)
    print(info.mbr)
    print(info.gpt)
```

```python
from pyreadpartitions import show_disk_partitions_info
with open('/dev/sda', 'rb') as fp:
    show_disk_partitions_info(fp)
```

A console script is also available:

```sh
$ sudo cat /dev/sda | pyreadpartitions
```

or if you already have access to a file or directly to the disk:

```sh
# pyreadpartitions /dev/sda
```
