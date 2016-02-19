# 自动打包并发布应用

xcodebuild及fir.im的使用参考

<https://github.com/GreedBell/blog/blob/master/iOS/%E8%87%AA%E5%8A%A8%E6%89%93%E5%8C%85%E5%B9%B6%E5%8F%91%E5%B8%83%E5%BA%94%E7%94%A8.md>

## 说明

### iOSPublish.default.config

默认配置

### fir.im

`FIR_TOKEN`申请 <fir.im> 账号后会得到.

### iOSPublish.sh

打包并发布到 <fir.im> , 如果`WILL_BAIDU_SYMBOL`大于0则生成百度统计文件。

```
# iOSPublish.sh [config file path]
```

## 发布到AppStore

`iPA`包打好后用`Application Loader`发布。

`Xcode`>`Open Developer Tool`>`Application Loader`

## 上传symbol到百度统计

`iOSPublish.sh`执行完成后会打印百度统计文件路径,上传到 <http://mtj.baidu.com/> > 设置 > 文件管理

### Q1. 验证错误:文件内容错误，请重新生成后上传

A. 升级SDK，添加crush部分
