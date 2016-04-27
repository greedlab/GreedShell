# 获取 Provisioning Profile

根据描述文件名称获取描述文件

```
Usage: args [-f] <TARGET_DIRECTORY> [-n] <TARGET_NAME> -o <OUTPUT_PATH>
-d Provisioning Profile directory. default '~/Library/MobileDevice/Provisioning\ Profiles/*'
-n Provisioning Profile name
-o output file path. default ./<TARGET_NAME>.mobileprovision
-h help
Example: getProvisioningProfile.sh -n 'iOS Team Provisioning Profile: com.apple.example'
```
