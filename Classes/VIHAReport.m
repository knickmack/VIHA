//
//  VIHAReport.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-15.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHAInspection.h"
#import "VIHAReport.h"
#import "YQLAPIClient.h"

@implementation VIHAReport

@synthesize title = _title;

#pragma mark - VIHAReport

+ (void)reportFromInspection:(VIHAInspection *)inspection block:(void (^)(VIHAReport *report, NSError *error))block {
    NSParameterAssert(inspection);
    NSParameterAssert(block);
    
    NSDictionary *parameters = @{ @"q": [NSString stringWithFormat:@"select * from ca.viha.reports where category=\"%@\"", inspection.category] };
    
    [[YQLAPIClient sharedClient] getPath:nil parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSDictionary *attributes = [JSON valueForKeyPath:@"query.results.report"];
        VIHAReport *report = [[VIHAReport alloc] initWithAttributes:attributes];
        
        block(report, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _comments = [attributes valueForKeyPath:@"comments"];
    _criticalViolationsCount = [attributes valueForKeyPath:@"criticalViolations"];
    _facilityType = [attributes valueForKeyPath:@"facilityType"];
    _inspectionDate = [NSDate dateWithTimeIntervalSince1970:[[attributes valueForKeyPath:@"inspectionDate"] doubleValue]];
    _inspectionType = [attributes valueForKeyPath:@"inspectionType"];
    _nonCriticalViolationsCount = [attributes valueForKeyPath:@"nonCriticalViolations"];
    _rating = [attributes valueForKeyPath:@"rating"];
    _title = [attributes valueForKeyPath:@"title"];
    
    NSMutableArray *mutableViolations = [@[] mutableCopy];
    
    for (NSDictionary *violationAttributes in [attributes valueForKeyPath:@"violations"]) {
        VIHAViolation *violation = [[VIHAViolation alloc] initWithAttributes:violationAttributes];
        
        [mutableViolations addObject:violation];
    }
    
    _violations = [mutableViolations copy];
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _comments = [aDecoder decodeObjectForKey:@"comments"];
    _criticalViolationsCount = [aDecoder decodeObjectForKey:@"criticalViolationsCount"];
    _facilityType = [aDecoder decodeObjectForKey:@"facilityType"];
    _inspectionDate = [aDecoder decodeObjectForKey:@"inspectionDate"];
    _inspectionType = [aDecoder decodeObjectForKey:@"inspectionType"];
    _nonCriticalViolationsCount = [aDecoder decodeObjectForKey:@"nonCriticalViolationsCount"];
    _rating = [aDecoder decodeObjectForKey:@"rating"];
    _title = [aDecoder decodeObjectForKey:@"title"];
    _violations = [aDecoder decodeObjectForKey:@"violations"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.comments forKey:@"comments"];
    [aCoder encodeObject:self.criticalViolationsCount forKey:@"criticalViolationsCount"];
    [aCoder encodeObject:self.facilityType forKey:@"facilityType"];
    [aCoder encodeObject:self.inspectionDate forKey:@"inspectionDate"];
    [aCoder encodeObject:self.inspectionType forKey:@"inspectionType"];
    [aCoder encodeObject:self.nonCriticalViolationsCount forKey:@"nonCriticalViolationsCount"];
    [aCoder encodeObject:self.rating forKey:@"rating"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.violations forKey:@"violations"];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, title: %@>", NSStringFromClass([self class]), self, self.title];
}

@end
