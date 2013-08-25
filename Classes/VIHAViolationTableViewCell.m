//
//  VIHAViolationTableViewCell.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-23.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHAViolationTableViewCell.h"

@implementation VIHAViolationTableViewCell

@synthesize descriptionLabel = _descriptionLabel;
@synthesize detailsLabel = _detailsLabel;

#pragma mark - VIHAViolationTableViewCell

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.font = [UIFont boldSystemFontOfSize:kVIHAViolationDescriptionLabelFontSize];
        _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descriptionLabel.numberOfLines = 0;
    }
    
    return _descriptionLabel;
}

- (UILabel *)detailsLabel {
    if (!_detailsLabel) {
        _detailsLabel = [UILabel new];
        
        _detailsLabel.backgroundColor = [UIColor clearColor];
        _detailsLabel.font = [UIFont systemFontOfSize:kVIHAViolationDetailsLabelFontSize];
        _detailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailsLabel.numberOfLines = 0;
    }
    
    return _detailsLabel;
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.detailsLabel];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize maximumLabelSize = CGSizeMake(self.contentView.bounds.size.width - (2 * kVIHAViolationTableViewCellPadding), FLT_MAX);
    CGSize descriptionLabelSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:maximumLabelSize lineBreakMode:self.descriptionLabel.lineBreakMode];
    CGSize detailsLabelSize = [self.detailsLabel.text sizeWithFont:self.detailsLabel.font constrainedToSize:maximumLabelSize lineBreakMode:self.detailsLabel.lineBreakMode];
    
    self.descriptionLabel.frame = CGRectMake(kVIHAViolationTableViewCellPadding, kVIHAViolationTableViewCellPadding, maximumLabelSize.width, descriptionLabelSize.height);
    self.detailsLabel.frame = CGRectMake(kVIHAViolationTableViewCellPadding, self.descriptionLabel.bounds.size.height + (2 * kVIHAViolationTableViewCellPadding), maximumLabelSize.width, detailsLabelSize.height);
}

@end
