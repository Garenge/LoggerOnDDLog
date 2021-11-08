# Swift集成CocoaLumberJack日志库(根据功能拆分多个日志文件)

## 集成
基础集成自行查阅资料, 这篇文章写得很好([Swift集成CocoaLumberJack日志库](https://www.jianshu.com/p/4c2e111dd4db))

## 思路

本文借鉴前人经验[基于第三方CocoaLumberjack(DDLog)做保存不同分类的日志](https://juejin.cn/post/6844903619347611661)

通过定义不同的level, tag, 来实现给日志分类, 并输出到不同的文件内

## 代码组成
CSLogger - OC代码较老, 并且无法奏效, 我在作者基础上, 更新了CocoaLumberJack, 并修改了几个方法, 目前代码效果正常

swift版本是完全独立版本, 精准简化, 方便使用

本文项目地址: [https://github.com/Garenge/LoggerOnDDLog](https://github.com/Garenge/LoggerOnDDLog)

## 实现效果

不同类别的功能, 比如系统层面, sdk层面, 临时日志等可以分开在不同的文件夹下, 方便统计, 具体请运行代码查看模拟器文件夹内容

## *建议看swift版本, 较为清晰*
