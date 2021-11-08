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

    // 创建tag
    static let DDLogFlag_app: DDLogFlag = DDLogFlag(rawValue: 1 << 10)
    static let DDLogFlag_sdk: DDLogFlag = DDLogFlag(rawValue: 1 << 11)
    // level和tag数值保持一致
    static let DDLogLevel_app: DDLogLevel = DDLogLevel(rawValue: DDLogFlag_app.rawValue)!
    static let DDLogLevel_sdk: DDLogLevel = DDLogLevel(rawValue: DDLogFlag_sdk.rawValue)!

    /// 输出日志 - 所有level
    class func logVerbose(_ message: String) {
        DDLogVerbose(message)
    }

    /// 输出日志 - 只输出app
    class func logVerbose_app(_ message: String) {
        _DDLogMessage(message, level: DDLogLevel_app, flag: DDLogFlag_app, context: Int(DDLogFlag_app.rawValue), file: #file, function: #function, line: #line, tag: nil, asynchronous: asyncLoggingEnabled, ddlog: .sharedInstance)
    }

    /// 输出日志 - 只输出sdk
    class func logVerbose_sdk(_ message: String) {
        _DDLogMessage(message, level: DDLogLevel_sdk, flag: DDLogFlag_sdk, context: Int(DDLogFlag_sdk.rawValue), file: #file, function: #function, line: #line, tag: nil, asynchronous: asyncLoggingEnabled, ddlog: .sharedInstance)
    }

    static func createFileLogger(_ levelValue: Int) -> TFileLogger {

        let contextFilter = DDContextAllowlistFilterLogFormatter()
        contextFilter.add(toAllowlist: levelValue)

        let fileLogger = TFileLogger(level: levelValue)
        fileLogger.logFormatter = contextFilter;

        // 滚日志文件的频率。 频率以NSTimeInterval的形式给出，它是一个双精度浮点数，指定以秒为单位的间隔。 一旦日志文件变得这么旧，它就会被重新生成。例如10min = 60x10就重新生成一个日志文件, 但是假如文件名重复了, 它就会覆盖输入
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        fileLogger.maximumFileSize = 0 // 设置为0来选择性地禁用由于文件大小而导致的滚动

        return fileLogger
    }

    static func createDefaultFileLogger() -> DDFileLogger {
        return DDFileLogger(logFileManager: DDLogFileManagerDefault(logsDirectory: TFileLogger.getLogsDirPath()))
    }

    static func setupLogger() {

        if #available(iOS 10.0, *) {
            DDLog.add(DDOSLogger.sharedInstance)
        } else {
            if DDTTYLogger.sharedInstance != nil {
                DDLog.add(DDTTYLogger.sharedInstance!) // TTY = Xcode console
            }
            DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
        }

        // 添加全日志
        DDLog.add(createDefaultFileLogger())
        // 添加app日志, 输出到app对应的目录下
        DDLog.add(createFileLogger(Int(DDLogLevel_app.rawValue)))
        // 添加sdk日志, 输出到sdk对应的目录下
        DDLog.add(createFileLogger(Int(DDLogLevel_sdk.rawValue)))
    }

}
