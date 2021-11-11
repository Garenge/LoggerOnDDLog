//
//  TFileLogger.swift
//  TLogger
//
//  Created by 鹏鹏 on 2021/11/8.
//

import UIKit
import CocoaLumberjack

class TFileLogger: DDFileLogger {

    init(flag: Int) {

        let logDirPath = TFileLogger.getLogDirPath(with: flag)
        let fileManager = DDLogFileManagerDefault(logsDirectory: logDirPath)

        super.init(logFileManager: fileManager, completionQueue: nil)
    }
}

extension TFileLogger {

    /// 获取bundleId
    static func getApplicationName() -> String? {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as? String
    }

    /// 获取document路径
    static func getDocumentPath() -> String {
        let docuPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask, true)
        let docuPath = docuPaths[0]
        return docuPath
    }

    /// 拼接document文件夹下路径
    static func getFolderPathByDocument(folderName: String) -> String {
        return getDocumentPath() + "/" + folderName
    }

    /// 获取所有日志文件夹
    static func getLogsDirPath() -> String {
        return getFolderPathByDocument(folderName: "logs")
    }

    /// 根据flag获取日志文件夹路径
    static func getLogDirPath(with flag: Int) -> String {
        let logsDirPath = TFileLogger.getLogsDirPath()
        return logsDirPath + "/\(flag)"
    }

    /// 根据flag获取日志文件夹所有日志名称
    static func getSortedLogFileNames(with flag: Int) -> [String] {
        let logDirPath = TFileLogger.getLogDirPath(with: flag)
        let fileManager = DDLogFileManagerDefault(logsDirectory: logDirPath)
        return fileManager.sortedLogFileNames
    }

    /// 根据flag获取日志文件夹所有日志的路径
    static func getSortedLogFilePaths(with flag: Int) -> [String] {
        let logDirPath = TFileLogger.getLogDirPath(with: flag)
        let fileManager = DDLogFileManagerDefault(logsDirectory: logDirPath)
        return fileManager.sortedLogFilePaths
    }
}

