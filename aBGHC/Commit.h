//
//  Commit.h
//  aBGHC
//
//  Created by mittens on 6/18/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Repository;

@interface Commit : NSManagedObject

@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * tree;
@property (nonatomic, retain) NSString * parents;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Repository *repository;

@end
