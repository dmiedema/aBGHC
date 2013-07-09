//
//  DMRepositoryDetailViewController.m
//  aBGHC
//
//  Created by Daniel Miedema on 7/4/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMRepositoryDetailViewController.h"
//// display
// repo name, username, user image, forks, stars, watchers, readme, description
/// See/Checkout
// commits, contents, branches,
//// Actions
// Star, Fork, Watch

@interface DMRepositoryDetailViewController ()

//// Other
@property (nonatomic, strong) UIFontDescriptor *mainFontDescriptor;
@property (nonatomic, strong) UIFontDescriptor *subtitleFontDescriptor;
@property (nonatomic, strong) UIFontDescriptor *headerFontDescriptor;

@end

@implementation DMRepositoryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSDictionary *ownerDetails = _details[@"owner"];
    
    [_ownerAvatar setImageWithURL:[NSURL URLWithString:ownerDetails[@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"placeholder_1"]];
    
    _reponameLabel.text = _details[@"name"];
    _usernameLabel.text = ownerDetails[@"login"];
    _descriptionLabel.text = _details[@"description"];
    
    __block int starCount;
    [[DMGitHubClient sharedInstance] getNumberOfStarsForRepo:@{@"owner": ownerDetails[@"login"], @"name": _details[@"name"]} withSuccess:^(id JSON) {
        if ([JSON isKindOfClass:[NSArray class]]) {
            starCount = [JSON count];
        }
    } andError:^(NSDictionary *error) {
        
    }];
    
    _forkButton.titleLabel.text = [NSString stringWithFormat:@"%@ - Forks", _details[@"forks_count"]];
    _starButton.titleLabel.text = [NSString stringWithFormat:@"%i - Stars", starCount];
    _watchButton.titleLabel.text = [NSString stringWithFormat:@"%@ - Watchers", _details[@"watchers_count"]];
    
    _readmeButton;
    _checkCodeButton;
    _checkCommitsButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark Methods
#pragma mark Actions
- (IBAction)forkRepo:(UIButton *)sender {
    
}
- (IBAction)starRepo:(UIButton *)sender {
}

- (IBAction)watchRepo:(UIButton *)sender {
}
#pragma mark Navigation Push
- (IBAction)openReadme:(UIButton *)sender {
}

- (IBAction)openCommits:(UIButton *)sender {
}

- (IBAction)openCode:(UIButton *)sender {
}

@end
