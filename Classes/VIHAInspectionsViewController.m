//
//  VIHAInspectionsViewController.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "UINavigationController+VIHA.h"
#import "VIHAFacility.h"
#import "VIHAInspection.h"
#import "VIHAInspectionsViewController.h"
#import "VIHAReportViewController.h"

static NSString * const kVIHAInspectionsArchiveFilename = @"com.knickmack.VIHA.inspections.plist";

@interface VIHAInspectionsViewController ()

@property (strong, nonatomic, readonly) NSDateFormatter *dateFormatter;
@property (strong, nonatomic, readonly) VIHAFacility *facility;
@property (strong, nonatomic, readonly) NSArray *inspections;

@end

@implementation VIHAInspectionsViewController

@synthesize dateFormatter = _dateFormatter;
@synthesize facility = _facility;
@synthesize inspections = _inspections;

#pragma mark - VIHAInspectionsViewController

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }

    return _dateFormatter;
}

- (NSArray *)inspections {
    if (!_inspections) {
        _inspections = @[];
    }
    
    return _inspections;
}

- (id)initWithFacility:(VIHAFacility *)facility {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _facility = facility;
    
    return self;
}

- (void)refreshInspections {
    __weak __typeof(&*self)weakSelf = self;
    
    [VIHAInspection inspectionsForFacility:self.facility block:^(NSArray *inspections, NSError *error) {
        if (!inspections) {
            NSLog(@"%@", error);
            
            [weakSelf.refreshControl endRefreshing];
            
            return;
        }
        
        if (!inspections.count) {
            [weakSelf.refreshControl endRefreshing];
            return;
        }
        
        _inspections = inspections;
        [weakSelf.tableView reloadData];
        [weakSelf.refreshControl endRefreshing];
        
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAInspectionsArchiveFilename];
        NSMutableDictionary *inspectionsByFacility = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!inspectionsByFacility) {
            inspectionsByFacility = [@{} mutableCopy];
        }
        
        inspectionsByFacility[self.facility.category] = inspections;
        [NSKeyedArchiver archiveRootObject:inspectionsByFacility toFile:[NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAInspectionsArchiveFilename]];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.inspections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    VIHAInspection *inspection = self.inspections[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:inspection.date];
    cell.textLabel.text = inspection.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    VIHAInspection *inspection = self.inspections[indexPath.row];
    VIHAReportViewController *reportViewController = [[VIHAReportViewController alloc] initWithInspection:inspection];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.splitViewController.delegate = reportViewController;

        [(UINavigationController *)self.splitViewController.viewControllers.lastObject setRootViewController:reportViewController];
        return;
    }
    
    [self.navigationController pushViewController:reportViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *inspectionsByFacility = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAInspectionsArchiveFilename]];
    _inspections = inspectionsByFacility[self.facility.category];
    [self.tableView reloadData];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshInspections) forControlEvents:UIControlEventValueChanged];
    self.title = self.facility.title;
    
    [self.refreshControl beginRefreshing];
    [self refreshInspections];
}

- (void)didReceiveMemoryWarning {
    _dateFormatter = nil;
    _facility = nil;
    _inspections = nil;

    [super didReceiveMemoryWarning];
}

@end
