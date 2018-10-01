#!/bin/bash

# mc config host add s3 $S3FS_ENDPOINT $S3FS_ACCESSKEY $S3FS_SECRETKEY
mkdir /root/.mc
touch /root/.mc/config.json

cat > /root/.mc/config.json <<EOF
{
	"version": "9",
	"hosts": {
		"s3": {
			"url": "$S3FS_ENDPOINT",
			"accessKey": "$S3FS_ACCESSKEY",
			"secretKey": "$S3FS_SECRETKEY",
			"api": "S3v4",
			"lookup": "dns"
		}
	}
}
EOF
