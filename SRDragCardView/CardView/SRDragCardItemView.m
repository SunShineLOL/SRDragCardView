//
//  SRDragCardItemView.m
//
//  Created by Honey on 2018/8/8.
//  Copyright © 2018年 Honey. All rights reserved.
//



#define ACTION_MARGIN_RIGHT lengthFit(150)
#define ACTION_MARGIN_LEFT lengthFit(150)
#define ACTION_VELOCITY 400
#define SCALE_STRENGTH 4
#define SCALE_MAX .93
#define ROTATION_MAX 1
#define ROTATION_STRENGTH lengthFit(414)

#define BUTTON_WIDTH lengthFit(40)



#import "SRDragCardItemView.h"

@interface SRDragCardItemView()<UIGestureRecognizerDelegate>{
    CGFloat xFromCenter;
    CGFloat yFromCenter;
    CGSize  size;
}
@property (nonatomic,strong)UIView *bgView;
@end

@implementation SRDragCardItemView

// Retrieve and set the size
- (CGSize) size
{
    return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.size = frame.size;
        self.cornerRadius = 8;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowRadius      = 3;
        self.layer.shadowOpacity     = 0.2;
        self.layer.shadowOffset      = CGSizeMake(1, 1);
        self.layer.shadowPath        = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];
        
        self.bgView            = [[UIView alloc]initWithFrame:self.bounds];
        self.bgView.clipsToBounds      = YES;
        [self addSubview:self.bgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
        
        self.layer.allowsEdgeAntialiasing                 = YES;
        self.bgView.layer.allowsEdgeAntialiasing               = YES;
    }
    return self;
}

-(void)tapGesture:(UITapGestureRecognizer *)sender {
    if (!self.canPan) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(cardItemDidSelected:)]) {
        [self.delegate cardItemDidSelected:self];
    }
}
- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.bgView.layer.cornerRadius = 8;

}
- (CGFloat)getCornerRadius{
    return self.layer.cornerRadius;
}
#pragma mark ------------- 拖动手势
-(void)beingDragged:(UIPanGestureRecognizer *)gesture {
    if (!self.canPan) {
        return ;
    }
    xFromCenter = [gesture translationInView:self].x;
    yFromCenter = [gesture translationInView:self].y;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            CGFloat scale = MAX(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            self.center = CGPointMake(self.originalCenter.x + xFromCenter, self.originalCenter.y + yFromCenter);
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            self.transform = scaleTransform;
            [self updateOverLay:xFromCenter];
            
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self followUpActionWithDistance:xFromCenter andVelocity:[gesture velocityInView:self.superview]];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark ----------- 滑动时候，按钮变大
- (void) updateOverLay:(CGFloat)distance {
    
    if ([self.delegate respondsToSelector:@selector(moveCards:)]) {
        [self.delegate moveCards:distance];
    }
}

#pragma mark ----------- 后续动作判断
-(void)followUpActionWithDistance:(CGFloat)distance andVelocity:(CGPoint)velocity {
    if (!self.isLastPage && xFromCenter > 0 && (distance > ACTION_MARGIN_RIGHT || velocity.x > ACTION_VELOCITY )) {
        [self rightAction:velocity];
    } else if(!self.isLastPage && xFromCenter < 0 && (distance < - ACTION_MARGIN_RIGHT || velocity.x < -ACTION_VELOCITY)) {
        [self leftAction:velocity];
    }else {
        //回到原点
        [UIView animateWithDuration:RESET_ANIMATION_TIME
                         animations:^{
                             self.center = self.originalCenter;
                             self.transform = CGAffineTransformMakeRotation(0);
                         }];
        [self.delegate moveBackCards];
    }
}
-(void)rightAction:(CGPoint)velocity {
    CGFloat distanceX=[[UIScreen mainScreen]bounds].size.width+self.size.width+self.originalCenter.x;//横向移动距离
    CGFloat distanceY=distanceX*yFromCenter/xFromCenter;//纵向移动距离
    CGPoint finishPoint = CGPointMake(self.originalCenter.x+distanceX, self.originalCenter.y+distanceY);//目标center点
    
    CGFloat vel=sqrtf(pow(velocity.x, 2)+pow(velocity.y, 2));//滑动手势横纵合速度
    CGFloat displace=sqrt(pow(distanceX-xFromCenter,2)+pow(distanceY-yFromCenter,2));//需要动画完成的剩下距离
    
    CGFloat duration=fabs(displace/vel);//动画时间
    
    if (duration>0.6) {
        duration=0.6;
    }else if(duration<0.3){
        duration=0.3;
    }
    UIImageView *imageView = [self getImageViewWithView:self];
    if ([self.delegate respondsToSelector:@selector(adjustOtherCards)]) {
        [self.delegate adjustOtherCards];
    }
    if ([self.delegate respondsToSelector:@selector(swipCard:Direction:)]) {
        [self.delegate swipCard:self Direction:NO];
    }
    if ([self.delegate respondsToSelector:@selector(rightAnimateView:cardItemView:duration:finishPoint:)]) {
        [self.delegate rightAnimateView:imageView cardItemView:self duration:duration finishPoint:finishPoint];
    }
}

-(void)leftAction:(CGPoint)velocity {
    //横向移动距离
    CGFloat distanceX = -self.size.width - self.originalPoint.x;
    //纵向移动距离
    CGFloat distanceY = distanceX*yFromCenter/xFromCenter;
    //目标center点
    CGPoint finishPoint = CGPointMake(self.originalPoint.x+distanceX, self.originalPoint.y+distanceY);
    
    CGFloat vel = sqrtf(pow(velocity.x, 2) + pow(velocity.y, 2));
    CGFloat displace = sqrtf(pow(distanceX - xFromCenter, 2) + pow(distanceY - yFromCenter, 2));
    
    CGFloat duration = fabs(displace/vel);
    if (duration>0.6) {
        duration = 0.6;
    }else if(duration < 0.3) {
        duration = 0.3;
    }
    UIImageView *imageView = [self getImageViewWithView:self];

    if ([self.delegate respondsToSelector:@selector(adjustOtherCards)]) {
        [self.delegate adjustOtherCards];
    }
    if ([self.delegate respondsToSelector:@selector(swipCard:Direction:)]) {
        [self.delegate swipCard:self Direction:NO];
    }
    if ([self.delegate respondsToSelector:@selector(leftAnimateView:cardItemView:duration:finishPoint:)]) {
        [self.delegate leftAnimateView:imageView cardItemView:self duration:duration finishPoint:finishPoint];
    }
  
}

#pragma mark ->获取屏幕截图
- (UIImageView *)getImageViewWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:image];
    tmpImageView.center = view.center;
    tmpImageView.contentMode = UIViewContentModeScaleToFill;
    tmpImageView.layer.transform = view.layer.presentationLayer.transform;
    [self.superview addSubview:tmpImageView];
    return tmpImageView;
}
@end
