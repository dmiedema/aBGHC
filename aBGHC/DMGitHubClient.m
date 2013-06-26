//
//  DMGitHubClient.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/13/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.

#import "DMGitHubClient.h"
#import <DerpKit/DerpKit.h>

@interface DMGitHubClient()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *tokenType;

@property (nonatomic, strong) NSString *httpHeaderTokenString;

@end

typedef void (^JSONResponseDictionaryBlock)(NSDictionary *json);

#pragma mark Search Scope Options
NSString *searchScopeMine = @"Mine";
NSString *searchScopeStarred = @"Starred";
NSString *searchScopeWatched = @"Watched";

#pragma mark Home Screen Options
NSString *homeScreenNotifications = @"Notifications";
NSString *homeScreenRepositories = @"Repositories";
NSString *homeScreenGists = @"Gists";

#pragma mark Settings Screen Options
NSString *settingsScreenAbout = @"About";
NSString *settingsScreenAcknowledgements = @"Acknowledgements";
NSString *settingsScreenTwitter = @"Follow Developer on Twitter";
NSString *settingsScreenContactSupport = @"Contact Support";

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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      searchScope = @[searchScopeMine, searchScopeStarred, searchScopeWatched];
    });
    return searchScope;
}

+ (NSArray *)settingsScreenOptions {
    static NSArray *settingsOptions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settingsOptions = @[settingsScreenAbout, settingsScreenAcknowledgements, settingsScreenContactSupport, settingsScreenTwitter];
    });
    return settingsOptions;
}

#pragma mark init
- (id)init {
    self = [super init];

    if (self) {
        NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:aBGHC_CurrentUser];
        _username    = [currentUser objectForKey:aBGHC_Username];
        _accessToken = [currentUser objectForKey:aBGHC_AccessToken];
        _tokenType   = [currentUser objectForKey:aBGHC_TokenType];
        if (_accessToken && _tokenType)
            _httpHeaderTokenString = [NSString stringWithFormat:@"&%@=%@&%@=%@",
                          aBGHC_AccessToken, _accessToken,
                          aBGHC_TokenType, _tokenType];
        else _httpHeaderTokenString = @"";
    }
    return self;
}


#pragma mark Implemenatation
- (void)loadCredentialsForAccountWithUsername:(NSString *)username {
    if ([_username isEqualToString:username]) return;
    NSArray *accounts = [[NSUserDefaults standardUserDefaults] objectForKey:aBGHC_AllAccounts];
    NSDictionary *newUser = nil;
    for (NSDictionary *account in accounts) {
        if ([[[account allKeys] objectAtIndex:0] isEqualToString:username]) {
            newUser = [account objectForKey:[[account allKeys] objectAtIndex:0]];
            _username    = [newUser objectForKey:aBGHC_Username];
            _accessToken = [newUser objectForKey:aBGHC_AccessToken];
            _tokenType   = [newUser objectForKey:aBGHC_TokenType];
            if (_accessToken && _tokenType)
                _httpHeaderTokenString = [NSString stringWithFormat:@"&%@=%@&%@=%@",
                                          aBGHC_AccessToken, _accessToken,
                                          aBGHC_TokenType, _tokenType];
            else _httpHeaderTokenString = @"";
            [[NSUserDefaults standardUserDefaults] setObject:_username forKey:aBGHC_CurrentUser];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } // End foreach check.
}

- (void)createNewAccountWithUsername:(NSString *)username accessToken:(NSString *)accessToken andTokenType:(NSString *)tokenType {
    NSMutableArray *accounts = [[[NSUserDefaults standardUserDefaults] objectForKey:aBGHC_AllAccounts] mutableCopy];
    
    if (!accounts) accounts = [NSMutableArray new];
    
    NSDictionary *newAccountDetails = @{aBGHC_Username : username, aBGHC_AccessToken : accessToken, aBGHC_TokenType : tokenType};
    NSDictionary *newAccount = @{username : newAccountDetails};
   
    [accounts addObject:newAccount];
    
    [[NSUserDefaults standardUserDefaults] setObject:accounts forKey:aBGHC_AllAccounts];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadRepositoryInformation:(repositoryContentType)infoType forRepo:(NSDictionary *)repository withSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)failure {
  NSString *urlString;
  switch (infoType) {
    case README:
      urlString = [NSString stringWithFormat:@"repos/%@/%@/readme", [repository objectForKey:@"owner"], [repository objectForKey:@"repo"]];
      break;
    case COMMITS:
      urlString = [NSString stringWithFormat:@"/repos/%@/%@/commits", [repository objectForKey:@"owner"], [repository objectForKey:@"repo"]];
      break;
    case FILES:
      urlString = [NSString stringWithFormat:@"repos/%@/%@/contents/%@", [repository objectForKey:@"owner"], [repository objectForKey:@"repo"], [repository objectForKey:@"path"]];
      break;
    default:
      break;
  }
  NSString *url = [NSString stringWithFormat:@"%@/%@?%@", aBGHC_GitHubApiUrl, urlString, _httpHeaderTokenString];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
  
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
      success(JSON);
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    NSLog(@"Error loading Repo Info");
    NSLog(@"TRACE : DMGitHubClient -- loadRepositoryInformation -- ");
    NSLog(@"Error : %@", error);
    NSLog(@"Error JSON: %@", JSON);
    failure(JSON);
  }];
  [operation start];
}

- (void)loadRepositoriesWithOptions:(repositoryTypesToLoad)repoType onSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)failure {
  NSString *urlString;
  switch (repoType) {
    case MINE:
      urlString = [NSString stringWithFormat:@"user/repos"];
      break;
    case STARRED:
      urlString = [NSString stringWithFormat:@"user/starred"];
      break;
    case WATCHED:
      urlString = [NSString stringWithFormat:@"user/subscriptions"];
      break;
    default:
      break;
  }
  NSString *url = [NSString stringWithFormat:@"%@/%@?%@", aBGHC_GitHubApiUrl, urlString, _httpHeaderTokenString];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
  
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    success(JSON);
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    NSLog(@"Error loading Repositories");
    NSLog(@"TRACE : DMGitHubClient -- loadRepositoriesWithOptions -- ");
    NSLog(@"Error : %@", error);
    NSLog(@"Error JSON: %@", JSON);
    failure(JSON);
  }];
  [operation start];
}

- (void)loadFileWithInformation:(NSDictionary *)dictionary withSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)failure {
  
}

- (void)getNotificationsForUserWithSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)failure{
    NSString *urlString = [NSString stringWithFormat:@"%@/notifications?%@", aBGHC_GitHubApiUrl, _httpHeaderTokenString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
          success(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error recieving notificaions");
        NSLog(@"TRACE : DMGitHubClient -- getNotificationsForUser -- ");
        NSLog(@"Error : %@", error);
        NSLog(@"Error JSON: %@", JSON);
      failure(JSON);
    }];
    [operation start];
}

- (void)searchWithType:(searchType)type andCriteria:(NSDictionary *)criteria withSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)failure {
  NSString *urlString;
  // keyword, &language, start_page, sort, order
  NSString *params;
  if ([criteria count] > 1) {
    for (NSString *key in [criteria allKeys]) {
      if ([key isEqualToString:@"keyword"]) continue; // break on keyword.
      [params stringByAppendingString:[NSString stringWithFormat:@"%@&%@=%@", params, key, [criteria objectForKey:key]]];
    }
  }
  
  switch (type) {
    case REPOSITORIES:
      urlString = [NSString stringWithFormat:@"legacy/repos/search/%@?%@", [criteria objectForKey:@"keyword"], params];
      break;
    case USERS:
      urlString = [NSString stringWithFormat:@"legacy/user/search/%@?%@", [criteria objectForKey:@"keyword"], params];
      break;
    default:
      break;
  }
  NSString *url = [NSString stringWithFormat:@"%@/%@%@", aBGHC_GitHubApiUrl, urlString, _httpHeaderTokenString];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
  
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    success(JSON);
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    NSLog(@"Error Searching");
    NSLog(@"TRACE : DMGitHubClient -- searchWithType -- ");
    NSLog(@"Error : %@", error);
    NSLog(@"Error JSON: %@", JSON);
    failure(JSON);
  }];
  [operation start];
}
- (void)createNewFileWithInformation:(NSDictionary *)information withSuccess:(JSONResponseBlock)sucess andError:(ErrorResponseBlock)error {
  ////
  //  PUT /repos/:owner/:repo/contents/:path
  ////
  //  Parameters
  //  
  //  path
  //  Required string - The content path.
  //  message
  //  Required string - The commit message.
  //  content
  //  Required string - The new file content, Base64 encoded.
  //  branch
  //  Optional string - The branch name. If not provided, uses the repository’s default branch (usually master).
  NSString *content = [information objectForKey:@"content"];
  
  NSMutableDictionary *params = [NSMutableDictionary new];
  [params setValue:[information objectForKey:@"path"] forKey:@"path"];
  [params setValue:[information objectForKey:@"message"] forKey:@"message"];
  [params setValue:[content derp_stringByBase64EncodingString] forKey:@"content"];
  if ([information objectForKey:@"branch"])
    [params setValue:[information objectForKey:@"branch"] forKey:@"branch"];
  
//  NSMutableURLRequest *request = [NSMutableURLRequest new];
}

- (void)createCommitWithInformation:(NSDictionary *)commitInformation withSuccess:(JSONResponseBlock)success andError:(ErrorResponseBlock)error {
    
}

#pragma mark Private Helper Methods

- (NSArray *)convertDictionaryToArray:(NSDictionary *)json {
  return [NSArray arrayWithObjects:json, nil];
}

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
