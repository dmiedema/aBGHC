//
//  DMHomeScreenCollectionViewCell.h
//  aBGHC
//
//  Created by Daniel Miedema on 6/23/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMHomeScreenCellTopView.h"

@interface DMHomeScreenCollectionViewCell : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, strong) DMHomeScreenCellTopView *topView;
@property (nonatomic, strong) id bottomView;

@property (nonatomic, strong) NSString *topViewLabelContent;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

- (void)showTopView;

@end
