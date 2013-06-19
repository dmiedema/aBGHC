//
//  DMGitHubClient.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/13/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.

#import "DMGitHubClient.h"

@interface DMGitHubClient()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *tokenType;

@property (nonatomic, strong) NSString *httpHeaderTokenString;

@end

NSString *searchScopeMine = @"Mine";
NSString *searchScopeStarred = @"Starred";
NSString *searchScopeWatched = @"Watched";

NSString *homeScreenNotifications = @"Notifications";
NSString *homeScreenRepositories = @"Repositories";
NSString *homeScreenGists = @"Gists";

typedef enum {
  UserNotifications = 0,
  AllRepositories,
  UserRepositories,
  StarredRepositories,
  WatchedRepositories,
  SearchRepositories,
} githubOperation;

@implementation DMGitHubClient

#pragma mark Class Methods

+ (DMGitHubClient *)sharedInstance {
    static DMGitHubClient *client = nil;
    //        client = [[DMGitHubClient alloc] initWithBaseURL:[NSURL URLWithString:aBGHC_GitHubApiUrl]];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      client = [[DMGitHubClient alloc] init];
    });
    
    return client;
}

+ (NSArray *)homeScreenOptions {
    static NSArray *homeScreen = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
      homeScreen = @[homeScreenNotifications, homeScreenRepositories, homeScreenGists];
    });
    return homeScreen;
}

+ (NSArray *)searchScopeOptions {
    static NSArray *searchScope = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
      searchScope = @[searchScopeMine, searchScopeStarred, searchScopeWatched];
    });
    return searchScope;
}

#pragma mark init
- (id)init {
    self = [super init];
    
    if (self) {
      _username    = [[NSUserDefaults standardUserDefaults] objectForKey:aBGHC_Username];
      _accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:aBGHC_AccessToken];
      _tokenType   = [[NSUserDefaults standardUserDefaults] objectForKey:aBGHC_TokenType];
      if (_accessToken && _tokenType)
          _httpHeaderTokenString = [NSString stringWithFormat:@"&%@=%@&%@=%@",
                          aBGHC_AccessToken, _accessToken,
                          aBGHC_TokenType, _tokenType];
      else _httpHeaderTokenString = @"";
    }
    
    return self;
}

#pragma mark Implemenatation
- (NSArray *)loadRepositoriesWithType:(id)repositoryTypesToLoad andOptions:(NSDictionary *)options {
    NSString *urlString = [NSString stringWithFormat:@"%@/", aBGHC_GitHubApiUrl];
    
    NSMutableURLRequest *repositoryRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    
    repositoryRequest = nil;
    return nil;
}

- (NSArray *)loadInformationForRepository:(id)repositoryContentType withOptions:(NSDictionary *)options {
    return nil;
}

- (NSDictionary *)loadFileWithInformation:(NSDictionary *)fileInformation {
    
    return nil;
}

- (void)getNotificationsForUserWithCallback:(JSONResponseBlock)callback {
    NSString *urlString = [NSString stringWithFormat:@"%@/notifications?%@", aBGHC_GitHubApiUrl, _httpHeaderTokenString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([JSON isKindOfClass:[NSArray class]])
            callback(JSON);
        else
            callback([[NSArray alloc] initWithObjects:JSON, nil]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error recieving notificaions");
        NSLog(@"TRACE : DMGitHubClient -- getNotificationsForUser -- ");
        NSLog(@"Error : %@", error);
        NSLog(@"Error JSON: %@", JSON);
    }];
    [operation start];
}

- (NSArray *)searchForRepositoriesWithCriteria:(NSDictionary *)criteria {
    return nil;
}

- (NSArray *)searchForUsersWithCriteria:(NSDictionary *)criteria; {
    return nil;
}

- (BOOL)createCommitWithInformation:(NSDictionary *)commitInformation {
    /*
    1. Get all commits
    2. Create new blob
    3. Create new tree
    4. Create new commit
    5. Update ref
    */
    
    NSLog(@"Commit Information : %@", commitInformation);    
    
    // Format commitInformation Dictionary continually to make this work
    return NO;
}

#pragma mark NSURLConnectionDelegate Methods

/*
+ (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler

connection:didReceiveResponse:, connection:didReceiveData:, connection:didFailWithError: and connectionDidFinishLoading:.
*/

#pragma mark Private Helper Methods

//- (NSString *)createURLForGithubOperation:(NSString *)operation {
//    
//}

- (NSArray *)translateNSDataToJsonArray:(NSData *)data andError:(NSError *)error {
    id JSONdata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return ([JSONdata isKindOfClass:[NSArray class]]) ? JSONdata : [NSArray arrayWithObject:JSONdata];
}

- (NSDictionary *)translateNSDataToJsonDictionary:(NSData *)data andError:(NSError *)error {
    id JSONdata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return ([JSONdata isKindOfClass:[NSDictionary class]]) ? JSONdata : nil;
}

- (NSArray *)loadAllCommitsForRepositoryWithInformation:(NSDictionary *)information andError:(NSError *)error {
    NSMutableURLRequest *allCommitDataRequest = [[NSMutableURLRequest alloc] init];
    NSString *allCommitDataUrlRequest = [NSString stringWithFormat:@"%@repos/%@/%@/commits?%@",
                    aBGHC_GitHubApiUrl, [information objectForKey:@"login"], [information objectForKey:@"repoName"], _httpHeaderTokenString];

    [allCommitDataRequest setURL:[NSURL URLWithString:allCommitDataUrlRequest]];
    [allCommitDataRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSURLResponse *allCommitDataUrlResponse = nil;
    NSError *allCommitDataErr = nil;
    NSData *allCommitData = [NSURLConnection sendSynchronousRequest:allCommitDataRequest returningResponse:&allCommitDataUrlResponse error:&allCommitDataErr];
    NSLog(@"Commits recieved");
    NSLog(@"Data : %@", allCommitData);

    return [self translateNSDataToJsonArray:allCommitData andError:allCommitDataErr];
}


- (NSDictionary *)createNewBlobWithInformation:(NSDictionary *)information andError:(NSError *)error {
    NSMutableURLRequest *createNewBlobRequest = [[NSMutableURLRequest alloc] init];
    NSString *createNewBlobUrlRequest = [NSString stringWithFormat:@"%@repos/%@/%@/git/blobs?%@",
                    aBGHC_GitHubApiUrl, [information objectForKey:@"login"], [information objectForKey:@"repoName"], _httpHeaderTokenString];

    NSMutableDictionary *newBlobPostInformation = [[NSMutableDictionary alloc] init];
    [newBlobPostInformation setValue:[information objectForKey:@"new_content"] forKey:@"content"];
    [newBlobPostInformation setValue:@"utf-8" forKey:@"encoding"];
    NSData *newBlobPostData = [NSJSONSerialization dataWithJSONObject:newBlobPostInformation options:kNilOptions error:&error];

    [createNewBlobRequest setURL:[NSURL URLWithString:createNewBlobUrlRequest]];
    [createNewBlobRequest setHTTPMethod:@"POST"];
    [createNewBlobRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [createNewBlobRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [createNewBlobRequest setValue:[NSString stringWithFormat:@"%d", [newBlobPostData length]] forHTTPHeaderField:@"Content-Length"];
    [createNewBlobRequest setHTTPBody:newBlobPostData];

    NSURLResponse *newBlobUrlResponse = nil;
    NSError *newBlobErr = nil;
    NSData *newBlobData = [NSURLConnection sendSynchronousRequest:createNewBlobRequest returningResponse:&newBlobUrlResponse error:&error];
    NSLog(@"new blob created");

    return [self translateNSDataToJsonDictionary:newBlobData andError:newBlobErr];
}

- (NSDictionary *)createNewTreeWithInformation:(NSDictionary *)information andError:(NSError *)error {
    NSMutableURLRequest *createNewTreeRequest = [[NSMutableURLRequest alloc] init];
    NSString *createNewTreeUrlRequest = [NSString stringWithFormat:@"%@repos/%@/%@/git/trees?%@",
                    aBGHC_GitHubApiUrl, [information objectForKey:@"login"], [information objectForKey:@"repoName"], _httpHeaderTokenString];
    // because look at that selection, fuck that. Get it as a string.

    NSMutableDictionary *newTreePostInformation = [[NSMutableDictionary alloc] init];
    [newTreePostInformation setValue:[information objectForKey:@"parentTreeSHA"] forKey:@"base_tree"];
    [newTreePostInformation setValue:[NSArray arrayWithObjects:
            [NSDictionary dictionaryWithObjectsAndKeys:[information objectForKey:@"path"], @"path", @"100644", @"mode", @"blob", @"type", [information objectForKey:@"newBlobSHA"], @"sha", nil], nil]
                              forKey:@"tree"];

    NSLog(@"tree post info %@", newTreePostInformation);

    NSData *newTreePostData = [NSJSONSerialization dataWithJSONObject:newTreePostInformation options:kNilOptions error:nil];

    [createNewTreeRequest setURL:[NSURL URLWithString:createNewTreeUrlRequest]];
    [createNewTreeRequest setHTTPMethod:@"POST"];
    [createNewTreeRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [createNewTreeRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [createNewTreeRequest setValue:[NSString stringWithFormat:@"%d", [newTreePostData length]] forHTTPHeaderField:@"Content-Length"];
    [createNewTreeRequest setHTTPBody:newTreePostData];

    NSURLResponse *newTreeUrlResponse = nil;
    NSError *newTreeErr = nil;
    NSData *newTreeData = [NSURLConnection sendSynchronousRequest:createNewTreeRequest returningResponse:&newTreeUrlResponse error:&newTreeErr];
    
    return [self translateNSDataToJsonDictionary:newTreeData andError:newTreeErr];
}


- (NSDictionary *)createNewCommitWithInformation:(NSDictionary *)information andError:(NSError *)error {
    NSMutableURLRequest *newCommitRequest = [[NSMutableURLRequest alloc] init];
    NSString *createNewCommitUrlRequest = [NSString stringWithFormat:@"%@repos/%@/%@/git/commits?%@",
                    aBGHC_GitHubApiUrl, [information objectForKey:@"login"], [information objectForKey:@"repoName"], _httpHeaderTokenString];

    NSMutableDictionary *newCommitPostInformation = [[NSMutableDictionary alloc] init];
    [newCommitPostInformation setValue:[information objectForKey:@"commit_message"] forKey:@"message"];
    [newCommitPostInformation setValue:[information objectForKey:@"newTreeSHA"] forKey:@"tree"];
    [newCommitPostInformation setValue:[NSArray arrayWithObjects:[information objectForKey:@"lastCommitSHA"], nil] forKey:@"parents"];
    // convert dictionary to data
    NSData *newCommitPostData = [NSJSONSerialization dataWithJSONObject:newCommitPostInformation options:kNilOptions error:&error];

    [newCommitRequest setURL:[NSURL URLWithString:createNewCommitUrlRequest]];
    [newCommitRequest setHTTPMethod:@"POST"];
    [newCommitRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [newCommitRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [newCommitRequest setValue:[NSString stringWithFormat:@"%d", [newCommitPostData length]] forHTTPHeaderField:@"Content-Length"];
    [newCommitRequest setHTTPBody:newCommitPostData];

    NSURLResponse *newCommitUrlResponse = nil;
    NSError *newCommitErr = nil;
    NSData *newCommitData = [NSURLConnection sendSynchronousRequest:newCommitRequest returningResponse:&newCommitUrlResponse error:&error];
    
    return [self translateNSDataToJsonDictionary:newCommitData andError:newCommitErr];
}


- (NSDictionary *)updateRefWithNewCommit:(NSDictionary *)information andError:(NSError *)error {
    NSMutableURLRequest *updateRefRequest = [[NSMutableURLRequest alloc] init];
    // get current file branch
    NSString *fullUrl = [information objectForKey:@"url"];
    NSRange range = [fullUrl rangeOfString:@"?ref=" options:NSBackwardsSearch];
    NSString *branch = [fullUrl substringFromIndex:range.location + 5]; // offset '?ref=' value and just get branch name
    NSString *ref = [NSString stringWithFormat:@"refs/heads/%@", branch];

    NSString *updateRefUrlRequest =
            [NSString stringWithFormat:@"%@/repos/%@/%@/git/%@?%@", aBGHC_GitHubApiUrl, [information valueForKey:@"login"], [information valueForKey:@"repoName"], ref, _httpHeaderTokenString];

    NSMutableDictionary *updateRefPostInformation = [[NSMutableDictionary alloc] init];
    [updateRefPostInformation setValue:[information objectForKey:@"newCommitSHA"] forKey:@"sha"];
    [updateRefPostInformation setValue:@"false" forKey:@"force"];

    NSData *updateRefPostData = [NSJSONSerialization dataWithJSONObject:updateRefPostInformation options:kNilOptions error:&error];

    [updateRefRequest setURL:[NSURL URLWithString:updateRefUrlRequest]];
    [updateRefRequest setHTTPMethod:@"PATCH"];
    [updateRefRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [updateRefRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [updateRefRequest setValue:[NSString stringWithFormat:@"%d", [updateRefPostData length]] forHTTPHeaderField:@"Content-Length"];
    [updateRefRequest setHTTPBody:updateRefPostData];

    NSURLResponse *updateRefUrlResponse = nil;
    NSError *updateRefErr = nil;
    NSData *updateRefData = [NSURLConnection sendSynchronousRequest:updateRefRequest returningResponse:&updateRefUrlResponse error:&error];

    return [self translateNSDataToJsonDictionary:updateRefData andError:updateRefErr];
}




@end
