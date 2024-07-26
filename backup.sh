#!/bin/bash

if [[ "$1" -eq "-h" ]];then
    echo "Usage: ./backup.sh <folder_path> [<backup_name>]"
else
    # $1 为需要备份的目录(log文件除外)
    tar --exclude='*.log' -czvf $2.tar.gz $1
    
    if [[ -z $2 ]];then
        bakup_name=backup.tar.gz
    else
        bakup_name=$2.tar.gz
    fi
    # 上传文件到box的根目录(box官网的curl命令中的url是错误的，缺少api路径)
    curl -i -X POST "https://upload.box.com/api/2.0/files/content" \
         -H "authorization: Bearer $accessToken" \
         -F attributes='{"name":"'${bakup_name}'", "parent":{"id":"0"}}' \
         -F file=@$2.tar.gz
fi
