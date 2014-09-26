//
//  HockeyAppUnityLogger.h
//  HockeyAppUnity
//
//  Created by Rafael Daigo Hirama on 9/26/14.
//  Copyright (c) 2014 Codenauts UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BITHockeyManagerDelegate.h"

@interface HockeyAppUnityLogger : NSObject<BITHockeyManagerDelegate>

+ (HockeyAppUnityLogger *)sharedHockeyLogger;

@end
