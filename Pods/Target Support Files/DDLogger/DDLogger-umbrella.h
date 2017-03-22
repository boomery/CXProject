#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DDLogger.h"
#import "DDLoggerClient.h"
#import "DDLoggerManager.h"

FOUNDATION_EXPORT double DDLoggerVersionNumber;
FOUNDATION_EXPORT const unsigned char DDLoggerVersionString[];

