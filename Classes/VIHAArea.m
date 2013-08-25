//
//  VIHAArea.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHAArea.h"
#import "YQLAPIClient.h"

@implementation VIHAArea

@synthesize category = _category;
@synthesize title = _title;

#pragma mark - VIHAArea

+ (void)areasWithBlock:(void (^)(NSArray *areas, NSError *error))block {
    NSParameterAssert(block);
    
    NSDictionary *parameters = @{ @"q": @"select * from ca.viha.areas" };
    
    [[YQLAPIClient sharedClient] getPath:nil parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableAreas = [@[] mutableCopy];
        
        for (NSDictionary *attributes in [JSON valueForKeyPath:@"query.results.result.areas"]) {
            VIHAArea *area = [[VIHAArea alloc] initWithAttributes:attributes];
            
            [mutableAreas addObject:area];
        }
        
        block([mutableAreas copy], nil);
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
    _title = [aDecoder decodeObjectForKey:@"title"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.title forKey:@"title"];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, category: %@, title: %@>", NSStringFromClass([self class]), self, self.category, self.title];
}

@end
