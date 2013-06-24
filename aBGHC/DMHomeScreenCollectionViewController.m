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

@interface DMHomeScreenCollectionViewController ()

@property (nonatomic, strong) NSArray *options;

@end

@implementation DMHomeScreenCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _options = [NSArray new];
    _options = [DMGitHubClient homeScreenOptions];
    NSLog(@"options : %@", _options);
    // Set edge insets on Collection View
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    // Set up cell height in CollectionView
    
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(showSettings:)];
    
    UIBarButtonItem *addAccountButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccount:)];
    
    self.navigationItem.leftBarButtonItem = settingsButton;
    self.navigationItem.rightBarButtonItem = addAccountButton;
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
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath {
    
    static NSString *reuseID = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    UILabel *label = [UILabel new];
    label.text = [_options objectAtIndex:indexPath.row];
    label.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height-1);
    label.backgroundColor = [UIColor whiteColor];
    
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontDescriptorTextStyleHeadline1];
    label.font = [UIFont fontWithDescriptor:descriptor size:0.0];
    
    DMHomeScreenCellTopView *topView = [[DMHomeScreenCellTopView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height - 1)];
    topView.labelContents = [_options objectAtIndex:indexPath.row];

    NSLog(@"Top View : %@", topView);
    cell.backgroundColor = [UIColor grayColor];
    [cell addSubview:topView];
    
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
    NSLog(@"Selected Item : %@", [_options objectAtIndex:indexPath.row]);
    
}


- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
