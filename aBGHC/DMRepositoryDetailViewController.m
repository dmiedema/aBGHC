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

@property NSInteger starCount;

@end

@implementation DMRepositoryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"DETAILS");
    NSLog(@"%@", _details);
    
	// Do any additional setup after loading the view.
    NSDictionary *ownerDetails = _details[@"owner"];
    
    // Setup items
//    _scrollView = [UIScrollView new];
//    _ownerAvatar = [UIImageView new];
//    _reponameLabel = [UILabel new];
//    _usernameLabel = [UILabel new];
//    _descriptionLabel = [UILabel new];
//    _forkButton = [UIButton new];
//    _starButton = [UIButton new];
//    _watchButton = [UIButton new];
//    _readmeButton = [UIButton new];
//    _checkCodeButton = [UIButton new];
//    _checkCommitsButton = [UIButton new];
//    _checkStatsButton = [UIButton new];
 

    // Give them value
    [_ownerAvatar setImageWithURL:[NSURL URLWithString:ownerDetails[@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"placeholder_1"]];
    
    _reponameLabel.text = _details[@"name"];
    _usernameLabel.text = ownerDetails[@"login"];
    
    _descriptionLabel.text = (_details[@"description"] == [NSNull null]) ? @"" : _details[@"description"];
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.preferredMaxLayoutWidth = self.view.bounds.size.width - 40;
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    _descriptionLabel.constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:||" options:<#(NSLayoutFormatOptions)#> metrics:<#(NSDictionary *)#> views:<#(NSDictionary *)#>]
    
    [_forkButton setTitle:[NSString stringWithFormat:@"%@ - Forks", _details[@"forks_count"]] forState:UIControlStateNormal];
    [_starButton setTitle:[NSString stringWithFormat:@"%@ - Stars", _details[@"watchers_count"] ] forState:UIControlStateNormal];
    [_watchButton setTitle:@"Watch" forState:UIControlStateNormal];
    
    _readmeButton.titleLabel.text = @"Readme";
    [_readmeButton addTarget:self action:@selector(openReadme:) forControlEvents:UIControlEventTouchUpInside];
    
    _checkCodeButton.titleLabel.text = @"Code";
    [_checkCodeButton addTarget:self action:@selector(openCode:) forControlEvents:UIControlEventTouchUpInside];
    
    _checkCommitsButton.titleLabel.text = @"Commits";
    [_checkCommitsButton addTarget:self action:@selector(openCommits:) forControlEvents:UIControlEventTouchUpInside];
    
    _checkStatsButton.titleLabel.text = @"Stats";
    [_checkStatsButton addTarget:self action:@selector(openStats:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",_ownerAvatar, _reponameLabel, _usernameLabel, _descriptionLabel, _forkButton, _starButton, _watchButton, _readmeButton, _checkCodeButton, _checkCommitsButton, _checkStatsButton);
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_scrollView, _ownerAvatar, _reponameLabel, _usernameLabel, _descriptionLabel, _forkButton, _starButton, _watchButton, _readmeButton, _checkCodeButton, _checkCommitsButton, _checkStatsButton);
    
    NSLog(@"View: %@", views);

    NSString *verticalLayoutString = @"[_ownerAvatar(100@100)]-[_descriptionLabel]-[_forkButton]-[_starButton]-[_watchButton]-10-[_readmeButton]-[_checkCodeButton]-[_checkCommitsButton]-[_checkStatsButton]";
    NSArray *verticalContraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalLayoutString options:0 metrics:nil views:views];

    NSString *horizontalLayoutString = @"[_ownerAvatar(100@100)]-[_reponameLabel]";
    NSString *usernameAndReponameLayoutString = @"[_reponameLabel]-[_usernameLabel]";
    
    NSArray *horizontalContraints = [NSLayoutConstraint constraintsWithVisualFormat:horizontalLayoutString options:0 metrics:nil views:views];
    NSArray *usernameReponameContraints = [NSLayoutConstraint constraintsWithVisualFormat:usernameAndReponameLayoutString options:0 metrics:nil views:views];
    
    // Calculate _scrollViews content size
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
        _ownerAvatar.frame.size.height +
        _descriptionLabel.frame.size.height +
        _forkButton.frame.size.height +
        _starButton.frame.size.height +
        _watchButton.frame.size.height +
        _readmeButton.frame.size.height +
        _checkCodeButton.frame.size.height +
        _checkCommitsButton.frame.size.height +
        _checkStatsButton.frame.size.height);

    // Put everything in _scrollView
//    [_scrollView addSubview:_ownerAvatar];
//    [_scrollView addSubview:_reponameLabel];
//    [_scrollView addSubview:_usernameLabel];
//    [_scrollView addSubview:_descriptionLabel];
//    [_scrollView addSubview:_forkButton];
//    [_scrollView addSubview:_starButton];
//    [_scrollView addSubview:_watchButton];
//    [_scrollView addSubview:_readmeButton];
//    [_scrollView addSubview:_checkCodeButton];
//    [_scrollView addSubview:_checkCommitsButton];
//    [_scrollView addSubview:_checkStatsButton];
//    
//    // Set the view to _scrollview
//    [self.view addSubview:_scrollView];
//    
//    [self.view addConstraints:verticalContraints];
//    [self.view addConstraints:horizontalContraints];
//    [self.view addConstraints:usernameReponameContraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)viewDidLayoutSubviews {
    _ownerAvatar.layer.masksToBounds = YES;
    _ownerAvatar.layer.cornerRadius = _ownerAvatar.bounds.size.width / 2.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark Methods
#pragma mark Actions
- (IBAction)forkRepo:(UIButton *)sender {
    NSLog(@"fork Repo Pressed");
}
- (IBAction)starRepo:(UIButton *)sender {
    NSLog(@"star Repo Pressed");
}

- (IBAction)watchRepo:(UIButton *)sender {
    NSLog(@"watch Repo Pressed");
}
#pragma mark Navigation Push
- (IBAction)openReadme:(UIButton *)sender {
    NSLog(@"open Readme Pressed");
}

- (IBAction)openCommits:(UIButton *)sender {
    NSLog(@"open Commits Pressed");
}

- (IBAction)openCode:(UIButton *)sender {
    NSLog(@"open Code Pressed");
}

- (IBAction)openStats:(UIButton *)sender {
    NSLog(@"open Stats Pressed");
}

@end
