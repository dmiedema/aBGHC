//
//  DMGithubAPIClient.h
//  aBGHC
//
//  Created by Daniel Miedema on 6/18/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "AFHTTPClient.h"

@interface DMGithubAPIClient : AFHTTPClient

+ (DMGithubAPIClient *)sharedInstance;

@end
