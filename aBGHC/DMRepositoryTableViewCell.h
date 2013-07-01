//
//  DMRepositoryTableViewCell.h
//  aBGHC
//
//  Created by Daniel Miedema on 6/30/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMRepositoryTableViewCell : NSObject

+ (UIView *)createTableViewCellWithBounds:(CGRect)bounds andWithDictionary: (NSDictionary *)currentRepo;

@end
