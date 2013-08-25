//
//  VIHAFacilitiesViewController.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHAArea.h"
#import "VIHAFacility.h"
#import "VIHAFacilitiesViewController.h"
#import "VIHAInspectionsViewController.h"

static NSString * const kVIHAFacilitiesArchiveFilename = @"com.knickmack.VIHA.facilities.plist";

@interface VIHAFacilitiesViewController ()

@property (strong, nonatomic, readonly) VIHAArea *area;

@end

@implementation VIHAFacilitiesViewController

@synthesize area = _area;
@synthesize searchResults = _searchResults;

#pragma mark - VIHAFacilitiesViewController

- (id)initWithArea:(VIHAArea *)area {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _area = area;
    
    return self;
}

- (void)refreshFacilities {
    __weak __typeof(&*self)weakSelf = self;
    
    [VIHAFacility facilitiesInArea:self.area block:^(NSArray *facilites, NSError *error) {
        if (!facilites) {
            NSLog(@"%@", error);
            
            [weakSelf.refreshControl endRefreshing];
            
            return;
        }
        
        if (!facilites.count) {
            [weakSelf.refreshControl endRefreshing];
            return;
        }
        
        weakSelf.sections = facilites;
        [weakSelf.refreshControl endRefreshing];
        
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAFacilitiesArchiveFilename];
        NSMutableDictionary *facilitiesByArea = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!facilitiesByArea) {
            facilitiesByArea = [@{} mutableCopy];
        }
        
        facilitiesByArea[self.area.category] = facilites;
        [NSKeyedArchiver archiveRootObject:facilitiesByArea toFile:[NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAFacilitiesArchiveFilename]];
    }];
}

#pragma mark - KNMKSearchableIndexedTableViewController

- (SEL)collationStringSelector {
    return @selector(title);
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K beginswith[cd] %@) OR (%K contains[cd] %@)", NSStringFromSelector(self.collationStringSelector), searchString, @"address", searchString];

    _searchResults = [[self.sections valueForKeyPath:@"@unionOfArrays.self"] filteredArrayUsingPredicate:predicate];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    VIHAFacility *facility;
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        facility = self.searchResults[indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        NSArray *facilities = self.sections[indexPath.section];
        
        facility = facilities[indexPath.row];
    }
    
    cell.textLabel.text = facility.title;
    cell.detailTextLabel.text = facility.address;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    VIHAFacility *facility;
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        facility = self.searchResults[indexPath.row];
    } else {
        NSArray *facilities = self.sections[indexPath.section];

        facility = facilities[indexPath.row];
    }
    
    VIHAInspectionsViewController *inspectionsViewController = [[VIHAInspectionsViewController alloc] initWithFacility:facility];
    
    [self.navigationController pushViewController:inspectionsViewController animated:YES];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *facilitiesByArea = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAFacilitiesArchiveFilename]];
    self.sections = facilitiesByArea[self.area.category];
    self.title = self.area.title;
    
    [self.refreshControl addTarget:self action:@selector(refreshFacilities) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self refreshFacilities];
}

- (void)didReceiveMemoryWarning {
    _area = nil;

    [super didReceiveMemoryWarning];
}

@end
