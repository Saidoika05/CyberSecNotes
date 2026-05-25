```bash
<command> | cut -c -[num] 
#cut the output at [num] symbol position from left to the right
ps aux --sort=-%mem | head -n 10 | cut -c -105
#review processes that use RAM
``` 

```bash
sudo du -sh /* 2>/dev/null | sort -hr
#show disk partition and storage usage
ncdu /
```

