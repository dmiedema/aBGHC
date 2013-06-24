//
//  DMHomeScreenCellTopView.m
//  aBGHC
//
//  Created by Daniel Miedema on 6/23/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMHomeScreenCellTopView.h"

@interface DMHomeScreenCellTopView()
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation DMHomeScreenCellTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Creating homescreen top view");
        // Initialization code
        _labelContents = [NSString new];
        
        _contentLabel = [UILabel new];
        _contentLabel.text = self.labelContents;
        _contentLabel.frame = frame;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        
        UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontDescriptorTextStyleHeadline1];
        _contentLabel.font = [UIFont fontWithDescriptor:descriptor size:0.0];
        
    }
    NSLog(@"SELF : %@", [self class]);
    [self addSubview:_contentLabel];
    return self;
}

- (void)setLabelContents:(NSString *)labelContents {
    NSLog(@"Label contents : %@", labelContents);
    _contentLabel.text = labelContents;
    _labelContents = labelContents;
}

@end
