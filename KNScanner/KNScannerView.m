//
//  KNScannerView.m
//  KNScanner
//
//  Created by LuKane on 16/2/19.
//  Copyright © 2016年 LuKane. All rights reserved.
//

#import "KNScannerView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation KNScannerView{
    CGRect scanRect;
    UIImageView *line;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self toInitalizeDefaultSetting:frame];
    }
    return self;
}

- (void)awakeFromNib{
    [self toInitalizeDefaultSetting:self.frame];
}

- (void)toInitalizeDefaultSetting:(CGRect)frame{
    CGFloat width = 250;
    scanRect = CGRectMake((frame.size.width - width) * 0.5, 142, width, width);
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(scanRect.origin.x, scanRect.origin.y, scanRect.size.width, 2)];
    line.contentMode = UIViewContentModeScaleToFill;
    [line setImage:[UIImage imageNamed:@"patient_home_scanImage"]];
    line.alpha = 1;
    [self addSubview:line];
    
    self.aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scanRect) + 28, ScreenWidth, 15)];
    self.aLabel.font = [UIFont systemFontOfSize:13];
    self.aLabel.textColor = [UIColor whiteColor];
    self.aLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.aLabel];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scanRect.origin.x, frame.size.height)];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(scanRect), 0, scanRect.origin.x, frame.size.height)];
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(scanRect.origin.x, 0, scanRect.size.width, scanRect.origin.y)];
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(scanRect.origin.x, CGRectGetMaxY(scanRect), scanRect.size.width, frame.size.height - CGRectGetMaxY(scanRect))];
    
    /**
     *  四块区域的背景色以及 透明度 --- 配合控制器里头镜头的显示区域
     */
    UIColor *aColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [leftView setBackgroundColor:aColor];
    [rightView setBackgroundColor:aColor];
    [upView setBackgroundColor:aColor];
    [downView setBackgroundColor:aColor];
    
    [self addSubview:leftView];
    [self addSubview:rightView];
    [self addSubview:upView];
    [self addSubview:downView];
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    [[UIColor greenColor]  setStroke]; // 设置 四个拐角的背景色
    [self toDrawColorRect:scanRect withContect:myContext]; //给中间的那条线 做动画
}

- (void)toDrawColorRect:(CGRect)rect withContect:(CGContextRef)myContext{
    CGFloat length = 16;
    CGContextSetLineWidth(myContext, 3.0);
    CGFloat insetLenth = 1;
    
    CGPoint p1,p2,p3,p4;
    p1= CGPointMake(rect.origin.x + insetLenth, rect.origin.y + insetLenth);
    p2 = CGPointMake(CGRectGetMaxX(rect) - insetLenth, rect.origin.y + insetLenth);
    p3 = CGPointMake(rect.origin.x + insetLenth, CGRectGetMaxY(rect) - insetLenth);
    p4 = CGPointMake(p2.x, p3.y);
    
    CGContextMoveToPoint(myContext, p1.x + length, p1.y);
    CGContextAddLineToPoint(myContext, p1.x, p1.y);
    CGContextAddLineToPoint(myContext, p1.x, p1.y + length);
    CGContextDrawPath(myContext, kCGPathStroke);
    
    CGContextMoveToPoint(myContext, p2.x - length, p2.y);
    CGContextAddLineToPoint(myContext, p2.x, p2.y);
    CGContextAddLineToPoint(myContext, p2.x, p2.y + length);
    CGContextDrawPath(myContext, kCGPathStroke);
    
    CGContextMoveToPoint(myContext, p3.x + length, p3.y);
    CGContextAddLineToPoint(myContext, p3.x, p3.y);
    CGContextAddLineToPoint(myContext, p3.x, p3.y - length);
    CGContextDrawPath(myContext, kCGPathStroke);
    
    CGContextMoveToPoint(myContext, p4.x - length, p4.y);
    CGContextAddLineToPoint(myContext, p4.x, p4.y);
    CGContextAddLineToPoint(myContext, p4.x, p4.y - length);
    CGContextDrawPath(myContext, kCGPathStroke);
}

- (void)toStartAnimation{
    [line.layer removeAllAnimations];
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    theAnimation.duration=8;
    theAnimation.removedOnCompletion = YES;
    theAnimation.fromValue = [NSNumber numberWithFloat:1];
    theAnimation.toValue = [NSNumber numberWithFloat:80];
    
    CABasicAnimation *theAnimation1;
    theAnimation1=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation1.fromValue = [NSNumber numberWithFloat:0];
    theAnimation1.toValue = [NSNumber numberWithFloat:170];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:theAnimation1,theAnimation, nil];
    group.duration = 6;
    group.repeatCount = FLT_MAX;
    [line.layer addAnimation:group forKey:@"animateTransform"];
}



@end
