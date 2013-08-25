//
//  VIHAViolationTableViewCell.h
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-23.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kVIHAViolationDescriptionLabelFontSize = 17.f;
static CGFloat const kVIHAViolationDetailsLabelFontSize = 17.f;
static CGFloat const kVIHAViolationTableViewCellPadding = 10.f;

@interface VIHAViolationTableViewCell : UITableViewCell

@property (strong, nonatomic, readonly) UILabel *descriptionLabel;
@property (strong, nonatomic, readonly) UILabel *detailsLabel;

@end
