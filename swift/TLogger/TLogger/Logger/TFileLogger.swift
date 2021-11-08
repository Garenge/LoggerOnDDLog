//
//  TFileLogger.swift
//  TLogger
//
//  Created by 鹏鹏 on 2021/11/8.
//

import UIKit
import CocoaLumberjack

class TFileLogger: DDFileLogger {

    init(level: Int) {

        let logsDirPath = TFileLogger.getLogsDirPath()
        print(logsDirPath)
        let logDirPath = logsDirPath + "/\(level)"

        print(logDirPath)
        let fileManager = DDLogFileManagerDefault(logsDirectory: logDirPath)

        super.init(logFileManager: fileManager, completionQueue: nil)
    }
}

extension TFileLogger {

    static func getApplicationName() -> String? {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as? String
    }

    static func getDocumentPath() -> String {
        let docuPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask, true)
        let docuPath = docuPaths[0]
        print(docuPath)
        return docuPath
    }

    static func getFolderPathByDocument(folderName: String) -> String {
        return getDocumentPath() + "/" + folderName
    }

    static func getLogsDirPath() -> String {
        return getFolderPathByDocument(folderName: "logs")
    }
}
