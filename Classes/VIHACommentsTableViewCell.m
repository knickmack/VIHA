//
//  VIHACommentsTableViewCell.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-16.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHACommentsTableViewCell.h"

@implementation VIHACommentsTableViewCell

@synthesize label = _label;

#pragma mark - VIHACommentsTableViewCell

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:kVIHACommentsLabelFontSize];
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        _label.numberOfLines = 0;
    }
    
    return _label;
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self.contentView addSubview:self.label];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = CGRectInset(self.contentView.bounds, kVIHACommentsTableViewCellPadding, kVIHACommentsTableViewCellPadding);
}

@end
