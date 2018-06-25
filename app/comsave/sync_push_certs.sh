#!/bin/bash

mc mirror --overwrite --remove /etc/letsencrypt s3/$S3FS_BUCKET
