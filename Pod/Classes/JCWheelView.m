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

@interface JCWheelView ()

@end

@implementation JCWheelView
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
    self.image = [UIImage imageNamed:@"wheel_bg"];

    JCRotateGestureRecognizer *rotateGR = [[JCRotateGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    [self addGestureRecognizer:rotateGR];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self.image drawInRect:rect];
    
    CGFloat radius = rect.size.height/2;
    CGFloat degrees = 270.0f;//the above is the starting point
    
    for (int i = 0; i < self.numberOfItems; i++) {
        JCWheelItem *item = [[JCWheelItem alloc] initWithWheelView:self];
        item.tag = i;
       
        CGFloat centerX = radius + (radius/2 * cos(DEGREES_TO_RADIANS(degrees)));
        CGFloat centerY = radius + (radius/2 * sin(DEGREES_TO_RADIANS(degrees)));
        
        item.center = CGPointMake(centerX, centerY);
        item.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS((degrees + 90.0f)));
        
        degrees += 360/self.numberOfItems;
        
        [self addSubview:item];
    }

    self.centerView.center = CGPointMake(CGRectGetMinX(self.frame) + radius, CGRectGetMinY(self.frame) + radius);
    [self.superview insertSubview:self.centerView aboveSubview:self];
        
    
    
    self.xxx = CGPointMake(self.centerView.center.x, self.centerView.center.y-self.centerView.frame.size.height/2);
    NSLog(@"_____%@",NSStringFromCGPoint(self.xxx));
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(self.xxx.x, self.xxx.y, 5, 5)];
    test.backgroundColor = [UIColor blackColor];
    [self.superview insertSubview:test aboveSubview:self];
}

- (void)handleRotateGesture:(JCRotateGestureRecognizer *)rotateGR
{
    if (rotateGR.state == UIGestureRecognizerStateChanged) {//rotate
        self.transform = CGAffineTransformRotate(self.transform, rotateGR.rotation);
    }
    else if(rotateGR.state == UIGestureRecognizerStateEnded) {//tap
        [UIView animateWithDuration:0.3f animations:^{
            self.transform = CGAffineTransformRotate(self.transform, rotateGR.rotation);
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(wheelView:didSelectItemAtIndex:)]) {
                [self.delegate wheelView:self didSelectItemAtIndex:rotateGR.seletedIndex];
            }
        }];
    }
}

#pragma mark -

- (JCWheelCenterView *)centerView
{
    if (!_centerView) {
        _centerView = [[JCWheelCenterView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
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
