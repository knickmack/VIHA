//
//  VIHAViolation.h
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-16.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIHAViolation : NSObject <NSCoding>

@property (assign, nonatomic, readonly, getter = isCritical) BOOL critical;
@property (strong, nonatomic, readonly) NSNumber *code;
@property (copy, nonatomic, readonly) NSString *description;
@property (copy, nonatomic, readonly) NSString *details;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
