# terraform-aws-presigned-url-demo
Demo of generating and uploading file with presigned url.
https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-presigned-url.html
https://boto3.amazonaws.com/v1/documentation/api/latest/guide/s3-presigned-urls.html
https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-post-example.html
https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-HTTPPOSTConstructPolicy.html

This demo will create S3 bucket and configure it as a website to host your static website. 
There is a code that will create and return a presigned URL. Then you can use this URL to upload a file to the website. 
There is a HTML Form version and AJAX version. AJAX is work-in-progress. 

For additional information, review the code.

# Caution
This demo generates actual live content. You must provide your own IP address or range to test this site. You will incur cost for resources that this demo will create for you. 

# How to use
1. Go to Demo directory
2. Rename sample.auto.Xtfvars to sample.auto.tfvars (safeguard this file!)
3. Do terraform init
4. Do terraform plan/apply
5. Browse to the output website link
6. Run terraform destroy
7. Select a file
8. Upload using form

# Some common errors
## Invalid according to Policy: Extra input fields: content-type
### Error
```
<Error>
<Code>AccessDenied</Code>
<Message>Invalid according to Policy: Extra input fields: content-type</Message>
<RequestId>CC28Z403KNJVJC07</RequestId>
<HostId>n0kM4ufcYg35vqpPahQYZNg/lm6gtI0CUuzJeK5VA/2YUlIJxBOpf0yELaslamiLT6F1NYWCD8g=</HostId>
</Error>
```
### Solution
I don't know why this is happening. If you try to have an input field in your Form for content-type, it will throw this warning. It must be picking it up from elsewhere as duplicate. But it doesn't seem to care if it's not there, so don't.

## InvalidAccessKeyId
### Error
```
<Error>
<Code>InvalidAccessKeyId</Code>
<Message>The AWS Access Key Id you provided does not exist in our records.</Message>
<AWSAccessKeyId>ASIASP232YVAUT4EGRO3</AWSAccessKeyId>
<RequestId>QQ5WX7BFG6JDN6WT</RequestId>
<HostId>PaAg3SBSEQqlOrrRCBjaktJi1u2FF4FfzQnB7NvDK5wOF2fNc3NY96EmQhbVD48cl+q916i1TMk=</HostId>
</Error>
```
### Solution
You'll see this a lot. It means you forgot another field. In my case, I was missing `x-amz-security-token` field. 






