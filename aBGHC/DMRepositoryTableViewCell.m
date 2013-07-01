//
//  DMRepositoryTableViewCell.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/30/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMRepositoryTableViewCell.h"

@implementation DMRepositoryTableViewCell
+ (UIView *)createTableViewCellWithBounds:(CGRect)bounds andWithDictionary:(NSDictionary *)currentRepo {
    
    UIFontDescriptor *nameDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *subtitleDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline2];
    //    static NSString *CellIdentifier = @"Repository Cell";
    // custom cell, gotta love that custom cell
    //    DMRepositoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    UIView *cellView = [[UIView alloc] initWithFrame:bounds];
    //    x 20 y 1  w 300 h 39
    UILabel *repositoryNameLabel = [[UILabel alloc] init];
    [repositoryNameLabel setFont:[UIFont fontWithDescriptor:nameDescriptor size:0.0]];
    repositoryNameLabel.backgroundColor = [UIColor clearColor];
    repositoryNameLabel.text = [currentRepo objectForKey:@"name"];
//    repositoryNameLabel.frame = CGRectMake(20, 1, bounds.size.width, bounds.size.height * .66);
//    [repositoryNameLabel setFrame:CGRectMake(20, 1, 300, 39)];
    
    //    x 42 y 38 w 278 h 21
    UILabel *repositoryDetailLabel = [[UILabel alloc] init];
    [repositoryDetailLabel setFont:[UIFont fontWithDescriptor:subtitleDescriptor size:0.0]];
    repositoryDetailLabel.backgroundColor = [UIColor clearColor];
    [repositoryDetailLabel setText:[NSString stringWithFormat:@"Forks: %@ - Issues: %@ - Watchers: %@",
                                    [currentRepo objectForKey:@"forks_count"],
                                    [currentRepo objectForKey:@"open_issues_count"],
                                    [currentRepo objectForKey:@"watchers"]]];
    [repositoryDetailLabel setTextColor:[UIColor darkGrayColor]];
    
//    UIImageView *private = [[UIImageView alloc] initWithImage:[_factory createImageForIcon:NIKFontAwesomeIconLock]];
//    [private setFrame:CGRectMake(280, 0, 18, 29)];
//    
//    UIImageView *fork = [[UIImageView alloc] initWithImage:[_factory createImageForIcon:NIKFontAwesomeIconCodeFork]];
//    [fork setFrame:CGRectMake(0, 0, 32, 57)];
//    
//    UIImageView *normalRepo = [[UIImageView alloc] initWithImage:[_factory createImageForIcon:NIKFontAwesomeIconFolderOpen]];
//    [normalRepo setFrame:CGRectMake(0, 0, 60, 57)];
//    
//    if ([[currentRepo objectForKey:@"private"] integerValue] == 1) {
//        [cellView addSubview:private];
//    } //else [[cell privateRepo] setImage:nil];
//      // repo fork?
//    if ([[currentRepo objectForKey:@"fork"] integerValue] == 1) {
//        [cellView addSubview:fork];
//    } else [cellView addSubview:normalRepo];
    
    [cellView addSubview:repositoryNameLabel];
    [cellView addSubview:repositoryDetailLabel];
    
//    NSDictionary *views = NSDictionaryOfVariableBindings(repositoryNameLabel, repositoryDetailLabel);
    
//    NSArray *appliedConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[repositoryNameLabel]-[repositoryDetailLabel]|H:|-20-[repositoryNameLabel]|" options:NSLayoutFormatAlignAllBaseline metrics:Nil views:views];
    
//    [cellView addConstraints:appliedConstraints];
    
    return cellView;
}

@end
