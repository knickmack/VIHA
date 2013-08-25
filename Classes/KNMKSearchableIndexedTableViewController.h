//
//  KNMKSearchableIndexedTableViewController.h
//  KNMKSearchableIndexedTableViewController
//
//  Created by Nik Macintosh on 2013-05-17.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNMKSearchableIndexedTableViewController : UITableViewController <UISearchDisplayDelegate>

@property (assign, nonatomic, readonly) SEL collationStringSelector;
@property (strong, nonatomic, readonly) NSArray *searchResults;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic, readonly) UISearchDisplayController *theSearchDisplayController;

@end
