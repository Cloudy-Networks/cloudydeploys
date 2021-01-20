# OA

Theoa is some CloudFormation stacks that set up a working OpenArena server in AWS.  It is intended for both fun and profit. We like to play OA, but it is also being used as a playground to learn AWS services and features.  The end goal would be something generic and useful enough that someone could come along and grab the CF stack, and deploy it in their own account and get a working publicly accessible server to play on with no, or very minimal, changes to the CF code, or without needing in depth experience with AWS or CloudFormation.

OA was chosen as it is open source with dedicated servers and clients for all major OSes whose dedicated server has very low requirements (1 core .5 to 1g or RAM).  This makes it deployable in the AWS "Free Tier". It is also just a fun game.

## theoa-ec2.cf What it does so far
* deploys a VPC with a subnet and routing and gateway, etc...
* deploys an instance for the OA server with:
  * an EIP
  * parameterized choice of instance type appropriate for OA server.
  * automatically maps debian10 image for US regions
* defines a security group allowing OA port and ssh.
* runs a few lines of bash to set up the server, they do the following:
  * set up proper hostname
  * update and upgrade debian 10 with apt
  * install OA and extra maps via apt
  * grabs the `server.cfg` from the s3 bucket
  * reboots the server for good measure
* defines IAM roles to allow instance access to `server.cfg` in S3 bucket, a security measure so the bucket is not public, it is private and only our EC2 instance in our account can access it.

### Requirements / bootstraps

There are two bootstrapping CF stacks, both are required unless you edit the code on the main stack.
* theo-s3.cf - creates an S3 bucket where you will store your `server.cf`. If you don't want/need this, just remove the line from the UserData scripts that copies from s3, as well as the IAM resources. You'll end up with a local default `server.cfg`, good to go!
* theor53.cf - create a HostedZone and RecordSet for a domain and host recrod. You will need to change the domain to match yours, or you can choose not to use it. If you remove it delete the lines that alter the hostname in the UserDatas scripts for the instance.
* S3 buck with desired `server.cfg` in it, see `theoa-s3.cf`
* A KeyName in the account you are deploying in

### Things you may want/need to define/redefine yourself
* EIPAssociation for OA, either by providing EIP or AllocationId parameter
* define mapping for non-us regions, if that is your thing
* Change hostname in instance UserData script to match yours, or remove it if not needed
* Change the R53 domain and host record to match yours, or don't use it if not needed
* S3 bucket name/arn in cf and UserData script

## Deploy It

We assume you have the proper privileges in your account.

Edit the things that need to be edited to get what you want (domain, s3 bucket name, etc). Then do this:

1) run the s3 and r53 stacks
2) run the main stacks, choose VPC name, InstanceType and KeyName when prompted
3.5) fix any errors CloudFormation spits back at you.
4) play OA


## Todo's
* make bootstrapping easier/better; Goal, self contained or nested stack that has all you need, easy to use.
  * when starting OA server for the first time, if no `server.cfg` is available in the s3 bucket upload the default one to s3 bucket, if there is one available, only download it. Now we can use the same stack to make the s3 bucket and get a vanilla 'server.cfg' if its the first time you are running it.
* define an internal endpoint for the s3 bucket for even more security and profit
* OA allows downloading of extra resources the server has but the client doesn't, which works fine for small files, but for big files (large maps, etc) it is very slow as the bandwidth is limited by the code as they want you to host those files elsewhere so the OA server is not having to handle large downloads from clients. Set this up in a webserver on the instance, or in s3 perhaps? Maybe a fun excuse to try CloudFront? Static S3 website with CloudFront is an AWS approved thing to do... fun and profit!
