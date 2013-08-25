//
//  VIHAArea.h
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIHAArea : NSObject <NSCoding>

@property (copy, nonatomic, readonly) NSString *category;
@property (copy, nonatomic, readonly) NSString *title;

+ (void)areasWithBlock:(void (^)(NSArray *areas, NSError *error))block;
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
