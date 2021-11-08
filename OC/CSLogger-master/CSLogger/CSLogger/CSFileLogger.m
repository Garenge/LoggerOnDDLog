//
//  CSFileLogger.m
//  CSLog
//
//  Created by ChaoSo on 2018/6/4.
//  Copyright © 2018年 ChaoSo. All rights reserved.
//

#import "CSFileLogger.h"

@interface CSFileLogger()

@end
@implementation CSFileLogger
- (NSString *)loggerName
{
    return [NSString stringWithFormat:@"cs.ddlog.fileLogger"];
}

- (instancetype)initWithFlag:(NSUInteger)flag{    
    //新建一个文件夹去保存
    _flag = flag;
    NSString *logsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%ld",(long)flag]];
//    CSFileManagerDefault *defaultLogFileManager = [[CSFileManagerDefault alloc] initWithLogsDirectory:logsDirectory fileName:@"cslogger"];

    /** fileName
     *  一定要跟DDFileLogger.m中的applicationName一致
     *  不然DDFileLogger.m中的- (BOOL)isLogFile:(NSString *)fileName, 判断log文件不存在, 会覆盖日志
     *  applicationName后面的空格也要保持一致
     */
    CSFileManagerDefault *defaultLogFileManager = [[CSFileManagerDefault alloc] initWithLogsDirectory:logsDirectory fileName:[NSString stringWithFormat:@"%@", [self applicationName]]];
    return [self initWithLogFileManager:defaultLogFileManager];
}

- (NSString *)applicationName {
    static NSString *_appName;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];

        if (_appName.length == 0) {
            _appName = [[NSProcessInfo processInfo] processName];
        }

        if (_appName.length == 0) {
            _appName = @"";
        }
    });

    return _appName;
}

@end


@interface CSFileManagerDefault()
@property (nonatomic, strong) NSString *fileName;
@end
@implementation CSFileManagerDefault


- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory
                             fileName:(NSString *)name {
    //logsDirectory日志自定义路径
    self = [super initWithLogsDirectory:logsDirectory];
    if (self) {
        self.fileName = name;
    }
    return self;
}

#pragma mark - Override methods

- (NSString *)newLogFileName {
    //重写文件名称
    NSDateFormatter *dateFormatter = [self logFileDateFormatter];
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@ %@.log", self.fileName, formattedDate];
}

- (NSDateFormatter *)logFileDateFormatter {
    
    //获取当前线程的字典
    NSMutableDictionary *dictionary = [[NSThread currentThread]
                                       threadDictionary];
    //设置日期格式
    NSString *dateFormat = @"yyyy'-'MM'-'dd'";// @"yyyy'-'MM'-'dd' 'HH'-'mm'-'ss'";
    NSString *key = [NSString stringWithFormat:@"logFileDateFormatter.%@", dateFormat];
    NSDateFormatter *dateFormatter = dictionary[key];
    
    if (dateFormatter == nil) {
        //设置日期格式
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
        [dateFormatter setDateFormat:dateFormat];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        dictionary[key] = dateFormatter;
    }
    
    return dateFormatter;
}

@end
