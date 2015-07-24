//
//  JCWheelCenterView.m
//  JCWheelView
//
//  Created by 李京城 on 15/7/23.
//  Copyright (c) 2015年 lijingcheng. All rights reserved.
//

#import "JCWheelCenterView.h"

@interface JCWheelCenterView ()

@property (nonatomic, strong) UIBezierPath *bezierPath;

@end

@implementation JCWheelCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.image = [UIImage imageNamed:@"wheel_arrow"];
        
        self.effectiveRect = CGRectInset(frame, 20.0f, 20.0f);
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self.image drawInRect:rect];
    
    self.bezierPath = [UIBezierPath bezierPathWithOvalInRect:self.effectiveRect];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGPathContainsPoint(self.bezierPath.CGPath, NULL, point, NO);
}

@end
