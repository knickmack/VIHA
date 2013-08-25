//
//  VIHACommentsTableViewCell.h
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-16.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kVIHACommentsLabelFontSize = 17.f;
static CGFloat const kVIHACommentsTableViewCellPadding = 10.f;

@interface VIHACommentsTableViewCell : UITableViewCell

@property (strong, nonatomic, readonly) UILabel *label;

@end
