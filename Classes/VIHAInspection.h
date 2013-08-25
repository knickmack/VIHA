//
//  VIHAInspection.h
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VIHAFacility;

@interface VIHAInspection : NSObject <NSCoding>

@property (copy, nonatomic, readonly) NSString *category;
@property (strong, nonatomic, readonly) NSDate *date;
@property (copy, nonatomic, readonly) NSString *title;

+ (void)inspectionsForFacility:(VIHAFacility *)facility block:(void (^)(NSArray *inspections, NSError *error))block;
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
