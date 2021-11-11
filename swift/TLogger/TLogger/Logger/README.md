# Logger

## 初始化
项目初始化时调用 `Logger.setupLogger()`

## 自定义新的flag (level)
参照`Logger`尾部, 当需要快捷自定义flag(level)时, 只需要在`extension DDLogFlag`和`extension DDLogLevel`处新加一个枚举即可

*如果该flag日志需要专门写到对应的文件(夹)内*, 需要在`Logger.setupLogger()`里面补充, 创建一个新的`TFileLogger`, 如:

```
// 添加全日志
DDLog.add(createDefaultFileLogger())
// 添加app日志, 输出到app对应的目录下
DDLog.add(createFileLogger(Int(DDLogLevel.app.rawValue)))
```

## TFileLogger(文件路径)

该类继承`DDFileLogger`, 用来将日志写入文件, 提供了几个获取文件(夹)路径的方法, 如果需要更多文件路径相关, 可以在此类实现

## 指定日志输出格式

默认写到log文件中的日志是没什么格式的, 如果需要特定的日志格式, 在`TContextAllowlistFilterLogFormatter.swift`中自定义.

1. 如果你的FileLogger是由`TContextAllowlistFilterLogFormatter`创建的, 如`Logger.createFileLogger(Int(DDLogLevel.app.rawValue))`, 那么它的自定义输出格式的方法就由`class TContextAllowlistFilterLogFormatter: DDContextAllowlistFilterLogFormatter`来实现(特指自定义Flag, 写入特定Flag文件夹)

2. 如果你的`FileLogger.logFormatter = TLogFileFormatterDefault()`如`Logger.createDefaultFileLogger`, 那么由`class TLogFileFormatterDefault: DDLogFileFormatterDefault`来实现自定义方法(此处指输出所有日志)