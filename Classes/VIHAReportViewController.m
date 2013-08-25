//
//  VIHAReportViewController.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHACommentsTableViewCell.h"
#import "VIHAInspection.h"
#import "VIHAReport.h"
#import "VIHAReportViewController.h"
#import "VIHAViolationTableViewCell.h"

static NSString * const kVIHAReportsArchiveFilename = @"com.knickmack.VIHA.reports.plist";

typedef NS_ENUM(NSInteger, VIHAReportTableViewSection) {
    VIHAReportTableViewSectionGeneral,
    VIHAReportTableViewSectionViolations,
    VIHAReportTableViewSectionComments,
    VIHAReportTableViewSectionCount
};

typedef NS_ENUM(NSInteger, VIHAReportTableViewGeneralSectionRow) {
    VIHAReportTableViewGeneralSectionRowFacilityType,
    VIHAReportTableViewGeneralSectionRowInspectionType,
    VIHAReportTableViewGeneralSectionRowInspectionDate,
    VIHAReportTableViewGeneralSectionRowCriticalViolationsCount,
    VIHAReportTableViewGeneralSectionRowNonCriticalViolationsCount,
    VIHAReportTableViewGeneralSectionRowCount
};

@interface VIHAReportViewController ()

@property (strong, nonatomic, readonly) NSDateFormatter *dateFormatter;
@property (strong, nonatomic, readonly) VIHAInspection *inspection;
@property (strong, nonatomic, readonly) VIHAReport *report;

@end

@implementation VIHAReportViewController

@synthesize dateFormatter = _dateFormatter;
@synthesize inspection = _inspection;
@synthesize report = _report;

#pragma mark - VIHAReportViewController

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];

        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.locale = [NSLocale currentLocale];
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    return _dateFormatter;
}

- (id)initWithInspection:(VIHAInspection *)inspection {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) {
        return nil;
    }
    
    _inspection = inspection;
    
    return self;
}

- (void)refreshReport {
    __weak __typeof(&*self)weakSelf = self;
    
    [VIHAReport reportFromInspection:self.inspection block:^(VIHAReport *report, NSError *error) {
        if (!report) {
            NSLog(@"%@", error);
            
            [weakSelf.refreshControl endRefreshing];
            
            return;
        }
        
        _report = report;
        
        UIColor *tintColor;
        if ([self.report.rating isEqualToString:@"Low"]) {
            tintColor = [UIColor greenColor];
        } else if ([self.report.rating isEqualToString:@"Medium"]) {
            tintColor = [UIColor yellowColor];
        } else if ([self.report.rating isEqualToString:@"High"]) {
            tintColor = [UIColor redColor];
        }
        
        weakSelf.navigationController.navigationBar.tintColor = tintColor;
        [weakSelf.tableView reloadData];
        [weakSelf.refreshControl endRefreshing];
        
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAReportsArchiveFilename];
        NSMutableDictionary *reportsByInspection = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!reportsByInspection) {
            reportsByInspection = [@{} mutableCopy];
        }
        
        reportsByInspection[self.inspection.category] = report;
        [NSKeyedArchiver archiveRootObject:reportsByInspection toFile:[NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAReportsArchiveFilename]];
    }];
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return VIHAReportTableViewSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key;
    switch (section) {
        case VIHAReportTableViewSectionGeneral:
            key = @"General";
            break;
            
        case VIHAReportTableViewSectionViolations:
            key = self.report.violations.count ? @"Violations" : nil;
            break;
            
        case VIHAReportTableViewSectionComments:
            key = self.report.comments.length ? @"Comments" : nil;
            break;
    }
    
    return NSLocalizedString(key, nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case VIHAReportTableViewSectionGeneral:
            return VIHAReportTableViewGeneralSectionRowCount;
            
        case VIHAReportTableViewSectionViolations:
            return self.report.violations.count;
            
        case VIHAReportTableViewSectionComments:
            return !!self.report.comments.length;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case VIHAReportTableViewSectionGeneral: {
            NSString *CellIdentifier = @"GeneralCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }

            NSString *detailTextLabelText;
            NSString *textLabelText;
            switch (indexPath.row) {
                case VIHAReportTableViewGeneralSectionRowFacilityType:
                    detailTextLabelText = self.report.facilityType;
                    textLabelText = NSLocalizedString(@"Facility", nil);
                    break;
                case VIHAReportTableViewGeneralSectionRowInspectionType:
                    detailTextLabelText = self.report.inspectionType;
                    textLabelText = NSLocalizedString(@"Inspection", nil);
                    break;
                case VIHAReportTableViewGeneralSectionRowInspectionDate:
                    detailTextLabelText = [self.dateFormatter stringFromDate:self.report.inspectionDate];
                    textLabelText = NSLocalizedString(@"Date", nil);
                    break;
                case VIHAReportTableViewGeneralSectionRowCriticalViolationsCount:
                    detailTextLabelText = self.report.criticalViolationsCount.stringValue;
                    textLabelText = NSLocalizedString(@"Critical", nil);
                    break;
                case VIHAReportTableViewGeneralSectionRowNonCriticalViolationsCount:
                    detailTextLabelText = self.report.nonCriticalViolationsCount.stringValue;
                    textLabelText = NSLocalizedString(@"Violations", nil);
                    break;
            }
            
            cell.detailTextLabel.text = detailTextLabelText;
            cell.textLabel.text = textLabelText;
            
            return cell;
        } break;
            
        case VIHAReportTableViewSectionViolations: {
            NSString *CellIdentifier = @"ViolationCell";
            VIHAViolationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[VIHAViolationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            VIHAViolation *violation = self.report.violations[indexPath.row];
            
            cell.descriptionLabel.text = violation.description;
            cell.detailsLabel.text = violation.details;
            
            return cell;
        } break;
            
        case VIHAReportTableViewSectionComments: {
            NSString *CellIdentifier = @"CommentsCell";
            VIHACommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[VIHACommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.label.text = self.report.comments;
            
            return cell;
        } break;
        
        default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case VIHAReportTableViewSectionGeneral:
            return UITableViewAutomaticDimension;
            
        case VIHAReportTableViewSectionViolations:
            return self.report.violations.count ? UITableViewAutomaticDimension : FLT_MIN;
            
        case VIHAReportTableViewSectionComments:
            return self.report.comments.length ? UITableViewAutomaticDimension : FLT_MIN;
            
        default:
            return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case VIHAReportTableViewSectionGeneral:
            return UITableViewAutomaticDimension;
            
        case VIHAReportTableViewSectionViolations: {
            CGSize maximumLabelSize = CGSizeMake(tableView.bounds.size.width - (4 * kVIHAViolationTableViewCellPadding), FLT_MAX);
            VIHAViolation *violation = self.report.violations[indexPath.row];
            CGSize descriptionLabelSize = [violation.description sizeWithFont:[UIFont boldSystemFontOfSize:kVIHAViolationDescriptionLabelFontSize] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            CGSize detailsLabelSize = [violation.details sizeWithFont:[UIFont systemFontOfSize:kVIHAViolationDetailsLabelFontSize] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            
            return MAX(descriptionLabelSize.height + detailsLabelSize.height + ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 3 : 5) * kVIHAViolationTableViewCellPadding), 44.f);
        }
            
        case VIHAReportTableViewSectionComments: {
            CGSize maximumLabelSize = CGSizeMake(tableView.bounds.size.width - (4 * kVIHACommentsTableViewCellPadding), FLT_MAX);
            CGSize size = [self.report.comments sizeWithFont:[UIFont systemFontOfSize:kVIHACommentsLabelFontSize] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            
            return MAX(size.height + ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 2 : 4) * kVIHACommentsTableViewCellPadding), 44.f);
        }
            
        default:
            return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case VIHAReportTableViewSectionGeneral:
            return UITableViewAutomaticDimension;
            
        case VIHAReportTableViewSectionViolations:
            return self.report.violations.count ? UITableViewAutomaticDimension : FLT_MIN;
            
        case VIHAReportTableViewSectionComments:
            return self.report.comments.length ? UITableViewAutomaticDimension : FLT_MIN;
            
        default:
            return UITableViewAutomaticDimension;
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *reportsByInspection = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAReportsArchiveFilename]];
    _report = reportsByInspection[self.inspection.category];
    UIColor *tintColor;
    if ([self.report.rating isEqualToString:@"Low"]) {
        tintColor = [UIColor greenColor];
    } else if ([self.report.rating isEqualToString:@"Medium"]) {
        tintColor = [UIColor yellowColor];
    } else if ([self.report.rating isEqualToString:@"High"]) {
        tintColor = [UIColor redColor];
    }
    
    self.navigationController.navigationBar.tintColor = tintColor;
    [self.tableView reloadData];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshReport) forControlEvents:UIControlEventValueChanged];
    self.tableView.allowsSelection = NO;
    self.title = self.inspection.title;
    
    [self.refreshControl beginRefreshing];
    [self refreshReport];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = nil;

    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    _dateFormatter = nil;
    _inspection = nil;
    _report = nil;

    [super didReceiveMemoryWarning];
}

@end
