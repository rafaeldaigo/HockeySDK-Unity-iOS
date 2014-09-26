//
//  HockeyAppUnityLogger.m
//  HockeyAppUnity
//
//  Created by Rafael Daigo Hirama on 9/26/14.
//  Copyright (c) 2014 Codenauts UG. All rights reserved.
//

#import "HockeyAppUnityLogger.h"
#import "DDFileLogger.h"

@interface HockeyAppUnityLogger () <BITHockeyManagerDelegate> {}
@property (nonatomic) DDFileLogger *fileLogger;
@end

@implementation HockeyAppUnityLogger

#pragma mark - Public Class Methods

+ (HockeyAppUnityLogger *)sharedHockeyLogger {
    static HockeyAppUnityLogger *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [HockeyAppUnityLogger alloc];
        sharedInstance = [sharedInstance init];
    });
    
    return sharedInstance;
}

- (id) init {

    // initialize before HockeySDK, so the delegate can access the file logger!
    _fileLogger = [[DDFileLogger alloc] init];
    _fileLogger.maximumFileSize = (1024 * 64); // 64 KByte
    _fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
    [_fileLogger rollLogFileWithCompletionBlock:nil];
    [DDLog addLogger:_fileLogger];
    
    return self;
}

// get the log content with a maximum byte size
- (NSString *) getLogFilesContentWithMaxSize:(NSInteger)maxSize {
    NSMutableString *description = [NSMutableString string];
    
    NSArray *sortedLogFileInfos = [[_fileLogger logFileManager] sortedLogFileInfos];
    NSInteger count = [sortedLogFileInfos count];
    
    // we start from the last one
    for (NSInteger index = count - 1; index >= 0; index--) {
        DDLogFileInfo *logFileInfo = [sortedLogFileInfos objectAtIndex:index];
        
        NSData *logData = [[NSFileManager defaultManager] contentsAtPath:[logFileInfo filePath]];
        if ([logData length] > 0) {
            NSString *result = [[NSString alloc] initWithBytes:[logData bytes]
                                                        length:[logData length]
                                                      encoding: NSUTF8StringEncoding];
            
            [description appendString:result];
        }
    }
    
    if ([description length] > maxSize) {
        description = (NSMutableString *)[description substringWithRange:NSMakeRange([description length]-maxSize-1, maxSize)];
    }
    
    return description;
}

#pragma mark - BITCrashManagerDelegate

- (NSString *)applicationLogForCrashManager:(BITCrashManager *)crashManager {
    NSString *description = [self getLogFilesContentWithMaxSize:5000]; // 5000 bytes should be enough!
    if ([description length] == 0) {
        return nil;
    } else {
        return description;
    }
}

@end