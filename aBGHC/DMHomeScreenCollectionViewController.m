//
//  DMCollectionViewController.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/15/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMHomeScreenCollectionViewController.h"
#import "DMSettingsTableViewController.h"
#import "DMHomeScreenCellTopView.h"
#import "DMAccountsViewController.h"
#import "DMNotificationsTableViewController.h"
#import "DMHomeScreenCollectionViewCell.h"
#import "DMRepositoriesTableViewController.h"

@interface DMHomeScreenCollectionViewController ()

@property (nonatomic, strong) NSArray *options;

@end

@implementation DMHomeScreenCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _options = [NSArray new];
    _options = [DMGitHubClient homeScreenOptions];
//    NSLog(@"options : %@", _options);
    // Set edge insets on Collection View
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    // Set up cell height in CollectionView
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings:)];

    UIBarButtonItem *addAccountButton = [[UIBarButtonItem alloc] initWithTitle:@"Accounts" style:UIBarButtonItemStyleBordered target:self action:@selector(addAccount:)];

//    UIBarButtonItem *addAccountButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccount:)];
    
    self.navigationItem.leftBarButtonItem = settingsButton;
    self.navigationItem.rightBarButtonItem = addAccountButton;
    
//    self.navigationController.title = [[DMGitHubClient sharedInstance] currentUsername];
    
    NSLog(@"Current username: %@", self.navigationController.title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Actions

- (void)showSettings:(id)sender {
    NSLog(@"Show Settings Here");
    DMSettingsTableViewController *settingsView = [self.storyboard instantiateViewControllerWithIdentifier:@"DMSettingsTableView"];
    [self.navigationController pushViewController:settingsView animated:YES];
}
- (void)addAccount:(id)sender {
    NSLog(@"Add Account here");
    DMAccountsViewController *accountsView = [self.storyboard instantiateViewControllerWithIdentifier:@"DMAccountsViewController"];
    [self.navigationController pushViewController:accountsView animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath {
    
    static NSString *reuseID = @"Cell";
    
    DMHomeScreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    UILabel *label = [UILabel new];
    label.text = _options[indexPath.row];
    label.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height-1);
    label.backgroundColor = [UIColor whiteColor];
    
//    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontDescriptorTextStyleHeadline1];
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    label.font = [UIFont fontWithDescriptor:descriptor size:0.0];
//    DMHomeScreenCellTopView *topView = [DMHomeScreenCellTopView new];
    DMHomeScreenCellTopView *topView = [[DMHomeScreenCellTopView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height - 1)];
//    topView.bounds = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height -1);
    topView.labelContents = _options[indexPath.row];
//
//    NSLog(@"Top View : %@", topView);
    cell.backgroundColor = [UIColor grayColor];
    [cell addSubview:topView];
//    cell.topView = topView;
    
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView
            viewForSupplementaryElementOfKind:(NSString *)kind
                                  atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _options.count;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionViewDelegate

//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//    
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItem = _options[indexPath.row];
    NSLog(@"Selected Item : %@", _options[indexPath.row]);
    
    if ([selectedItem isEqualToString:@"Notifications"]) {
        DMNotificationsTableViewController *notificationsController = [self.storyboard instantiateViewControllerWithIdentifier:@"DMNotificationsController"];
        [self.navigationController pushViewController:notificationsController animated:YES];
    }
    
    if ([selectedItem isEqualToString:@"Repositories"]) {
        DMRepositoriesTableViewController *repositoriesController = [self.storyboard instantiateViewControllerWithIdentifier:@"DMRepositoriesTableViewController"];
        [self.navigationController pushViewController:repositoriesController animated:YES];
    }
}


- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
