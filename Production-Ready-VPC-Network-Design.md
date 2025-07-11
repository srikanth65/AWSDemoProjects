Visual Subnet Calculator: https://www.davidc.net/sites/default/subnets/subnets.html 

Production-ready VPC network design that supports Dev, Stage, Prod, and shared services (monitoring/logging) environments — with a solid tagging strategy to support governance, cost tracking, security, and automation.

**VPC Network Design for Dev, Stage, Prod, and Shared Services**

Environment isolation: Separate VPCs or logically separated subnets per environment

Multi-AZ deployment: High availability and fault tolerance

Centralized logging and monitoring (VPC peering or centralized shared VPC)

Tagging strategy: To support security, billing, automation, and management

🌐 1. Network Layout

**Option A: Single VPC per environment**

- vpc-dev, vpc-stage, vpc-prod, and vpc-monitoring
- Useful for strict isolation, easier IAM/SCP enforcement
- VPC Peering or Transit Gateway used for centralized access/logging

**Option B: One VPC, environment isolation via subnets and naming**

- Easier to manage for smaller orgs
- Use subnet CIDR ranges to separate environments

**PC Subnet CIDR calculator layout for Dev, Stage, and Prod environments — each with four logical tiers:**

- Web (Public)
- App (Private)
- DB (Private/Isolated)
- Monitoring/Logging (Private)

This layout ensures:

- Environment isolation
- High availability across multiple AZs
- Sufficient room for growth (scalable)
- Logical subnetting for network ACLs or routing

**Base CIDR Range Allocation**

  Environment	      VPC CIDR Block
    Dev	              10.10.0.0/16
    Stage	            10.20.0.0/16
    Prod	            10.30.0.0/16

We divide each /16 into smaller subnets for:

- AZ redundancy (2 or 3 AZs)
- Logical tiers (web, app, db, monitoring)

**Subnet CIDR Breakdown (per environment)**

Each /16 block is broken into /20 subnets (~4,096 IPs each), then /24 subnets (~256 IPs each) per AZ.

**Example: Dev (VPC: 10.10.0.0/16)**

- Tier	            Subnet CIDR Block	        AZ-a	            AZ-b	              AZ-c
- Web (Public)	    10.10.0.0/20	            10.10.0.0/24	    10.10.1.0/24	      10.10.2.0/24
- App (Private)	    10.10.16.0/20	            10.10.16.0/24	    10.10.17.0/24	      10.10.18.0/24
- DB (Private)	    10.10.32.0/20	            10.10.32.0/24	    10.10.33.0/24	      10.10.34.0/24
- Monitoring	      10.10.48.0/20	            10.10.48.0/24	    10.10.49.0/24	      10.10.50.0/24

**Same structure for Stage & Prod:**

**Stage VPC: 10.20.0.0/16**

  - Web: 10.20.0.0/20
  - App: 10.20.16.0/20
  - DB: 10.20.32.0/20

**Monitoring: 10.20.48.0/20**

**Prod VPC: 10.30.0.0/16**

- Web: 10.30.0.0/20
- App: 10.30.16.0/20
- DB: 10.30.32.0/20
- Monitoring: 10.30.48.0/20

**Naming Convention Suggestion**

- Resource Name	          Example
- VPC	                    vpc-dev, vpc-stage, vpc-prod
- Subnet (Web, AZ-a)	    dev-web-subnet-az-a
- Subnet (App, AZ-b)	    stage-app-subnet-az-b
- Route Table (App Tier)	rtb-prod-app
- Security Group (DB)	    sg-prod-db
- NAT Gateway	            nat-gw-stage-az-a

**Summary Table**

- Environment	      Tier	        Subnet Prefix	          Total /24s Available
- Dev	              Web	          10.10.0.0/20	              16
- Dev	              App	          10.10.16.0/20	              16
- Dev	              DB	          10.10.32.0/20	              16
- Dev	              Monitoring	  10.10.48.0/20	              16

Same structure for Stage (10.20.x.x) and Prod (10.30.x.x)


**When to Use a Separate Monitoring VPC**

- Criteria	                                                      Recommendation	                  Reason
- Medium to large scale org	                                      Separate Monitoring VPC	          Easier central management
- Security/compliance (e.g. PCI, HIPAA)	                          Separate Monitoring VPC	           Isolation reduces attack surface
- Centralized observability stack (ELK, Prometheus, Grafana, etc.) Separate Monitoring VPC	          Avoid duplication across VPCs.
- Dev/Stage	                                                       Keep inside same VPC	            Lower complexity
- Cost-sensitive or simple setup	                                 Inline monitoring/logging in same VPC	Simpler to maintain

**Separate Monitoring VPC — Yes or No?**

- **Use Case	                    Best Practice**
- Small/medium org	              Embed monitoring into each VPC via subnets (dev, stage, prod)
- Large org/regulated	            Use a separate VPC for monitoring/logging, with VPC peering or TGW
- Shared services	                Place ELK, Prometheus, Alertmanager, etc. in a shared VPC
- Security isolation needed	      Separate VPC helps limit blast radius and secure critical tools
- PCI/HIPAA/SOC2	                Mandatory to segregate logging/monitoring from runtime environments


**Benefits of Separate Monitoring VPC**

- Logical separation and reduced blast radius
- Easier centralization of alerts, dashboards, and log archives
- Simpler access control and routing via VPC peering or Transit Gateway
- Supports least-privilege IAM and strict security policies

**Shared Monitoring VPC (10.10.0.0/16)**

If used, it might include:

- **Subnet Type	          CIDR Block	          Purpose**
- Logging ingestion	      10.10.1.0/24	        Fluent Bit, Logstash
- Monitoring stack	      10.10.11.0/24	        Prometheus, Grafana, Loki
- Tracing tools	          10.10.21.0/24	        Jaeger, AWS X-Ray (collector)
- Storage/Archive	        10.10.31.0/24	        S3 interface endpoint, backups
- Security tools	        10.10.41.0/24	      	GuardDuty, Nessus, etc.

**Access & Routing Between VPCs**

- Use VPC Peering for simple setups (1:1 communication)
- Use Transit Gateway if managing 3+ VPCs with centralized access
- Allow only private subnets from app tiers to connect to logging VPC
- Use VPC Flow Logs and send to shared monitoring VPC

**Key Components per Environment**

 **Component	                    Description**
- VPC	                          Isolated per environment or shared with subnet-level isolation
- NAT Gateway	                  One per AZ for HA, or use single NAT (cost tradeoff)
- Internet Gateway	            For public subnet access
- Subnets	                      Public (for ALB/Bastion), Private App, Private DB
- Route Tables	                Separate route tables for public/private per AZ
- Security Groups	              Allow minimal required traffic; layered with NACLs as needed
- VPC Endpoints	                Use S3, DynamoDB endpoints to reduce NAT usage & increase security
- CloudWatchAgent/FluentBit    	Installed on nodes to forward logs/metrics
- Centralized Logging VPC	      Hosts ELK stack, Prometheus, or CloudWatch destination

**Security Considerations**

- Use AWS WAF and Shield on public-facing ALB
- Use IAM roles and least privilege for apps and services
- Encrypt all data at rest and in transit (EBS, RDS, S3 with KMS)
- Enable VPC flow logs and route to centralized logging VPC
- Private subnets have no IGW access, outbound via NAT only

**Tagging Strategy**

A consistent tagging strategy helps with cost allocation, security audits, automation, and resource governance.

 **Tag Key	              Example                 Value	Description**
- Environment	          dev, stage, prod	      Critical for segmentation
- Project	              website-backend	        Group resources by app/service
- Owner	                sri@example.com	        Accountable person or team
- Department	          Engineering, Finance	  Organizational context
- Terraform	            true	                  Helps identify IaC-managed resources
- CostCenter          	CC-00123	              Billing and chargeback
- Compliance	          pci, gdpr	              For regulated workloads
- Purpose	              app-server, db, lb	    Useful for cleanup and access policies
- Backup	               daily, none	          To enforce backup policies via automation

**Enforce tagging via:**

- AWS Organizations Service Control Policies (SCPs)
- AWS Config + Rules
- Terraform default_tags block

**Infrastructure as Code (Terraform/CDK)**

- Create separate modules: vpc, subnet, route, nat_gateway, alb, ec2, eks, rds
- Use input variables like env = "dev" to dynamically provision per environment
- Store remote state per environment (e.g., in S3 bucket with folders dev/, stage/, prod/)

**Monitoring + Logging Design**

  **Component                  	Usage**
- CloudWatch	                Metrics, Logs, Alarms for AWS services
- Fluent Bit	                Stream app logs from EC2/EKS to CloudWatch or ELK
- Prometheus + Grafana	      Custom app and infra monitoring
- AWS OpenSearch/ELK	        Centralized log search + alerting
- SNS or Slack Alerts	        For alert distribution
- X-Ray/Jaeger	              Tracing for microservices

**Recommendations**

- Feature	                    Recommended Practice
- CIDR Planning	              Assign /16 per VPC, split into /24 per subnet
- Monitoring Placement	      Centralized VPC if scaling, else per-env
- Subnet Isolation	          Use public/private/isolated subnet model
- Availability Zones	        Use 2–3 AZs for redundancy
- VPC Communication	          Use Transit Gateway for ≥3 VPCs
- Tagging	                    Enforce via SCP + Config rules
- security posture            Enable GuardDuty, Config, Security Hub
- auditability                Deploy Bastion Hosts via SSM Session Manager
- templatize VPCs             Service Catalog

**Optional: /23 or /22 Size Subnets**

If you want larger subnets for a busier dev environment:

**-   Subnet Size	        IPs per Subnet	        # of Subnets per /16	        Use Case Example**
-     /24	                256	                    256	                          Small services, HA setup
-     /23	                512	                    128	                          Medium-sized app clusters
-     /22	                1024	                  64	                          EKS or large-scale testing


**When working with AWS VPC subnets, not all IPs in a subnet are usable because AWS reserves 5 IP addresses per subnet:**

**AWS reserves:**
- First IP: Network address
- Second IP: VPC router
- Third IP: Reserved for AWS DNS
- Fourth IP: Reserved for future use
- Last IP: Broadcast address (even though AWS VPCs don't use broadcast)

**Usable IPs per Subnet Size**

 **CIDR Block	        Total IPs	        Usable IPs	          Typical Use Case**
  /28	                16	                11	              Tiny apps, NAT Gateway, testing
  /27	                32	                27	              Small services, Dev
  /26	                64	                59	              Low-traffic tiers
  /25	                128		              123              	Moderate apps or services
  /24	                256	                251	              General tier, standard subnet
  /23	                512	                507	              Busy app layer or EKS nodes
  /22	                1,024	              1,019	            Large-scale apps, EKS, batch

**Best practice in AWS: Avoid subnets smaller than /28 or larger than /16 in a single VPC.**
