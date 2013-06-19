//
//  Repository.h
//  aBGHC
//
//  Created by mittens on 6/18/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Commit, User;

@interface Repository : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * full_name;
@property (nonatomic, retain) NSString * private;
@property (nonatomic, retain) NSNumber * repo_description;
@property (nonatomic, retain) NSNumber * fork;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSNumber * open_issues;
@property (nonatomic, retain) NSString * master_branch;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * watchers;
@property (nonatomic, retain) NSNumber * forks;
@property (nonatomic, retain) User *repository_owner;
@property (nonatomic, retain) NSSet *commits;
@end

@interface Repository (CoreDataGeneratedAccessors)

- (void)addCommitsObject:(Commit *)value;
- (void)removeCommitsObject:(Commit *)value;
- (void)addCommits:(NSSet *)values;
- (void)removeCommits:(NSSet *)values;

@end
