//
//  VIHADetailPlaceholderViewController.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-23.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHADetailPlaceholderViewController.h"

@implementation VIHADetailPlaceholderViewController

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"KitchInspectr", nil);
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
}

@end
