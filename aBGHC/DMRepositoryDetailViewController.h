//
//  DMRepositoryDetailViewController.h
//  aBGHC
//
//  Created by Daniel Miedema on 7/4/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMRepositoryDetailViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIImageView *ownerAvatar;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *reponameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
// @property (nonatomic, weak) IBOutlet UILabel *repoDetailsLabel;

@property (nonatomic, weak) IBOutlet UIButton *forkButton;
@property (nonatomic, weak) IBOutlet UIButton *starButton;
@property (nonatomic, weak) IBOutlet UIButton *watchButton;
@property (nonatomic, weak) IBOutlet UIButton *readmeButton;
@property (nonatomic, weak) IBOutlet UIButton *checkCommitsButton;
@property (nonatomic, weak) IBOutlet UIButton *checkCodeButton;
@property (nonatomic, weak) IBOutlet UIButton *checkStatsButton;

@property (nonatomic, strong) NSDictionary *details;
- (IBAction)forkRepo:(UIButton *)sender;
- (IBAction)starRepo:(UIButton *)sender;
- (IBAction)watchRepo:(UIButton *)sender;

- (IBAction)openReadme:(UIButton *)sender;
- (IBAction)openCommits:(UIButton *)sender;
- (IBAction)openCode:(UIButton *)sender;
- (IBAction)openStats:(UIButton *)sender;
@end
