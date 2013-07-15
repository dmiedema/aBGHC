//
//  DMRepositoryDetailViewController.h
//  aBGHC
//
//  Created by Daniel Miedema on 7/4/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMRepositoryDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIImageView *ownerAvatar;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *reponameLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
// @property (nonatomic, strong) IBOutlet UILabel *repoDetailsLabel;

@property (nonatomic, strong) IBOutlet UIButton *forkButton;
@property (nonatomic, strong) IBOutlet UIButton *starButton;
@property (nonatomic, strong) IBOutlet UIButton *watchButton;
@property (nonatomic, strong) IBOutlet UIButton *readmeButton;
@property (nonatomic, strong) IBOutlet UIButton *checkCommitsButton;
@property (nonatomic, strong) IBOutlet UIButton *checkCodeButton;
@property (nonatomic, strong) IBOutlet UIButton *checkStatsButton;

@property (nonatomic, strong) NSDictionary *details;
- (IBAction)forkRepo:(UIButton *)sender;
- (IBAction)starRepo:(UIButton *)sender;
- (IBAction)watchRepo:(UIButton *)sender;

- (IBAction)openReadme:(UIButton *)sender;
- (IBAction)openCommits:(UIButton *)sender;
- (IBAction)openCode:(UIButton *)sender;
- (IBAction)openStats:(UIButton *)sender;
@end
