//
//  VIHAViolation.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-16.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "VIHAViolation.h"

@implementation VIHAViolation

#pragma mark - VIHAViolation

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _critical = [[attributes valueForKeyPath:@"critical"] boolValue];
    _code = [attributes valueForKeyPath:@"code"];
    _description = [attributes valueForKeyPath:@"description"];
    _details = [attributes valueForKeyPath:@"details"];
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _critical = [aDecoder decodeBoolForKey:@"critical"];
    _code = [aDecoder decodeObjectForKey:@"code"];
    _description = [aDecoder decodeObjectForKey:@"description"];
    _details = [aDecoder decodeObjectForKey:@"details"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.isCritical forKey:@"critical"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.details forKey:@"details"];
}

@end
