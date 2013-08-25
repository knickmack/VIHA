//
//  YQLAPIClient.h
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "AFHTTPClient.h"

@interface YQLAPIClient : AFHTTPClient

+ (YQLAPIClient *)sharedClient;

@end
