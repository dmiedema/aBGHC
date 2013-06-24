//
//  DMHomeScreenCollectionViewCell.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/23/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMHomeScreenCollectionViewCell.h"

@implementation DMHomeScreenCollectionViewCell 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _topView = [[DMHomeScreenCellTopView alloc] initWithFrame:self.bounds];
        _topView.labelContents = _topViewLabelContent;
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:_topView];
        
    }
    return self;
}

- (void)setTopViewLabelContent:(NSString *)topViewLabelContent {
    _topViewLabelContent = topViewLabelContent;
    _topView.labelContents = _topViewLabelContent;
}

- (void)setTopView:(DMHomeScreenCellTopView *)topView {
    _topView = topView;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}


#pragma mark - Implementation

- (void)showTopView {
    
}


@end
