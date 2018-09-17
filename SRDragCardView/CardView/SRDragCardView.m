//
//  SRDragCardView.m
//  MyTestDemo
//
//  Created by Honey on 2018/8/8.
//  Copyright © 2018年 Honey. All rights reserved.
//

#import "SRDragCardView.h"
#import "SRDragCardItemView.h"

@interface SRDragCardView()<SRDragCardItemDelegate>
@property (strong, nonatomic) NSMutableArray *allCards;
@property (assign, nonatomic) CGPoint lastCardCenter;
@property (assign, nonatomic) CGAffineTransform lastCardTransform;
@property (assign, nonatomic) NSInteger sourceCount;

@property (assign, nonatomic) NSInteger page;
//当前浏览的下标
@property (assign, nonatomic) NSInteger index;

@end

@implementation SRDragCardView
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.allCards = [@[] mutableCopy];
        self.sourceCount = 0;
        self.page = 0;
        self.cardNum = CARD_NUM;
        self.minInfoNum = MIN_INFO_NUM;
        self.index = 0;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allCards = [@[] mutableCopy];
        self.sourceCount = 0;
        self.page = 0;
        self.cardNum = CARD_NUM;
        self.minInfoNum = MIN_INFO_NUM;
        self.index = 0;
    }
    return self;
}
#pragma mark - 请求数据
-(void)requestSourceData:(BOOL)needLoad{
    //获取新数据
    !self.requestSourceData?:self.requestSourceData(needLoad);
}
#pragma mark ->reloadData
- (void)reloadData{
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInCardView:)]) {
        self.sourceCount = [self.dataSource numberOfItemsInCardView:self];
    }
    BOOL isAnimation = NO;
    if ([self.delegate respondsToSelector:@selector(reloadDataNeedAnimationCardView:)]) {
        isAnimation = [self.delegate reloadDataNeedAnimationCardView:self];
    }
    if (self.sourceCount<=self.index) {
        self.index = 0;
    }
    if (self.allCards.count<1) {
        [self addCards];
    }
    if (isAnimation) {
        [self loadAllCards];
    }else{
        for (int i=0; i<self.allCards.count; i++) {
            SRDragCardItemView *draggableView=self.allCards[i];
            if (self.sourceCount > self.index+i) {
                if ([self.dataSource respondsToSelector:@selector(cardView:itemView:index:)]) {
                    [self.dataSource cardView:self itemView:draggableView index:self.index+i];
                }
                draggableView.hidden=NO;
            }else{
                draggableView.hidden=YES;//如果没有数据则隐藏卡片
            }
            //如果没有动画效果的首次加载需要将卡片视图归位,默认在屏幕右边 CGAffineTransformMakeRotation(-ROTATION_ANGLE) 位置
            CGPoint finishPoint = CGPointMake(self.center.x, self.itemSize.height/2 + self.itemTop);
            draggableView.center = finishPoint;
            draggableView.transform = CGAffineTransformMakeRotation(0);
            draggableView.alpha = 1;
            if (i>0&&i<self.cardNum-1) {
                SRDragCardItemView *preDraggableView=[self.allCards objectAtIndex:i-1];
                draggableView.transform=CGAffineTransformScale(draggableView.transform, pow(CARD_SCALE, i), pow(CARD_SCALE, i));
                CGRect frame=draggableView.frame;
                frame.origin.y=preDraggableView.frame.origin.y+(preDraggableView.frame.size.height-frame.size.height)+10*pow(0.7,i);
                draggableView.frame=frame;
            }else if (i==self.cardNum-1) {
                SRDragCardItemView *preDraggableView=[self.allCards objectAtIndex:i-1];
                draggableView.transform=preDraggableView.transform;
                draggableView.frame=preDraggableView.frame;
            }
            if (i == 0) {
                draggableView.alpha = 1;
            }else if (i == 1){
                draggableView.alpha = 0.6;
            }else if (i == 2){
                draggableView.alpha = 0.3;
            }else if (i == 3){
                draggableView.alpha = 0.0;
            }
            draggableView.originalCenter=draggableView.center;
            draggableView.originalTransform=draggableView.transform;
            
            if (i==self.cardNum-1) {
                self.lastCardCenter=draggableView.center;
                self.lastCardTransform=draggableView.transform;
            }
        }
    }
}

#pragma mark - 重新加载卡片
-(void)loadAllCards{
    for (int i=0; i<self.allCards.count; i++) {
        SRDragCardItemView *draggableView=self.allCards[i];
        if (self.sourceCount > self.index+i) {
            if ([self.dataSource respondsToSelector:@selector(cardView:itemView:index:)]) {
                [self.dataSource cardView:self itemView:draggableView index:self.index+i];
            }
            draggableView.hidden=NO;
        }else{
            draggableView.hidden=YES;//如果没有数据则隐藏卡片
        }
    }
    
    for (int i=0; i<_allCards.count ;i++) {
        
        SRDragCardItemView *draggableView=self.allCards[i];
        
        CGPoint finishPoint = CGPointMake(self.center.x, self.itemSize.height/2 + self.itemTop);
        
        [UIView animateKeyframesWithDuration:0.5 delay:0.06*i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            draggableView.center = finishPoint;
            draggableView.transform = CGAffineTransformMakeRotation(0);
            draggableView.alpha = 1;
            if (i>0&&i<self.cardNum-1) {
                SRDragCardItemView *preDraggableView=[self.allCards objectAtIndex:i-1];
                draggableView.transform=CGAffineTransformScale(draggableView.transform, pow(CARD_SCALE, i), pow(CARD_SCALE, i));
                CGRect frame=draggableView.frame;
                frame.origin.y=preDraggableView.frame.origin.y+(preDraggableView.frame.size.height-frame.size.height)+10*pow(0.7,i);
                draggableView.frame=frame;
            }else if (i==self.cardNum-1) {
                SRDragCardItemView *preDraggableView=[self.allCards objectAtIndex:i-1];
                draggableView.transform=preDraggableView.transform;
                draggableView.frame=preDraggableView.frame;
            }
        } completion:^(BOOL finished) {

        }];
        if (i == 0) {
            draggableView.alpha = 1;
        }else if (i == 1){
            draggableView.alpha = 0.6;
        }else if (i == 2){
            draggableView.alpha = 0.3;
        }else if (i == 3){
            draggableView.alpha = 0.0;
        }
        draggableView.originalCenter=draggableView.center;
        draggableView.originalTransform=draggableView.transform;
        
        if (i==self.cardNum-1) {
            self.lastCardCenter=draggableView.center;
            self.lastCardTransform=draggableView.transform;
        }
    }
}

#pragma mark - 刷新所有卡片
-(void)refreshAllCards{
    self.page = 0;
    self.index = 0;
    NSTimeInterval duration = 0.4;
    NSTimeInterval delay = 0.06;
    if (self.sourceCount<1) {
        duration = 0.1;
    }
    self.sourceCount=0;
    
    for (int i=0; i<_allCards.count ;i++) {
        
        SRDragCardItemView *card=self.allCards[i];
        
        CGPoint finishPoint = CGPointMake(-self.itemSize.width, 2*PAN_DISTANCE+card.frame.origin.y);
        
        [UIView animateKeyframesWithDuration:duration delay:delay*i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            card.center = finishPoint;
            card.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
            
        } completion:^(BOOL finished) {
            
            card.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
            card.hidden=YES;
            card.center=CGPointMake([[UIScreen mainScreen]bounds].size.width+self.itemSize.width, self.center.y);
            
            if (i==self.allCards.count-1) {
                [self requestSourceData:YES];
            }
        }];
    }
}

-(void)rightAnimateView:(UIView *)animateView cardItemView:(SRDragCardItemView *)cardItemViews duration:(NSTimeInterval)duration finishPoint:(CGPoint)finishPoint{
    [UIView animateWithDuration:duration
                     animations:^{
                         animateView.center = finishPoint;
                         animateView.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
                     }completion:^(BOOL complete){
                         [animateView removeFromSuperview];
                     }];
    
}

-(void)leftAnimateView:(UIView *)animateView cardItemView:(SRDragCardItemView *)cardItemViews duration:(NSTimeInterval)duration finishPoint:(CGPoint)finishPoint{
    [UIView animateWithDuration:duration
                     animations:^{
                         animateView.center = finishPoint;
                         animateView.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
                     } completion:^(BOOL finished) {
                         [animateView removeFromSuperview];
                     }];
}

#pragma mark - 首次添加卡片
-(void)addCards{
    if ([self.delegate respondsToSelector:@selector(cardViewItemSize:)]) {
        self.itemSize = [self.delegate cardViewItemSize:self];
    }
    if (CGSizeEqualToSize(self.itemSize, CGSizeZero)) {
        MYLog(@"self.itemSize 不能为空 应该通过代理或者属性设置值");
    }
    for (int i = 0; i<self.cardNum; i++) {
        
        SRDragCardItemView *draggableView = [self getCardItemView];
        draggableView.cornerRadius = self.itemCornerRadius;
        if (i>0&&i<self.cardNum-1) {
            draggableView.transform=CGAffineTransformScale(draggableView.transform, pow(CARD_SCALE, i), pow(CARD_SCALE, i));
        }else if(i==self.cardNum-1){
            draggableView.transform=CGAffineTransformScale(draggableView.transform, pow(CARD_SCALE, i-1), pow(CARD_SCALE, i-1));
        }
        draggableView.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
        draggableView.delegate = self;
        
        [_allCards addObject:draggableView];
        if (i==0) {
            draggableView.canPan=YES;
        }else{
            draggableView.canPan=YES;
        }
        if (i == 0) {
            draggableView.alpha = 1;
        }else if (i == 1){
            draggableView.alpha = 0.6;
        }else if (i == 2){
            draggableView.alpha = 0.3;
        }else if (i == 3){
            draggableView.alpha = 0.0;
        }
    }
    
    for (int i=(int)self.cardNum-1; i>=0; i--){
        [self addSubview:_allCards[i]];
    }
}
- (void)cardItemDidSelected:(SRDragCardItemView *)cardView{
    if ([self.delegate respondsToSelector:@selector(cardItemDidSelected:itemView:index:)]) {
        [self.delegate cardItemDidSelected:self itemView:cardView index:self.index];
    }
}

- (SRDragCardItemView *)getCardItemView{
    if ([self.dataSource respondsToSelector:@selector(specifiedCardItemViewClass)]) {
        return [[[self.dataSource specifiedCardItemViewClass] alloc] initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width+self.itemSize.width, self.center.y-self.itemSize.height/2, self.itemSize.width, self.itemSize.height)];
    }
    return [[SRDragCardItemView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width+self.itemSize.width, self.center.y-self.itemSize.height/2, self.itemSize.width, self.itemSize.height)];
}
#pragma mark - 滑动后续操作
-(void)swipCard:(SRDragCardItemView *)cardView Direction:(BOOL)isRight {
    self.index ++;
    [_allCards removeObject:cardView];
    cardView.transform = self.lastCardTransform;
    cardView.center = self.lastCardCenter;
    cardView.canPan=YES;
    [self insertSubview:cardView belowSubview:[self.allCards lastObject]];
    [_allCards addObject:cardView];
    
    if (self.sourceCount > (self.index + self.cardNum - 1)) {
        if ([self.dataSource respondsToSelector:@selector(cardView:itemView:index:)]) {
            [self.dataSource cardView:self itemView:cardView index:self.index + self.cardNum - 1];
        }
        cardView.alpha = 0.3;
        if (self.allCards.count - self.index < MIN_INFO_NUM) {
            //TODO:当数量小于某一个值时需要预加载数据去掉动画效果让用户无感知.
            [self requestSourceData:NO];
        }
    }else{
        cardView.hidden=YES;//如果没有数据则隐藏卡片
    }
    
    for (int i = 0; i<self.cardNum; i++) {
        SRDragCardItemView*draggableView=[_allCards objectAtIndex:i];
        draggableView.originalCenter=draggableView.center;
        draggableView.originalTransform=draggableView.transform;
        if (i==0) {
            draggableView.canPan=YES;
        }
    }
    //NSLog(@"%d",_sourceObject.count);
    MYLog(@"%ld",self.index);
}

#pragma mark - 滑动中更改其他卡片位置
-(void)moveCards:(CGFloat)distance{
    
    if (fabs(distance)<=PAN_DISTANCE) {
        for (int i = 1; i<self.cardNum-1; i++) {
            SRDragCardItemView *draggableView=_allCards[i];
            SRDragCardItemView *preDraggableView=[_allCards objectAtIndex:i-1];
            draggableView.transform=CGAffineTransformScale(draggableView.originalTransform, 1+(1/CARD_SCALE-1)*fabs(distance/PAN_DISTANCE)*0.6, 1+(1/CARD_SCALE-1)*fabs(distance/PAN_DISTANCE)*0.6);//0.6为缩减因数，使放大速度始终小于卡片移动速度
            
            CGPoint center=draggableView.center;
            center.y=draggableView.originalCenter.y-(draggableView.originalCenter.y-preDraggableView.originalCenter.y)*fabs(distance/PAN_DISTANCE)*0.6;//此处的0.6同上
            draggableView.center=center;
            
            if (i == 1) {
                draggableView.alpha = 1;
            }else if (i == 2){
                draggableView.alpha = 0.6;
            }else if (i == 3){
                draggableView.alpha = 0.3;
            }else if (i == 4){
                draggableView.alpha = 0.0;
            }
        }
    }
}

#pragma mark - 滑动终止后复原其他卡片
-(void)moveBackCards{
    for (int i = 0; i<self.cardNum; i++) {
        SRDragCardItemView *draggableView=_allCards[i];
        [UIView animateWithDuration:RESET_ANIMATION_TIME
                         animations:^{
                             draggableView.transform=draggableView.originalTransform;
                             draggableView.center=draggableView.originalCenter;
                             if (i == 0) {
                                 draggableView.alpha = 1;
                             }else if (i == 1){
                                 draggableView.alpha = 0.6;
                             }else if (i == 2){
                                 draggableView.alpha = 0.3;
                             }else if (i == 3){
                                 draggableView.alpha = 0.0;
                             }
                         }];
    }
}

#pragma mark - 滑动后调整其他卡片位置
-(void)adjustOtherCards{
    
    [UIView animateWithDuration:0.05
                     animations:^{
                         for (int i = 1; i<self.cardNum-1; i++) {
                             SRDragCardItemView *draggableView=self.allCards[i];
                             SRDragCardItemView *preDraggableView=[self.allCards objectAtIndex:i-1];
                             draggableView.transform=preDraggableView.originalTransform;
                             draggableView.center=preDraggableView.originalCenter;
                             if (i == 1) {
                                 draggableView.alpha = 1;
                             }else if (i == 2){
                                 draggableView.alpha = 0.6;
                             }else if (i == 3){
                                 draggableView.alpha = 0.3;
                             }else if (i == 4){
                                 draggableView.alpha = 0.0;
                             }
                         }
                     }completion:^(BOOL complete){
                         //当将最后一张图片滑动滑动隐藏后应该重新加载视图
                         BOOL isLoad = YES;
                         if (self.allCards.count>1) {
                             SRDragCardItemView *preDraggableView  = self.allCards[0];
                             if (preDraggableView.isHidden == NO) {
                                 isLoad = NO;
                             }
                         }
                         if (isLoad) {
                             [self refreshAllCards];
                         }
                     }];
    
}

@end
