# rescue
Rescue my Linux OS

## 使用前提
需要注册一个Box账号，创建一个App，并取得开发人员令牌(这里称为AccessToken)

## 使用方法
进入Linux 系统的救援模式。这里是通过挂在系统安装盘，然后选择Troubleshooting -> Rescue a Rocky Linux system进入。
选1)Continue, 然后根据提示执行下面命令，就能进入自己的系统。
```bash
chroot /mnt/sysroot
```

然后下载这个shell。
```bash
# 下载shell
curl -o backup.sh https://raw.githubusercontent.com/malen/rescue/main/backup.sh
# 给执行权限
chmod +x backup.sh

# 将AccessToken 导出
export accessToken=<Your AccessToken>

# 目录备份，并上传到Box
./backup.sh /wwwroot
```
