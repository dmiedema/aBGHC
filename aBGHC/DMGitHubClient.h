//
//  DMGitHubClient.h
//  aBGHC
//
//  Created by Daniel Miedema on 6/13/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^JSONResponseBlock)(NSArray *json);

@interface DMGitHubClient : AFHTTPClient

typedef enum {
    MINE,
    STARRED,
    WATCHED,
} repositoryTypesToLoad;

typedef enum {
    README,
    COMMITS,
    FILES,
} repositoryContentType;

+ (DMGitHubClient *)sharedInstance;
+ (NSArray *)homeScreenOptions;
+ (NSArray *)searchScopeOptions;

- (NSArray *)loadRepositoriesWithType:repositoryTypesToLoad andOptions:(NSDictionary *)options;
- (NSArray *)loadInformationForRepository:repositoryContentType withOptions:(NSDictionary *)options;

- (NSDictionary *)loadFileWithInformation:(NSDictionary *)fileInformation;
//- (NSArray *)getNotificationsForUser;
- (void)getNotificationsForUserWithCallback:(JSONResponseBlock)callback;

- (NSArray *)searchForRepositoriesWithCriteria:(NSDictionary *)criteria;
- (NSArray *)searchForUsersWithCriteria:(NSDictionary *)criteria;

- (BOOL)createCommitWithInformation:(NSDictionary *)commitInformation;
@end
