//
//  ReachabilityManager.h
//  ReachabilityProbe
//
//  Created by 姚晓丙 on 2019/12/7.
//  Copyright © 2019 姚晓丙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReachabilityManager : NSObject
- (instancetype)initWithDomain:(NSString *)domain;
- (instancetype)initWithAddress:(const void *)address;
- (void)startMonitoring;
- (void)stopMonitoring;
@end

NS_ASSUME_NONNULL_END
