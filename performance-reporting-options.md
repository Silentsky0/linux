# Performance reporting options

- `systemd-analyze`
  - ```
    root@syzkaller:~# systemd-analyze
    Startup finished in 4.857s (kernel) + 3.840s (userspace) = 8.697s
    ```

- `top`
  - ```
    top - 18:15:17 up 7 min,  1 user,  load average: 0.00, 0.00, 0.00
    Tasks:  66 total,   1 running,  31 sleeping,   0 stopped,   0 zombie
    %Cpu(s):  0.0 us,  0.5 sy,  0.0 ni, 99.5 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
    KiB Mem :  1705052 total,  1539132 free,   105328 used,    60592 buff/cache
    KiB Swap:        0 total,        0 free,        0 used.  1560296 avail Mem
    ```

- `vmstat`
  - ```
    root@syzkaller:~# vmstat
    procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
     0  0      0 1538880   4096  56496    0    0    34     1   28   21  0  1 99  0  0
    ```
