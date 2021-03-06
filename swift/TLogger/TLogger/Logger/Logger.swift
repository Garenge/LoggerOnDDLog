//
//  Logger.swift
//  TLogger
//
//  Created by 鹏鹏 on 2021/11/8.
//

import UIKit
import CocoaLumberjack

class Logger: NSObject {

    static let shared = Logger()

    /// 输出日志 - 所有level
    class func logVerbose(_ message: String) {
        DDLogVerbose(message)
    }

    /// 输出日志 - 只输出app
    class func log_app(_ message: String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
        _DDLogMessage(message, level: .app, flag: .app, context: Int(DDLogFlag.app.rawValue), file: file, function: function, line: line, tag: nil, asynchronous: asyncLoggingEnabled, ddlog: .sharedInstance)
    }

    /// 输出日志 - 只输出sdk
    class func log_sdk(_ message: String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
        _DDLogMessage(message, level: .sdk, flag: .sdk, context: Int(DDLogFlag.sdk.rawValue), file: file, function: function, line: line, tag: nil, asynchronous: asyncLoggingEnabled, ddlog: .sharedInstance)
    }

    static func createFileLogger(_ flag: Int) -> TFileLogger {

        let contextFilter = TContextAllowlistFilterLogFormatter()
        contextFilter.add(toAllowlist: flag)

        let fileLogger = TFileLogger(flag: flag)
        fileLogger.logFormatter = contextFilter;

        // 滚日志文件的频率。 频率以NSTimeInterval的形式给出，它是一个双精度浮点数，指定以秒为单位的间隔。 一旦日志文件变得这么旧，它就会被重新生成。例如10min = 60x10就重新生成一个日志文件, 但是假如文件名重复了, 它就会覆盖输入
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        fileLogger.maximumFileSize = 0 // 设置为0来选择性地禁用由于文件大小而导致的滚动

        return fileLogger
    }

    static func createDefaultFileLogger() -> DDFileLogger {
        let fileLogger = DDFileLogger(logFileManager: DDLogFileManagerDefault(logsDirectory: TFileLogger.getLogsDirPath()))
        fileLogger.logFormatter = TLogFileFormatterDefault()

        // 滚日志文件的频率。 频率以NSTimeInterval的形式给出，它是一个双精度浮点数，指定以秒为单位的间隔。 一旦日志文件变得这么旧，它就会被重新生成。例如10min = 60x10就重新生成一个日志文件, 但是假如文件名重复了, 它就会覆盖输入
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        fileLogger.maximumFileSize = 0 // 设置为0来选择性地禁用由于文件大小而导致的滚动
        return fileLogger
    }

    static func setupLogger() {

        if #available(iOS 10.0, *) {
            let osLogger = DDOSLogger.sharedInstance
            osLogger.logFormatter = TLogFileFormatterDefault()
            DDLog.add(osLogger)
        } else {
            if let ttyLogger = DDTTYLogger.sharedInstance {
                ttyLogger.logFormatter = TLogFileFormatterDefault()
                DDLog.add(ttyLogger) // TTY = Xcode console
            }
            DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
        }

        // 添加全日志
        DDLog.add(createDefaultFileLogger())
        // 添加app日志, 输出到app对应的目录下
        DDLog.add(createFileLogger(Int(DDLogLevel.app.rawValue)))
        // 添加sdk日志, 输出到sdk对应的目录下
        DDLog.add(createFileLogger(Int(DDLogLevel.sdk.rawValue)))
        // 添加xmpp日志, 输出到xmpp对应的目录下
        DDLog.add(createFileLogger(Int(DDLogLevel.xmpp.rawValue)))
    }
}

extension Logger {

    /// 根据flag获取日志文件夹路径
    static func getLogDirPath(with flag: DDLogFlag) -> String {
        return TFileLogger.getLogDirPath(with: Int(flag.rawValue))
    }

    /// 根据flag获取日志文件夹所有日志名称
    static func getSortedLogFileNames(with flag: DDLogFlag) -> [String] {
        return TFileLogger.getSortedLogFileNames(with: Int(flag.rawValue))
    }

    /// 根据flag获取日志文件夹所有日志的路径
    static func getSortedLogFilePaths(with flag: DDLogFlag) -> [String] {
        return TFileLogger.getSortedLogFilePaths(with: Int(flag.rawValue))
    }
}

/// 扩充新的flag
extension DDLogFlag {

    /// 自定义tag
    static let app = DDLogFlag(rawValue: 1 << 10)
    /// 自定义tag
    static let sdk = DDLogFlag(rawValue: 1 << 11)
    /// 自定义tag
    static let xmpp = DDLogFlag(rawValue: 1 << 12)

    // static let ...
}

/// 扩充新的level
extension DDLogLevel {

    /// 自定义level level和tag数值保持一致
    static let app = DDLogLevel(rawValue: DDLogFlag.app.rawValue)!
    /// 自定义level level和tag数值保持一致
    static let sdk = DDLogLevel(rawValue: DDLogFlag.sdk.rawValue)!
    /// 自定义level level和tag数值保持一致
    static let xmpp = DDLogLevel(rawValue: DDLogFlag.xmpp.rawValue)!

    // static let ...
}
