//
//  DMNewAccountWebViewController.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/25/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMNewAccountWebViewController.h"

@interface DMNewAccountWebViewController () <UIWebViewDelegate>
@property (nonatomic, strong) NSDictionary *token;

- (void)saveTokenInformation:(NSDictionary *)tokenInfo;
@end

@implementation DMNewAccountWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setDelegate:self];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&scope=%@", aBGHC_GitHubAuthenticationURL, aBGHC_GitHubClientID, aBGHC_GitHubScope]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120]];
    [webView setOpaque:YES];
    self.view = webView;
//    [AFNetworkActivityIndicatorManager sharedManager] 
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *mainURL = request.mainDocumentURL.absoluteString;
    NSArray *components = [mainURL componentsSeparatedByString:@"?"];
    
    NSLog(@"Request Main URL: %@", [request mainDocumentURL]);
    NSLog(@"Request All HTTP Headers: %@", [request allHTTPHeaderFields]);
    NSLog(@"Request HTTP Method: %@", [request HTTPMethod]);
    NSLog(@"Request HTTP Body: %@", [request HTTPBody]);
    NSLog(@"\n----- Components: %@\n", components);
    
    if ([[components objectAtIndex:0] isEqual:@"http://danielmiedema.com/"]) {
        NSArray *code = [[components objectAtIndex:1] componentsSeparatedByString:@"="];
        
        NSLog(@"redirected to danielmiedema.com");
        NSLog(@"Code: %@", [code objectAtIndex:1]);
        
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?code=%@&client_id=%@&client_secret=%@", aBGHC_GitHubOAuthTokenURL, [code objectAtIndex:1], aBGHC_GitHubClientID, aBGHC_GitHubClientSecret]]];
        [newRequest setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];

        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:newRequest success:^(NSURLRequest *request, NSHTTPURLResponse *reponse, id JSON) {
            [self saveTokenInformation:JSON];
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *reponse, NSError *error, id JSON) {
            NSLog(@"Failure Adding Account");
            NSLog(@"reponse: %@", reponse);
            NSLog(@"Error: %@", error);
            NSLog(@"JSON: %@", JSON);
        }];
        [operation start];
        return NO;
    }
    return YES;
}

- (void)saveTokenInformation:(NSDictionary *)tokenInfo {
    [_token setValuesForKeysWithDictionary:tokenInfo];
    NSString *url = [NSString stringWithFormat:@"%@/%@?%@=%@&%@=%@",
                     aBGHC_GitHubApiUrl, @"user",
                     aBGHC_AccessToken, [tokenInfo valueForKey:aBGHC_AccessToken],
                     aBGHC_TokenType, [tokenInfo valueForKey:aBGHC_TokenType]];
    
    NSLog(@"Token info: %@", tokenInfo);
    NSLog(@"url : %@", url);
    
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [newRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    AFJSONRequestOperation *getUserName = [AFJSONRequestOperation JSONRequestOperationWithRequest:newRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[DMGitHubClient sharedInstance] createNewAccountWithUsername:[JSON objectForKey:@"login"] accessToken:[tokenInfo objectForKey:aBGHC_AccessToken] andTokenType:[tokenInfo objectForKey:aBGHC_TokenType]];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure to create new account");
        NSLog(@"Response : %@", response);
        NSLog(@"Error : %@", error);
        NSLog(@"JSON : %@", JSON);
    }];
    [getUserName start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
