//
//  Notifee+NSNotificationCenter.m
//  NotifeeCore
//
//  Copyright © 2020 Invertase. All rights reserved.
//

#include <TargetConditionals.h>
#if TARGET_OS_IPHONE
    @import UIKit;
#else
    @import AppKit;
#endif

#import "Private/NotifeeCore+NSNotificationCenter.h"
#import "Private/NotifeeCore+UNUserNotificationCenter.h"

@implementation NotifeeCoreNSNotificationCenter

+ (instancetype)instance {
  static dispatch_once_t once;
  __strong static NotifeeCoreNSNotificationCenter *sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[NotifeeCoreNSNotificationCenter alloc] init];
  });
  return sharedInstance;
}

- (void)observe {
  static dispatch_once_t once;
  __weak NotifeeCoreNSNotificationCenter *weakSelf = self;
  dispatch_once(&once, ^{
    NotifeeCoreNSNotificationCenter *strongSelf = weakSelf;
    // Application
    // ObjC -> Initialize other delegates & observers
#if TARGET_OS_IPHONE
#if !TARGET_OS_WATCH
    [[NSNotificationCenter defaultCenter]
        addObserver:strongSelf
           selector:@selector(application_onDidFinishLaunchingNotification:)
               name:UIApplicationDidFinishLaunchingNotification
             object:nil];
#endif
    [[NSNotificationCenter defaultCenter]
        addObserver:strongSelf
           selector:@selector(messaging_didReceiveRemoteNotification:)
               name:@"RNFBMessagingDidReceiveRemoteNotification"
             object:nil];
  });
#endif
#if !TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter]
        addObserver:strongSelf
           selector:@selector(application_onDidFinishLaunchingNotification:)
               name:NSApplicationDidFinishLaunchingNotification
             object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:strongSelf
           selector:@selector(messaging_didReceiveRemoteNotification:)
               name:@"RNFBMessagingDidReceiveRemoteNotification"
             object:nil];
  });
#endif
}

// start observing immediately on class load - specifically for
// UIApplicationDidFinishLaunchingNotification
+ (void)load {
  [[self instance] observe];
}

#pragma mark -
#pragma mark Application Notifications

- (void)application_onDidFinishLaunchingNotification:(nonnull NSNotification *)notification {
  // setup our delegates after app finishes launching
  // these methods are idempotent so can safely be called multiple times
  [[NotifeeCoreUNUserNotificationCenter instance] observe];
}

- (void)messaging_didReceiveRemoteNotification:(nonnull NSNotification *)notification {
  // update me with logic
}

@end
