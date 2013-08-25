//
//  VIHAReport.h
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-15.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VIHAViolation.h"

@class VIHAInspection;

@interface VIHAReport : NSObject <NSCoding>

@property (copy, nonatomic, readonly) NSString *comments;
@property (strong, nonatomic, readonly) NSNumber *criticalViolationsCount;
@property (copy, nonatomic, readonly) NSString *facilityType;
@property (strong, nonatomic, readonly) NSDate *inspectionDate;
@property (copy, nonatomic, readonly) NSString *inspectionType;
@property (strong, nonatomic, readonly) NSNumber *nonCriticalViolationsCount;
@property (copy, nonatomic, readonly) NSString *rating;
@property (copy, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSArray *violations;

+ (void)reportFromInspection:(VIHAInspection *)inspection block:(void (^)(VIHAReport *report, NSError *error))block;
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
