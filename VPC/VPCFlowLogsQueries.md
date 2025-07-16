VPC Flow Log Format
By default, each flow log record looks like this (default format):

pgsql

version account-id interface-id srcaddr dstaddr srcport dstport protocol packets bytes start end action log-status
Example:

2 123456789012 eni-abc123de 10.0.1.23 172.16.0.45 44321 443 6 10 840 1626869000 1626869060 ACCEPT OK

Key fields:
- Field	Description
- srcaddr	Source IP address
- dstaddr	Destination IP address
- srcport	Source port number
- dstport	Destination port number
- protocol	Protocol number (6 = TCP, 17 = UDP, etc.)
- action	ACCEPT or REJECT
- log-status	OK, NODATA, or SKIPDATA

# VPC Flow Logs queries using CloudWatch Logs Insights

Make sure you select the correct Log Group (e.g., /aws/vpc/flow-logs/vpc-xxxxxxxx) before running the query.

🔎 1. All recent logs (last 20 entries)

fields @timestamp, interfaceId, srcAddr, dstAddr, srcPort, dstPort, protocol, packets, bytes, action
| sort @timestamp desc
| limit 20

❌ 2. Only Rejected Traffic

fields @timestamp, srcAddr, dstAddr, srcPort, dstPort, protocol, action
| filter action = "REJECT"
| sort @timestamp desc
| limit 20

✅ 3. Only Accepted Traffic

fields @timestamp, srcAddr, dstAddr, srcPort, dstPort, protocol, action
| filter action = "ACCEPT"
| sort @timestamp desc
| limit 20


📊 4. Top Talkers by Source IP (high traffic sources)

fields srcAddr, bytes
| stats sum(bytes) as totalBytes by srcAddr
| sort totalBytes desc
| limit 10

📍 5. Traffic from a Specific Source IP

fields @timestamp, srcAddr, dstAddr, srcPort, dstPort, protocol, action
| filter srcAddr = "10.0.0.1"
| sort @timestamp desc
| limit 20

⚠️ 6. Unusual Ports Accessed (non-standard)

fields dstPort, srcAddr, dstAddr, action
| filter dstPort > 1024
| sort dstPort desc
| limit 20

⏳ 7. High Packet Count Sessions

fields srcAddr, dstAddr, packets, bytes
| filter packets > 1000
| sort packets desc
| limit 10

8. All REJECTED traffic

fields @timestamp, interfaceId, srcAddr, dstAddr, dstPort, protocol, action
| filter action = 'REJECT'
| sort @timestamp desc
| limit 50

9. Top 10 source IPs by byte count

fields srcAddr, bytes
| stats sum(bytes) as totalBytes by srcAddr
| sort totalBytes desc
| limit 10


10. Traffic to a specific port (e.g., SSH - 22 or HTTPS - 443)

fields @timestamp, srcAddr, dstAddr, dstPort, protocol, action
| filter dstPort = 22
| sort @timestamp desc
| limit 50

11. Show only accepted traffic

fields @timestamp, srcAddr, dstAddr, action
| filter action = 'ACCEPT'
| sort @timestamp desc
| limit 50

12. Total bytes by destination IP

fields dstAddr, bytes
| stats sum(bytes) as totalBytes by dstAddr
| sort totalBytes desc
| limit 10

13.Denied traffic for a specific subnet or IP

fields @timestamp, srcAddr, dstAddr, dstPort, action
| filter action = 'REJECT' and (srcAddr like /10\.0\./ or dstAddr like /10\.0\./)
| sort @timestamp desc
| limit 50

14.Traffic from a specific IP over last 1 hour

fields @timestamp, srcAddr, dstAddr, bytes, action
| filter srcAddr = 'X.X.X.X'
| sort @timestamp desc
| limit 100
Use the time range selector in CloudWatch to choose "Last 1 hour".

15. Internal traffic (same subnet or VPC)

fields @timestamp, srcAddr, dstAddr, bytes
| filter srcAddr like /10\.0\./ and dstAddr like /10\.0\./
| sort @timestamp desc
| limit 50

16. Traffic volume per protocol

fields protocol, bytes
| stats sum(bytes) as totalBytes by protocol
| sort totalBytes desc

17. Connections that failed (bytes = 0)

fields @timestamp, srcAddr, dstAddr, dstPort, bytes
| filter bytes = 0
| sort @timestamp desc
| limit 50






