//
//  SHDDLogConfigurator.m
//  zhibo
//
//  Created by Chao So on 2017/8/2.
//  Copyright © 2017年 Qianjun Network Technology. All rights reserved.
//

#import "CSLoggerAssembler.h"

#import "CSFileLogger.h"
#import "CSContextWhitelistFilterLogFormatter.h"
@implementation CSLoggerAssembler
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ddLogStore = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

//TODO:直接给协议
+ (id<DDLogger>)createCSFileLogger:(NSInteger)flag
{
    //添加DDLog 允许自定义的log类型白名单
    CSContextWhitelistFilterLogFormatter *contextFilter = [[CSContextWhitelistFilterLogFormatter alloc] init];
    [contextFilter addToWhitelist:flag];
    CSFileLogger *customLogger = [[CSFileLogger alloc] initWithFlag:flag];
    [customLogger setLogFormatter:contextFilter];
    // 滚日志文件的频率。 频率以NSTimeInterval的形式给出，它是一个双精度浮点数，指定以秒为单位的间隔。 一旦日志文件变得这么旧，它就会被重新生成。例如10min = 60x10就重新生成一个日志文件, 但是假如文件名重复了, 它就会覆盖输入
    customLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    customLogger.logFileManager.maximumNumberOfLogFiles = 10; // 最多同时存在的文件数
    customLogger.maximumFileSize = 1024 * 4; // 单个日志文件支持的最大容量, 1024为1K
    return customLogger;
}

+ (id)createDDFileLogDefault
{
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling

    fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
    fileLogger.maximumFileSize = 1024 * 4;
    return fileLogger;
}



@end
