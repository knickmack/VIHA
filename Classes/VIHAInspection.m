//
//  VIHAInspection.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHAFacility.h"
#import "VIHAInspection.h"
#import "YQLAPIClient.h"

@implementation VIHAInspection

@synthesize category = _category;
@synthesize date = _date;
@synthesize title = _title;

#pragma mark - VIHAInspection

+ (void)inspectionsForFacility:(VIHAFacility *)facility block:(void (^)(NSArray *inspections, NSError *error))block {
    NSParameterAssert(facility);
    NSParameterAssert(block);
    
    NSDictionary *parameters = @{ @"q": [NSString stringWithFormat:@"select * from ca.viha.inspections where category=\"%@\"", facility.category] };
    
    [[YQLAPIClient sharedClient] getPath:nil parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableInspections = [@[] mutableCopy];
        
        for (NSDictionary *attributes in [JSON valueForKeyPath:@"query.results.result.inspections"]) {
            VIHAInspection *inspection = [[VIHAInspection alloc] initWithAttributes:attributes];
            
            [mutableInspections addObject:inspection];
        }
        
        block([mutableInspections copy], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _category = [attributes valueForKeyPath:@"category"];
    _date = [NSDate dateWithTimeIntervalSince1970:[[attributes valueForKeyPath:@"date"] doubleValue]];
    _title = [attributes valueForKeyPath:@"title"];
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _category = [aDecoder decodeObjectForKey:@"category"];
    _date = [aDecoder decodeObjectForKey:@"date"];
    _title = [aDecoder decodeObjectForKey:@"title"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.title forKey:@"title"];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, category: %@, date: %@, title: %@>", NSStringFromClass([self class]), self, self.category, self.date, self.title];
}

@end
