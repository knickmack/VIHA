//
//  VIHAFacility.h
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VIHAArea;

@interface VIHAFacility : NSObject <NSCoding>

@property (copy, nonatomic, readonly) NSString *address;
@property (copy, nonatomic, readonly) NSString *category;
@property (copy, nonatomic, readonly) NSString *title;

+ (void)facilitiesInArea:(VIHAArea *)area block:(void (^)(NSArray *facilites, NSError *error))block;
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
