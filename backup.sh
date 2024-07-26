#!/bin/bash

# $1 为需要备份的目录(log文件除外)
tar --exclude='*.log' -czvf backup.tar.gz $1

# 上传文件到box的根目录(box官网的curl命令中的url是错误的，缺少api路径)
curl -i -X POST "https://upload.box.com/api/2.0/files/content" \
     -H "authorization: Bearer $accessToken" \
     -F attributes='{"name":"backup.tar.gz", "parent":{"id":"0"}}' \
     -F file=@backup.tar.gz
