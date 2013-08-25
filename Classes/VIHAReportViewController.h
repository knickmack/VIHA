//
//  VIHAReportViewController.h
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VIHAInspection;

@interface VIHAReportViewController : UITableViewController <UISplitViewControllerDelegate>

- (id)initWithInspection:(VIHAInspection *)inspection;

@end
