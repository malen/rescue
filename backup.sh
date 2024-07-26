#!/bin/bash

if [[ "$1" == "-h" ]];then
    echo "Usage: ./backup.sh <folder_path> [<backup_name>]"
else
    if [[ -z $2 ]];then
        bakup_file=backup.tar.gz
    else
        bakup_file=$2.tar.gz
    fi
    # $1 为需要备份的目录(log文件除外)
    tar --exclude='*.log' -czvf $bakup_file $1

    # 判断文件是否超过box的250M限制
    MAX_SIZE=$((250 * 1024 * 1024))
    FILE_SIZE=$(stat -c%s "$bakup_file")
    if [[ "$FILE_SIZE" > "$MAX_SIZE" ]]; then
        # 分割文件
        split -b 250M "$bakup_file" part$2_
        # 上传每一个分割文件
        for file in part$2_*; do
            curl -i -X POST "https://upload.box.com/api/2.0/files/content" \
                 -H "authorization: Bearer $accessToken" \
                 -F attributes='{"name":"'${file}'", "parent":{"id":"0"}}' \
                 -F file=@$file
        done
    else
    
        # 上传文件到box的根目录(box官网的curl命令中的url是错误的，缺少api路径)
        curl -i -X POST "https://upload.box.com/api/2.0/files/content" \
             -H "authorization: Bearer $accessToken" \
             -F attributes='{"name":"'${bakup_file}'", "parent":{"id":"0"}}' \
             -F file=@$bakup_file
    fi
fi
