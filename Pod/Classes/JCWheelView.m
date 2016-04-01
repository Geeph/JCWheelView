//
//  JCWheelView.m
//  JCWheelView
//
//  Created by 李京城 on 15/6/27.
//  Copyright (c) 2014 李京城. All rights reserved.
//

#import "JCWheelView.h"
#import "JCWheelItem.h"
#import "JCWheelCenterView.h"
#import "JCRotateGestureRecognizer.h"

@implementation JCWheelView
@synthesize baseWheelItem = _baseWheelItem;
@synthesize numberOfItems = _numberOfItems;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    _image = [UIImage imageNamed:@"wheel_bg"];

    JCRotateGestureRecognizer *rotateGR = [[JCRotateGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    [self addGestureRecognizer:rotateGR];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.size.height = frame.size.width;
    self.frame = frame;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self.image drawInRect:rect];
    
    CGFloat radius = rect.size.height/2;
    CGFloat degrees = 270.0f;//the above is the starting point
    
    JCWheelItem *selectedItem = nil;
    
    for (int i = 0; i < self.numberOfItems; i++) {
        JCWheelItem *item = [[JCWheelItem alloc] initWithWheelView:self];
        item.tag = i;
       
        CGFloat centerX = radius + (radius/2 * cos(DEGREES_TO_RADIANS(degrees)));
        CGFloat centerY = radius + (radius/2 * sin(DEGREES_TO_RADIANS(degrees)));
        
        item.center = CGPointMake(centerX, centerY);
        item.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS((degrees + 90.0f)));
        
        degrees += 360/self.numberOfItems;
        
        [self addSubview:item];
        
        if (i == self.seletedIndex) {
            selectedItem = item;
        }
    }
    
    degrees = DEGREES_TO_RADIANS(180) + atan2(self.transform.a, self.transform.b) + atan2(selectedItem.transform.a, selectedItem.transform.b);
    
    JCRotateGestureRecognizer *rotateGR = self.gestureRecognizers.firstObject;
    rotateGR.degrees = degrees;
    
    [self performSelector:@selector(handleRotateGesture:) withObject:rotateGR afterDelay:0];
    
    self.baseWheelItem.userInteractionEnabled = NO;
    [self.superview insertSubview:self.baseWheelItem aboveSubview:self];
    [self.superview insertSubview:self.centerView aboveSubview:self];
}

- (void)handleRotateGesture:(JCRotateGestureRecognizer *)rotateGR
{
    if (rotateGR.state == UIGestureRecognizerStateChanged) { //rotate
        self.transform = CGAffineTransformRotate(self.transform, rotateGR.degrees);
    }
    else if(rotateGR.state == UIGestureRecognizerStateEnded || rotateGR.state == UIGestureRecognizerStatePossible) { //tap or init
        CGFloat duration = (rotateGR.state == UIGestureRecognizerStateEnded) ? 0.3 : 0.0;
        
        [UIView animateWithDuration:duration animations:^{
            self.transform = CGAffineTransformRotate(self.transform, rotateGR.degrees);
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(wheelView:didSelectItemAtIndex:)]) {
                [self.delegate wheelView:self didSelectItemAtIndex:self.seletedIndex];
            }
        }];
    }
}

#pragma mark -

- (JCWheelItem *)baseWheelItem
{
    if (!_baseWheelItem) {
        _baseWheelItem = [[JCWheelItem alloc] initWithWheelView:self];
        
        CGRect baseWheelItemFrame = self.baseWheelItem.frame;
        baseWheelItemFrame.origin.x = (self.frame.size.width - baseWheelItemFrame.size.width)/2 + self.frame.origin.x;
        baseWheelItemFrame.origin.y = self.frame.origin.y;
        
        self.baseWheelItem.frame = baseWheelItemFrame;
    }
    
    return _baseWheelItem;
}

- (JCWheelCenterView *)centerView
{
    if (!_centerView) {
        _centerView = [[JCWheelCenterView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        _centerView.center = self.center;
    }
    
    return _centerView;
}

- (NSInteger)numberOfItems
{
    if ([self.delegate respondsToSelector:@selector(numberOfItemsInWheelView:)]) {
        _numberOfItems = [self.delegate numberOfItemsInWheelView:self];
    }
    
    return _numberOfItems;
}

@end
