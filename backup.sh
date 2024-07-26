#!/bin/bash

# $1 为需要备份的目录(log文件除外)
tar --exclude='*.log' -czvf $1.tar.gz $2

bakup_name=$1.tar.gz
# 上传文件到box的根目录(box官网的curl命令中的url是错误的，缺少api路径)
curl -i -X POST "https://upload.box.com/api/2.0/files/content" \
     -H "authorization: Bearer $accessToken" \
     -F attributes='{"name":"'${bakup_name}', "parent":{"id":"0"}}' \
     -F file=@$1.tar.gz
