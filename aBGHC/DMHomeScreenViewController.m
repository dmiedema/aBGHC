//
//  DMHomeScreenViewController.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/24/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMHomeScreenViewController.h"
#import "DMGitHubClient.h"

@interface DMHomeScreenViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *options;

@property (nonatomic, strong) UIPanGestureRecognizer *pullDownGesture;

@end

@implementation DMHomeScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _options = [NSArray new];
        _options = [DMGitHubClient homeScreenOptions];
        
        _pullDownGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        _pullDownGesture.minimumNumberOfTouches = 1;
        _pullDownGesture.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    DMHomeScreenNotificationsCellBottomView *notificationsBottomView = [[DMHomeScreenNotificationsCellBottomView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 128)];
    
    DMHomeScreenRepositoriesCellBottomView *repoBottomView = [[DMHomeScreenRepositoriesCellBottomView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 128)];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
