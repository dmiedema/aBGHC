//
//  DMRepositoriesTableViewController.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/25/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMRepositoriesTableViewController.h"
#import "DMRepositoryTableViewCell.h"

@interface DMRepositoriesTableViewController ()
//@property (nonatomic) NSMutableArray *searchResults;
//@property BOOL scrollViewIsAtTop;

@property (nonatomic, strong) UISegmentedControl *segmentControl;

- (void)updateTable;
- (void)segmentControlChanged:(UISegmentedControl *)sender;

@end

@implementation DMRepositoriesTableViewController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:aBGHC_NewAccountCreatedNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[DMGitHubClient sharedInstance] cancelNetworkRequests];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Offset/hide search bar on view load.
//    self.tableView.contentOffset = CGPointMake(0.0, self.searchDisplayController.searchBar.frame.size.height);
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:[DMGitHubClient searchScopeOptions]];
    [_segmentControl addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
    _segmentControl.frame = self.tableView.tableHeaderView.frame;
    
    _segmentControl.selectedSegmentIndex = 0;
    
    [[DMGitHubClient sharedInstance] loadRepositoriesWithOptions:MINE onSuccess:^(id JSON) {
//        NSLog(@"JSON: %@", JSON);
        _repos = JSON;
        [self updateTable];
    } andError:^(NSDictionary *error) {
        NSLog(@"ERRR");
    }];
    
    // Set up search scope
//    self.searchDisplayController.searchBar.scopeButtonTitles = [DMGitHubClient searchScopeOptions];
//    NSLog(@"search results tableView: %@", self.searchDisplayController.searchResultsTableView);
    
//    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[DMGitHubClient sharedInstance] cancelNetworkRequests];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//        return [_searchResults count];
    
    return [_repos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSLog(@"Section : %i", (int)indexPath.section);
    
    // Configure the cell...
    
//    [cell addSubview:[DMRepositoryTableViewCell createTableViewCellWithBounds:cell.bounds andWithDictionary:[_repos objectAtIndex:indexPath.row]]];
    
    NSDictionary *current;
    
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        current = [_searchResults objectAtIndex:indexPath.row];
//    } else {
//        current = [_repos objectAtIndex:indexPath.row];
//    }
    current = _repos[indexPath.row];
    cell.textLabel.text = [current objectForKey:@"name"];
    cell.detailTextLabel.text = [[current objectForKey:@"owner"] objectForKey:@"login"];
    
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return _segmentControl.frame.size.height;
//    }
//    return 0;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return _segmentControl;
    }
    return nil;
}

#pragma mark - UISearchDisplayController Delegate Methods

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{    
//    // Return YES to cause the search result table view to be reloaded.
//    return NO;
//}
//
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    NSLog(@"Search Scope Changed");
//    NSLog(@"%@", [[controller.searchBar.scopeButtonTitles objectAtIndex:searchOption] uppercaseString]);
//    
//    NSString *selectedItem = [controller.searchBar.scopeButtonTitles objectAtIndex:searchOption];
//    
//    NSDictionary *mappings = @{
//                               @"Mine" : [[NSNumber alloc] initWithInt:MINE],
//                               @"Starred" : [[NSNumber alloc] initWithInt:STARRED],
//                               @"Watching" : [[NSNumber alloc] initWithInt:WATCHED]
//                               };
//    
//    if (![selectedItem isEqualToString:@"All"]) {
//        [[DMGitHubClient sharedInstance] loadRepositoriesWithOptions:(int)[mappings objectForKey:selectedItem] onSuccess:^(id JSON) {
//            NSLog(@"Selected JSON: %@", JSON);
//                if (self.isViewLoaded) {
//                    _repos = JSON;
//                    [self.tableView reloadData];
//                }
//        } andError:^(NSDictionary *error) {
//            NSLog(@"Selected ERRR: %@", error);
//        }];
//    }
//        // Return YES to cause the search result table view to be reloaded.
////    return YES;
//    return NO;
//}

#pragma mark - Private Methods
- (void)updateTable {
    [self.tableView reloadData];
//    self.tableView.contentOffset = CGPointMake(0.0, self.searchDisplayController.searchBar.frame.size.height);
}

- (void)segmentControlChanged:(UISegmentedControl *)sender {
    int selectedIndex = [sender selectedSegmentIndex];
    switch (selectedIndex) {
        case 0: { // Mine
            [[DMGitHubClient sharedInstance] loadRepositoriesWithOptions:MINE onSuccess:^(id JSON) {
                _repos = JSON;
                [self updateTable];
            } andError:^(NSDictionary *error) {
                NSLog(@"Error loading mine: %@", error);
            }];
            break;
        }
        case 1: { // Starred
            [[DMGitHubClient sharedInstance] loadRepositoriesWithOptions:STARRED onSuccess:^(id JSON) {
                _repos = JSON;
                [self updateTable];
            } andError:^(NSDictionary *error) {
                NSLog(@"Error loading starred: %@", error);
            }];
            break;
        }
        case 2: { // Watching
            [[DMGitHubClient sharedInstance] loadRepositoriesWithOptions:WATCHED onSuccess:^(id JSON) {
                _repos = JSON;
                [self updateTable];
            } andError:^(NSDictionary *error) {
                NSLog(@"Error loading watching: %@", error);
            }];
            break;
        }
        default:
            break;
    }
}

/********************
 
 #pragma mark - Content Filtering
 
 - (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName
 {
 //  Update the filtered array based on the search text and scope.
 
if ((productName == nil) || [productName length] == 0)
{
    // If there is no search string and the scope is "All".
    if (typeName == nil)
    {
        self.searchResults = [self.products mutableCopy];
    }
    else
    {
        // If there is no search string and the scope is chosen.
        NSMutableArray *searchResults = [[NSMutableArray alloc] init];
        for (APLProduct *product in self.products)
        {
            if ([product.type isEqualToString:typeName])
            {
                [searchResults addObject:product];
            }
        }
        self.searchResults = searchResults;
    }
    return;
}


[self.searchResults removeAllObjects]; // First clear the filtered array.

 // Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
 
for (APLProduct *product in self.products)
{
    if ((typeName == nil) || [product.type isEqualToString:typeName])
    {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange productNameRange = NSMakeRange(0, product.name.length);
        NSRange foundRange = [product.name rangeOfString:productName options:searchOptions range:productNameRange];
        if (foundRange.length > 0)
        {
            [self.searchResults addObject:product];
        }
    }
}
}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *scope;
    
    NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    if (selectedScopeButtonIndex > 0)
    {
        scope = [[APLProduct deviceTypeNames] objectAtIndex:(selectedScopeButtonIndex - 1)];
    }
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = [self.searchDisplayController.searchBar text];
    NSString *scope;
    
    if (searchOption > 0)
    {
        scope = [[APLProduct deviceTypeNames] objectAtIndex:(searchOption - 1)];
    }
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}



 ******************************/


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
