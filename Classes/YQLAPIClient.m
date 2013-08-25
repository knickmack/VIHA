//
//  YQLAPIClient.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "AFJSONRequestOperation.h"
#import "YQLAPIClient.h"

static NSString * const kYQLAPIBaseURLString = @"http://query.yahooapis.com/v1/public/yql";

@implementation YQLAPIClient

#pragma mark - YQLAPIClient

+ (YQLAPIClient *)sharedClient {
    static YQLAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[YQLAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kYQLAPIBaseURLString]];
    });
    
    return _sharedClient;
}

#pragma mark - AFHTTPClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    
    mutableParameters[@"compat"] = @"html5";
    mutableParameters[@"env"] = @"store://mXqQmzAqv7t9RoGx9NJXso";
    mutableParameters[@"format"] = @"json";
    mutableParameters[@"jsonCompat"] = @"new";
    
    return [super requestWithMethod:method path:path parameters:[mutableParameters copy]];
}

@end
