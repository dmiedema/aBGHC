//
//  DMNotificationsTableViewController.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/25/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMNotificationsTableViewController.h"

@interface DMNotificationsTableViewController ()

@property (nonatomic, strong) NSArray *notifications;

@property (nonatomic, strong) NSArray *repositoryNames;
@property (nonatomic, strong) NSArray *notificationDetails;

@end

@implementation DMNotificationsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[DMGitHubClient sharedInstance] getNotificationsForUserWithSuccess:^(id json) {
        [self loadNotificationsIntoTable:json];
    } andError:^(NSDictionary *error) {
        [self handleError:error];
    }];
}

- (void)loadNotificationsIntoTable:(NSArray *)notifications {
    NSLog(@"contnets : %@", notifications);
    
    NSMutableArray *repositoryNotifications = [NSMutableArray new];
    NSMutableArray *repositoryNames = [NSMutableArray new];
    for (NSDictionary *dictionary in notifications) {
        NSString *id = [dictionary objectForKey:@"id"];
        NSString *repoName = [[dictionary objectForKey:@"repository"] objectForKey:@"name"];
        NSString *type = [[dictionary objectForKey:@"subject"] objectForKey:@"type"];
        NSString *title = [[dictionary objectForKey:@"subject"] objectForKey:@"title"];
        
        if (![repositoryNames containsObject:repoName])
            [repositoryNames addObject:repoName];
        
        NSDictionary *customDict = @{@"id" : id,
                                     @"repoName" : repoName,
                                     @"type" : type,
                                     @"title" : title };
        
        [repositoryNotifications addObject:customDict];
        //        [repositoryNotifications addObject:dictionary];
    }
    
    _repositoryNames = repositoryNames;
    _notificationDetails = repositoryNotifications;
    
    NSLog(@"__repositoryNames : %@", repositoryNames);
    NSLog(@"__notificationDetails : %@", repositoryNotifications);
    
    [[self tableView] reloadData];
    
}

- (void)handleError:(NSDictionary *)error {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_repositoryNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *repoNameAtIndex = [_repositoryNames objectAtIndex:section];
    int i = 0;
    //    NSMutableArray *notificationsForRepo = [NSMutableArray new];
    for (NSDictionary *dict in _notificationDetails) {
        if ( [[dict objectForKey:@"repoName"] isEqualToString:repoNameAtIndex] ) {
            i++;
        }
    }
    return i;
}
#define DEFAULT_LABEL_HEIGHT 20.0
#define PADDING (DEFAULT_LABEL_HEIGHT / 2)
#define DEFAULT_LABEL_WIDTH 280

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    // Configure the cell...
    NSString *currentRepoSection = [_repositoryNames objectAtIndex:[indexPath section]];
    
    NSMutableArray *notificationsForCurrentSectionsRepo = [NSMutableArray new];
    for (NSDictionary *dictionary in _notificationDetails) {
        if ([[dictionary objectForKey:@"repoName"] isEqualToString:currentRepoSection] && ![notificationsForCurrentSectionsRepo containsObject:dictionary])
            [notificationsForCurrentSectionsRepo addObject:dictionary];
    }
    NSDictionary *dictionary = [notificationsForCurrentSectionsRepo objectAtIndex:[indexPath row]];
    
    int y = PADDING; // starting off at 0 looks like doodoo.
    NSString *title = [dictionary objectForKey:@"title"];
    NSString *type  = [dictionary objectForKey:@"type"];
    
    UILabel *titleLabel = [UILabel new];
    UILabel *typeLabel  = [UILabel new];

    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:0.0];
    
    // setup title label
    [titleLabel setFont:font];
    [titleLabel setNumberOfLines:0];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize constraintSize = CGSizeMake(DEFAULT_LABEL_WIDTH, MAXFLOAT);
    CGSize messageSize = [title sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    [titleLabel setText:title];
    [titleLabel setFrame:CGRectMake(PADDING * 2, y, messageSize.width, messageSize.height)];
    
    y += messageSize.height;
    
    // set up type label
    [typeLabel setAlpha:0.7];
    [typeLabel setTextColor:[UIColor darkGrayColor]];
    [typeLabel setFont:font];
    [typeLabel setText:[NSString stringWithFormat:@"Type - %@", type]];
    [typeLabel setBackgroundColor:[UIColor clearColor]];
    [typeLabel setFrame:CGRectMake(PADDING * 2, y, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT)];
    
    y += DEFAULT_LABEL_HEIGHT;
    
    [cell addSubview:titleLabel];
    [cell addSubview:typeLabel];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_repositoryNames objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentRepoSection = [_repositoryNames objectAtIndex:[indexPath section]];
    
    NSMutableArray *notificationsForCurrentSectionsRepo = [NSMutableArray new];
    for (NSDictionary *dictionary in _notificationDetails) {
        if ([[dictionary objectForKey:@"repoName"] isEqualToString:currentRepoSection] && ![notificationsForCurrentSectionsRepo containsObject:dictionary])
            [notificationsForCurrentSectionsRepo addObject:dictionary];
    }
    NSDictionary *dictionary = [notificationsForCurrentSectionsRepo objectAtIndex:[indexPath row]];
    
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline2];
    CGSize textSize = [[dictionary objectForKey:@"title"] sizeWithFont:[UIFont fontWithDescriptor:descriptor size:0.0] constrainedToSize:CGSizeMake(self.tableView.frame.size.width - PADDING * 4, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return textSize.height + (PADDING * 4);
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
