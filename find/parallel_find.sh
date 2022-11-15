time find /path -maxdepth 0 -type d |  parallel -j 100 "ds -d 0 -m 0 {} | tr '\n' ' ' && echo"
