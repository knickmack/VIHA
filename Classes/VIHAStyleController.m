//
//  VIHAStyleController.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHAStyleController.h"
#import "UIColor+VIHA.h"

@implementation VIHAStyleController

+ (void)applyStyles {
    [[UINavigationBar appearance] setTintColor:[UIColor navyBlueColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ UITextAttributeFont: [UIFont fontWithName:@"CourierNewPS-BoldMT" size:20.f] }];
}

@end
