//
//  VIHAAreasViewController.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHAArea.h"
#import "VIHAAreasViewController.h"
#import "VIHAFacilitiesViewController.h"

static NSString * const kVIHAAreasArchiveFilename = @"com.knickmack.VIHA.areas.plist";

@implementation VIHAAreasViewController

#pragma mark - VIHAAreasViewController

- (void)refreshAreas {
    __weak __typeof(&*self)weakSelf = self;
    
    [VIHAArea areasWithBlock:^(NSArray *areas, NSError *error) {
        if (!areas) {
            NSLog(@"%@", error);
            
            [weakSelf.refreshControl endRefreshing];
            
            return;
        }
        
        if (!areas.count) {
            [weakSelf.refreshControl endRefreshing];
            return;
        }
        
        weakSelf.sections = areas;
        [weakSelf.refreshControl endRefreshing];
        
        [NSKeyedArchiver archiveRootObject:areas toFile:[NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAAreasArchiveFilename]];
    }];
}

#pragma mark - KNMKSearchableIndexedTableViewController

- (SEL)collationStringSelector {
    return @selector(title);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    VIHAArea *area;
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        area = self.searchResults[indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        NSArray *areas = self.sections[indexPath.section];
        
        area = areas[indexPath.row];
    }
    
    cell.textLabel.text = area.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    VIHAArea *area;
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        area = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        NSArray *areas = self.sections[indexPath.section];
        
        area = areas[indexPath.row];
    }
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Areas", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    VIHAFacilitiesViewController *facilitiesViewController = [[VIHAFacilitiesViewController alloc] initWithArea:area];

    self.navigationItem.backBarButtonItem = backBarButtonItem;
    [self.navigationController pushViewController:facilitiesViewController animated:YES];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sections = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSTemporaryDirectory() stringByAppendingPathComponent:kVIHAAreasArchiveFilename]];
    self.title = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? NSLocalizedString(@"KitchInspectr", nil) : NSLocalizedString(@"Areas", nil);
    
    [self.refreshControl addTarget:self action:@selector(refreshAreas) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self refreshAreas];
}

@end
