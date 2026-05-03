# Network Notes

Works best when peers are on same Wi-Fi or Ethernet segment and router allows client-to-client traffic.

Expected host pattern:

```text
10.x.x.x
192.168.x.x
172.16.x.x - 172.31.x.x
```

If call connects but remote video stays blank, likely LAN blocks peer-to-peer UDP. Use different network or add relay mode later.
