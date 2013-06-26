//
//  DMGitHubClient.h
//  aBGHC
//
//  Created by Daniel Miedema on 6/13/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^JSONResponseBlock)(id JSON);
typedef void (^ErrorResponseBlock)(NSDictionary *error);

@interface DMGitHubClient : NSObject

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

typedef enum {
  REPOSITORIES,
  USERS
} searchType;

+ (DMGitHubClient *)sharedInstance;
+ (NSArray *)homeScreenOptions;
+ (NSArray *)searchScopeOptions;
+ (NSArray *)settingsScreenOptions;

// Change accounts
- (void)loadCredentialsForAccountWithUsername:(NSString *)username;
// Create new Account
- (void)createNewAccountWithUsername:(NSString *)username accessToken:(NSString *)accessToken andTokenType:(NSString *)tokenType;
// Load repository content
- (void)loadRepositoryInformation:(repositoryContentType)infoType forRepo:(NSDictionary *)repository withSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)error;
// Load repository details
- (void)loadRepositoriesWithOptions:(repositoryTypesToLoad)repoType onSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)failure;
// Load a particular file
- (void)loadFileWithInformation:(NSDictionary *)dictionary withSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)failure;
// Get notifications
- (void)getNotificationsForUserWithSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)failure;
// Mark all notifications as read
- (void)markAllNotificationsAsReadWithSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)failure;
// Search
- (void)searchWithType:(searchType)type andCriteria:(NSDictionary *)criteria withSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)error;
// Create a file
- (void)createNewFileWithInformation:(NSDictionary *)information withSuccess:(JSONResponseBlock)sucess andError:(ErrorResponseBlock)error;
// Create a Commit
- (void)createCommitWithInformation:(NSDictionary *)commitInformation withSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)error;
@end
