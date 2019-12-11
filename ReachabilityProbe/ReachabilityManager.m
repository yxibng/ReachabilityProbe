//
//  ReachabilityManager.m
//  ReachabilityProbe
//
//  Created by 姚晓丙 on 2019/12/7.
//  Copyright © 2019 姚晓丙. All rights reserved.
//

#import "ReachabilityManager.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface ReachabilityManager ()
@property (nonatomic, assign) SCNetworkReachabilityRef networkReachability;

@end


@implementation ReachabilityManager

- (void)dealloc
{
    CFRelease(self.networkReachability);
}

- (instancetype)initWithDomain:(NSString *)domain
{
    if (self = [super init]) {
        self.networkReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [domain UTF8String]);
    }
    return self;
}

- (instancetype)initWithAddress:(const void *)address
{
    if (self = [super init]) {
        self.networkReachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address);
    }
    return self;
    
}


- (void)startMonitoring {
    [self stopMonitoring];
    
    SCNetworkReachabilityContext context;
    context.version = 0;
    context.info = (__bridge void * _Nullable)(self);
    context.retain = context_retain;
    context.release = context_release;
    context.copyDescription = NULL;
    
    SCNetworkReachabilitySetCallback(self.networkReachability, reachabilityCallback, &context);
    SCNetworkReachabilityScheduleWithRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);

}

- (void)stopMonitoring {
    if (!self.networkReachability) {
        return;
    }
    SCNetworkReachabilityUnscheduleFromRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}

const void *context_retain(const void *info) {
//    Block_copy(info);
    return info;
}

void context_release(const void *info) {
//    if (info) {
//        Block_release(info);
//    }
}

void reachabilityCallback(SCNetworkReachabilityRef target,SCNetworkReachabilityFlags flags,void *__nullable info) {
    
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    if (!isNetworkReachable) {
        NSLog(@"network not reachable");
        return;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        NSLog(@"reachable via WWAN");
        return;
    }
    
    NSLog(@"reachable via WIFI");
}



@end
