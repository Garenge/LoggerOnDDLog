//
//  TLogFileFormatterDefault.swift
//  TLogger
//
//  Created by 鹏鹏 on 2021/11/11.
//

import UIKit
import CocoaLumberjack

class TContextAllowlistFilterLogFormatter: DDContextAllowlistFilterLogFormatter {

    /// 自定义时间格式
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        dateFormatter.formatterBehavior = .behavior10_4 // 10.4+ style
        return dateFormatter
    }()

    /// 重写该方法, 拼接合适的日志格式
    override func format(message logMessage: DDLogMessage) -> String? {

        // 这边注意一定要筛选掉不是该白名单的flag, 不然会把所有数据都写到一个文件去
        guard self.is(onAllowlist: logMessage.context) else {
            return nil
        }

        // 时间 文件名[line: %d] method - \nmessage
        let date = self.dateFormatter.string(from: Date())
        let fileName = (logMessage.file as NSString).lastPathComponent
        return date + " \(fileName)[line: \(logMessage.line)]"
                    + " method - \(logMessage.function ?? "")\n"
                    + logMessage.message
    }

}

class TLogFileFormatterDefault: DDLogFileFormatterDefault {

    /// 自定义时间格式
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        dateFormatter.formatterBehavior = .behavior10_4 // 10.4+ style
        return dateFormatter
    }()

    /// 重写该方法, 拼接合适的日志格式
    override func format(message logMessage: DDLogMessage) -> String? {

        // 时间 文件名[line: %d] method - \nmessage
        let date = self.dateFormatter.string(from: Date())
        let fileName = (logMessage.file as NSString).lastPathComponent
        return date + " \(fileName)[line: \(logMessage.line)]"
        + " method - \(logMessage.function ?? "")\n"
        + logMessage.message
    }
}
