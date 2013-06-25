//
//  aBGHCConstants.h
//  aBGHC
//
//  Created by Daniel Miedema on 6/15/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#define TESTING 1

#pragma mark GitHub Constants

#pragma mark - Configuration/Account
static NSString *const aBGHC_GitHubClientID             = @"8881762e516271c9af67";
static NSString *const aBGHC_GitHubClientSecret         = @"a850b277689c5cc93e3dbbcbe12e96011f972ecf";
static NSString *const aBGHC_GitHubScope                = @"user,notifications,repo,gist,delete_repo";

#pragma mark - Model
static NSString *const aBGHC_GitHubApiUrl               = @"https://api.github.com";
static NSString *const aBGHC_DefaultHTTPType            = @"application/json";
static NSString *const aBGHC_DefaultHTTPMethod          = @"GET";

#pragma mark - NSUserDefaults
static NSString *const aBGHC_CurrentUser                = @"aBGHC_CurrentUser";
static NSString *const aBGHC_AllAccounts                = @"aBGHC_AllUsersAccounts";
static NSString *const aBGHC_UUID                       = @"aBGHC_UUID";
static NSString *const aBGHC_AccessToken                = @"access_token";
static NSString *const aBGHC_TokenType                  = @"token_type";
static NSString *const aBGHC_Username                   = @"username";


#pragma mark - NSNotificationCenter Notifications
static NSString *const aBGHC_CommitCancelledNotification      = @"aBGHC-Commit-Cancelled-Notification";
static NSString *const aBGHC_CommitMessagePostedNotification  = @"aBGHC-Commit-Posted-Notification";

static NSString *const aBGHC_Model_NotificationsRecieved      = @"aBGHC-Model-NotifcationsForUserRecieved";

//static NSString *const aBGHC_TintColor [UIColor greenColor];