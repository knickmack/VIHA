//
//  VIHAFacility.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHAArea.h"
#import "VIHAFacility.h"
#import "YQLAPIClient.h"

@implementation VIHAFacility

@synthesize address = _address;
@synthesize category = _category;
@synthesize title = _title;

#pragma mark - VIHAFacility

+ (void)facilitiesInArea:(VIHAArea *)area block:(void (^)(NSArray *facilities, NSError *error))block {
    NSParameterAssert(area);
    NSParameterAssert(block);
    
    NSDictionary *parameters = @{ @"q": [NSString stringWithFormat:@"select * from ca.viha.facilities where category=\"%@\"", area.category] };
    
    [[YQLAPIClient sharedClient] getPath:nil parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableFacilities = [@[] mutableCopy];
        
        for (NSDictionary *attributes in [JSON valueForKeyPath:@"query.results.result.facilities"]) {
            VIHAFacility *facility = [[VIHAFacility alloc] initWithAttributes:attributes];
            
            [mutableFacilities addObject:facility];
        }
        
        block([mutableFacilities copy], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _address = [attributes valueForKeyPath:@"address"];
    _category = [attributes valueForKeyPath:@"category"];
    _title = [attributes valueForKeyPath:@"title"];
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _address = [aDecoder decodeObjectForKey:@"address"];
    _category = [aDecoder decodeObjectForKey:@"category"];
    _title = [aDecoder decodeObjectForKey:@"title"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.title forKey:@"title"];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, address: %@, category: %@, title: %@>", NSStringFromClass([self class]), self, self.address, self.category, self.title];
}

@end
