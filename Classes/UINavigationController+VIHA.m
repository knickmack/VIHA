//
//  UINavigationController+VIHA.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-23.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "UINavigationController+VIHA.h"

@implementation UINavigationController (VIHA)

- (void)setRootViewController:(UIViewController *)rootViewController {
    NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
    
    viewControllers[0] = rootViewController;
    self.viewControllers = [viewControllers copy];
}

@end
