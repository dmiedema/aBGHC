//
//  DMGithubAPIClient.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/18/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMGithubAPIClient.h"
#import <AFNetworking/AFNetworking.h>

@implementation DMGithubAPIClient

+ (DMGithubAPIClient *)sharedInstance {
    static DMGithubAPIClient *sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DMGithubAPIClient alloc] initWithBaseURL:[NSURL URLWithString:aBGHC_GitHubApiUrl]];
    });
    
    return sharedInstance;
}

@end
