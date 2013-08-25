//
//  KNMKSearchableIndexedTableViewController.m
//  KNMKSearchableIndexedTableViewController
//
//  Created by Nik Macintosh on 2013-05-17.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "KNMKSearchableIndexedTableViewController.h"

@implementation KNMKSearchableIndexedTableViewController

@synthesize searchResults = _searchResults;
@synthesize sections = _sections;
@synthesize theSearchDisplayController = _theSearchDisplayController;

#pragma mark - KNMKSearchableIndexedTableViewController

- (NSArray *)searchResults {
    if (!_searchResults) {
        _searchResults = @[];
    }
    
    return _searchResults;
}

- (NSArray *)sections {
    if (!_sections) {
        _sections = @[];
    }
    
    return _sections;
}

- (void)setSections:(NSArray *)objects {
    NSInteger idx, sectionTitlesCount = [[UILocalizedIndexedCollation currentCollation] sectionTitles].count;
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (idx = 0; idx < sectionTitlesCount; idx++) {
        [mutableSections addObject:[@[] mutableCopy]];
    }
    
    for (id object in objects) {
        NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:object collationStringSelector:self.collationStringSelector];
        
        [mutableSections[sectionNumber] addObject:object];
    }
    
    for (idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        
        mutableSections[idx] = [[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:self.collationStringSelector];
    }
    
    _sections = [mutableSections copy];
    [self.tableView reloadData];
}

- (UISearchDisplayController *)theSearchDisplayController {
    if (!_theSearchDisplayController) {
        UISearchBar *searchBar = [UISearchBar new];
        
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [searchBar sizeToFit];
        
        _theSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        
        _theSearchDisplayController.delegate = self;
        _theSearchDisplayController.searchResultsDataSource = self;
        _theSearchDisplayController.searchResultsDelegate = self;
    }
    
    return _theSearchDisplayController;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K beginswith[cd] %@", NSStringFromSelector(self.collationStringSelector), searchString];
    
    _searchResults = [[self.sections valueForKeyPath:@"@unionOfArrays.self"] filteredArrayUsingPredicate:predicate];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        return 1;
    }
    
    return self.sections.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        return nil;
    }

    NSMutableArray *sectionIndexTitles = [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] mutableCopy];
    
    [sectionIndexTitles insertObject:UITableViewIndexSearch atIndex:0];

    return sectionIndexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        return nil;
    }
    
    if ([self.sections[section] count] < 1) {
        return nil;
    }
    
    return [[UILocalizedIndexedCollation currentCollation] sectionTitles][section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        return 0;
    }

    if (index == 0) {
        [tableView setContentOffset:CGPointZero animated:NO];
        
        return NSNotFound;
    }

    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index - 1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        return self.searchResults.count;
    }
    
    NSArray *rows = self.sections[section];

    return rows.count;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [UIRefreshControl new];
    self.tableView.tableHeaderView = self.theSearchDisplayController.searchBar;
}

- (void)didReceiveMemoryWarning {
    _searchResults = nil;
    _sections = nil;
    _theSearchDisplayController = nil;
    
    [super didReceiveMemoryWarning];
}

@end
