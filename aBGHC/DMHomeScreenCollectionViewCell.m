//
//  DMHomeScreenCollectionViewCell.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/23/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMHomeScreenCollectionViewCell.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation DMHomeScreenCollectionViewCell 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
//        _topView = [[DMHomeScreenCellTopView alloc] initWithFrame:self.bounds];
//        _topView.labelContents = _topViewLabelContent;
//        _topView.backgroundColor = [UIColor whiteColor];
//        _topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
//        [self.contentView addSubview:_topView];
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.delegate = self;
        [self addGestureRecognizer:_panGesture];
    }
    return self;
}

- (void)setTopViewLabelContent:(NSString *)topViewLabelContent {
    self.topViewLabelContent = topViewLabelContent;
    self.topView.labelContents = self.topViewLabelContent;
}

- (void)setTopView:(DMHomeScreenCellTopView *)topView {
    self.topView = topView;
}

#pragma mark - UIGestureRecognizerDelegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.panGesture touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    [self.panGesture touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self.panGesture touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self.panGesture touchesCancelled:touches withEvent:event];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Gesture should begin recognizing");
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}


#pragma mark - Implementation

- (void)handleGesture:(UIPanGestureRecognizer *)gesture {
    NSLog(@"Handing gesture.");
    if (gesture == self.panGesture && gesture.numberOfTouches == 1 && gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [gesture locationInView:self.contentView];
        
        CGRect frame = self.topView.frame;
        frame.origin.y = location.y;
        if (frame.origin.y <= 0)
            frame.origin.y = 0;
        self.topView.frame = frame;
        
        CGFloat percent = (self.contentView.bounds.size.height - location.y) / self.contentView.bounds.size.height;
        self.topView.alpha = percent;
    }
    else if (gesture == self.panGesture && gesture.state == UIGestureRecognizerStateEnded)
    {
        if (self.topView.frame.origin.y < self.bounds.size.height/2)
            //[self hideContentView];
            NSLog(@"Gesutre state ended");
        else
            //[self showContentView];
            NSLog(@"Gesutre state ended");
    }
}

- (void)showTopView {
    
}


@end
