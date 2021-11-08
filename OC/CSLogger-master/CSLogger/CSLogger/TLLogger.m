//
//  TLLogger.m
//  CSLogger
//
//  Created by 鹏鹏 on 2021/11/5.
//  Copyright © 2021 ChaoSo. All rights reserved.
//

#import "TLLogger.h"
#import "CSLogger.h"
#import "CSLogMacro.h"

@implementation TLLogger

+ (void)setupLogger {
    //分开logger不同的flag
    [DDLog addLogger:[CSLoggerAssembler createCSFileLogger:CSLOG_TEST_FLAG]];
    [DDLog addLogger:[CSLoggerAssembler createCSFileLogger:CSLOG_TEST_FLAG2]];

    [DDLog addLogger:[DDOSLogger sharedInstance]];

    CSLOG_TEST_DDLOG(@"初始化结束");
}

@end
