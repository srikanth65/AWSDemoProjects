**Enable S3 Replication Across Different AWS Accounts**
<details>
   
<summary> Account A </summary> 

- Region: us-east-1 

- S3 Bucket name: create a bucket with name:  account-a-us-east-1 and Enable bucket versioning  

- Go to S3Bucket – Replication Rules – Create a rule: Give replication rule name - Select the source bucket details and rule scope - Destination: Specify a bucket in another account, account ID, Bucket name - Create a new role and SAVE 

- COPY the IAM role ARN number

</details>

<details>
   
<summary>Account B </summary>  

- S3 Bucket name: Create a bucket with name account-b-us-west-1 and Enable bucket versioning 

S3 Bucket – Permissions – Bucket Policy – edit - Use this policy: https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-walkthrough-2.html 

- Replace with IAM role ARN number from Account A  

- Replace resource with Account B bucket ARN – account-b-us-west-1


</details>

<details>
<summary>Bucket Policy </summary>
```
{ 

   "Version":"2012-10-17", 

   "Id":"", 

   "Statement":[ 

      { 

         "Sid":"Set-permissions-for-objects", 

         "Effect":"Allow", 

         "Principal":{ 

            "AWS":"arn:aws:iam::source-bucket-account-ID:role/service-role/source-account-IAM-role" 

         }, 

         "Action":["s3:ReplicateObject", "s3:ReplicateDelete"], 

         "Resource":"arn:aws:s3:::amzn-s3-demo-destination-bucket/*" 

      }, 

      { 

         "Sid":"Set permissions on bucket", 

         "Effect":"Allow", 

         "Principal":{ 

            "AWS":"arn:aws:iam::source-bucket-account-ID:role/service-role/source-account-IAM-role" 

         }, 

         "Action":["s3:GetBucketVersioning", "s3:PutBucketVersioning"], 

         "Resource":"arn:aws:s3:::amzn-s3-demo-destination-bucket" 

      } 

   ] 

} 
```
 </details>

 
