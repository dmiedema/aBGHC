//
//  User.h
//  aBGHC
//
//  Created by mittens on 6/18/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Repository;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * followers;
@property (nonatomic, retain) NSNumber * following;
@property (nonatomic, retain) NSString * gravatar_id;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * public_gists;
@property (nonatomic, retain) NSNumber * public_repos;
@property (nonatomic, retain) NSSet *respositories;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRespositoriesObject:(Repository *)value;
- (void)removeRespositoriesObject:(Repository *)value;
- (void)addRespositories:(NSSet *)values;
- (void)removeRespositories:(NSSet *)values;

@end
