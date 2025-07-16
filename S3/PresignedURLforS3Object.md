**Presigned URL for S3 object**

Create S3 Bucket(without public access) – upload object: 

**Open aws cli:**  

aws s3 presign s3://bucketname/objectname --expires-in 6400  

Ex: aws s3 presign s3://a4lmedia34der43/aotm.jpg --expires-in 6400 
