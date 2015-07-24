//
//  JCWheelCenterView.h
//  JCWheelView
//
//  Created by 李京城 on 15/7/23.
//  Copyright (c) 2015年 lijingcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCWheelCenterView : UIView

@property (nonatomic, strong) UIImage *image;

//Area outside the effective range can respond to events
@property (nonatomic, assign) CGRect effectiveRect;

@end
