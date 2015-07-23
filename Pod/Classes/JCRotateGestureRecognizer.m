//
//  JCRotateGestureRecognizer.m
//  JCWheelView
//
//  Created by 李京城 on 15/6/27.
//  Copyright (c) 2014 李京城. All rights reserved.
//

#import "JCRotateGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "JCWheelView.h"
#import "JCWheelItem.h"

@implementation JCRotateGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = (touches.count == 1) ? UIGestureRecognizerStateBegan : UIGestureRecognizerStateFailed;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateChanged;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    CGPoint currentLocation = [touch locationInView:self.view];
    CGPoint previousLocation = [touch previousLocationInView:self.view];
    
    float previousAngle = atan2((previousLocation.y - center.y), (previousLocation.x - center.x));
    float currentAngle = atan2((currentLocation.y - center.y), (currentLocation.x - center.x));
    
    self.rotation = currentAngle - previousAngle;
    
    
    
    
    NSLog(@"_______%f,%f,%f,%f", previousAngle, currentAngle, self.rotation, RADIANS_TO_DEGREES(self.rotation));
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStateChanged) {
        
        
        JCWheelView *wheelView = (JCWheelView *)self.view;
        NSLog(@"%@", NSStringFromCGPoint(wheelView.xxx));
        
        
        CGPoint stopPoint = wheelView.xxx;
        
        for (JCWheelItem *itemView in self.view.subviews) {
            CGPoint touchPoint = [self locationInView:itemView];
            
//            self.view t
            
            if (CGPathContainsPoint(itemView.bezierPath.CGPath, NULL, stopPoint, NO)) {
                NSLog(@"seleted   %ld",(long)itemView.tag);
                self.rotation = DEGREES_TO_RADIANS(180) + atan2(self.view.transform.a, self.view.transform.b) + atan2(itemView.transform.a, itemView.transform.b);
                
                self.seletedIndex = itemView.tag;
                
                break;
            }
        }
       
        
//        NSLog(@"2  %@", NSStringFromCGRect(wheelView.centerView.frame));
        
//        NSLog(@"%f, %f, %f", wheelView.centerView.center.y, wheelView.centerView.frame.origin.y, wheelView.centerView.frame.size.height);
//        CGPoint stopPoint = CGPointMake(150, 100);
//
    }
    else if(self.state == UIGestureRecognizerStateBegan) {
        for (JCWheelItem *itemView in self.view.subviews) {
            CGPoint touchPoint = [self locationInView:itemView];
            
            if (CGPathContainsPoint(itemView.bezierPath.CGPath, NULL, touchPoint, NO)) {
                self.rotation = DEGREES_TO_RADIANS(180) + atan2(self.view.transform.a, self.view.transform.b) + atan2(itemView.transform.a, itemView.transform.b);
                
                self.seletedIndex = itemView.tag;
                
                break;
            }
        }
    }
    
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateCancelled;
}

@end
