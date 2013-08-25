//
//  AppDelegate.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "AFNetworkActivityIndicatorManager.h"
#import "AppDelegate.h"
#import "VIHAAreasViewController.h"
#import "VIHADetailPlaceholderViewController.h"
#import "VIHAReportViewController.h"
#import "VIHAStyleController.h"

@interface AppDelegate ()

@property (strong, nonatomic, readonly) VIHAAreasViewController *areasViewController;
@property (strong, nonatomic, readonly) VIHADetailPlaceholderViewController *detailPlaceholderViewController;
@property (strong, nonatomic, readonly) UINavigationController *detailViewController;
@property (strong, nonatomic, readonly) VIHAReportViewController *reportViewController;
@property (strong, nonatomic, readonly) UINavigationController *masterViewController;
@property (strong, nonatomic, readonly) UISplitViewController *splitViewController;

@end

@implementation AppDelegate

@synthesize areasViewController = _areasViewController;
@synthesize detailPlaceholderViewController = _detailPlaceholderViewController;
@synthesize detailViewController = _detailViewController;
@synthesize reportViewController = _reportViewController;
@synthesize masterViewController = _masterViewController;
@synthesize splitViewController = _splitViewController;

#pragma mark - AppDelegate

- (VIHAAreasViewController *)areasViewController {
    if (!_areasViewController) {
        _areasViewController = [VIHAAreasViewController new];
    }
    
    return _areasViewController;
}

- (VIHADetailPlaceholderViewController *)detailPlaceholderViewController {
    if (!_detailPlaceholderViewController) {
        _detailPlaceholderViewController = [VIHADetailPlaceholderViewController new];
    }
    
    return _detailPlaceholderViewController;
}

- (UINavigationController *)detailViewController {
    if (!_detailViewController) {
        _detailViewController = [[UINavigationController alloc] initWithRootViewController:self.detailPlaceholderViewController];
    }
    
    return _detailViewController;
}

- (VIHAReportViewController *)reportViewController {
    if (!_reportViewController) {
        _reportViewController = [VIHAReportViewController new];
    }
    
    return _reportViewController;
}

- (UINavigationController *)masterViewController {
    if (!_masterViewController) {
        _masterViewController = [[UINavigationController alloc] initWithRootViewController:self.areasViewController];
    }
    
    return _masterViewController;
}

- (UISplitViewController *)splitViewController {
    if (!_splitViewController) {
        _splitViewController = [UISplitViewController new];
        
        _splitViewController.viewControllers = @[ self.masterViewController, self.detailViewController ];
        _splitViewController.delegate = self.detailPlaceholderViewController;
    }
    
    return _splitViewController;
}

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _window.rootViewController = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? self.masterViewController : self.splitViewController;
    }
    
    return _window;
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8*1024*1024 diskCapacity:20*1024*1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [VIHAStyleController applyStyles];

    [self.window makeKeyAndVisible];

    return YES;
}

@end
