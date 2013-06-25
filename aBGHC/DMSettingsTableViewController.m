//
//  DMTableViewController.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/15/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMSettingsTableViewController.h"

@interface DMSettingsTableViewController ()
@property (nonatomic, strong) NSArray *options;
@end

@implementation DMSettingsTableViewController

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
    _options = [NSArray new];
    _options = [DMGitHubClient settingsScreenOptions];
    
    NSLog(@"Options : %@", _options);
    
    self.navigationItem.backBarButtonItem.title = @"";
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _options.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

//    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontDescriptorTextStyleBody];
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontDescriptorTextStyleAttribute];
    cell.textLabel.font = [UIFont fontWithDescriptor:descriptor size:0.0];
    cell.textLabel.text = [_options objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
