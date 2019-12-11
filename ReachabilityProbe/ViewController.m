//
//  ViewController.m
//  ReachabilityProbe
//
//  Created by 姚晓丙 on 2019/12/7.
//  Copyright © 2019 姚晓丙. All rights reserved.
//

#import "ViewController.h"
#import "ReachabilityManager.h"
#import <netinet6/in6.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()
@property (nonatomic, strong) ReachabilityManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self startViaDomain];
    [self startViaAddress];
}

- (void)startViaDomain
{
    self.manager = [[ReachabilityManager alloc] initWithDomain:@"www.baidu.com"];
    [self.manager startMonitoring];
}

- (void)startViaAddress
{
    struct sockaddr_in6 address;
    bzero(&address, sizeof(address));
    address.sin6_len = sizeof(address);
    address.sin6_family = AF_INET6;
    inet_pton(AF_INET6, "0:0:0:0:0:FFFF:7272:7272", &(address.sin6_addr));

    self.manager = [[ReachabilityManager alloc] initWithAddress:&address];
    [self.manager startMonitoring];
}

@end
