//
//  ViewController.m
//  SRDragCardView
//
//  Created by Honey on 2018/9/14.
//  Copyright © 2018年 CZN. All rights reserved.
//

#import "ViewController.h"
#import "SRDragCardView.h"
#import "MYCardItemView.h"

@interface ViewController ()<SRDragCardViewDelegate,SRDragCardViewDataSource>
@property (nonatomic,strong)SRDragCardView *dragCardView;
@property (nonatomic,strong)NSMutableArray *dataArray;
//刷新cardView时是否需要动画效果?
@property (nonatomic,assign)BOOL isAnimation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.dragCardView];
    self.dataArray = [@[@1,@1,@1,@1,@1,
                        @1,@1,@1,@1,@1,
                        @1,@1,@1,@1,@1,
                        @1,@1,@1,@1,@1] mutableCopy];
    [self.dragCardView reloadData];
    self.isAnimation = NO;
    UIButton *button = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, CGRectGetMaxY(self.dragCardView.frame)+10, 160, 44);
        button.center = CGPointMake(self.view.center.x, button.center.y);
        [button setTitle:@"重置" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:button];

}
#pragma mark ->btnAction
- (void)btnAction:(id)sender{
    [self.dragCardView refreshAllCards];
}
#pragma mark ->SRDragCardViewDelegate,SRDragCardViewDataSource
- (NSInteger)numberOfItemsInCardView:(SRDragCardView *)cardView{
    return self.dataArray.count;
}
- (void)cardItemDidSelected:(SRDragCardView *)cardView itemView:(SRDragCardItemView *)itemView index:(NSInteger)index{
    //选中
    MYLog(@"selectedIndex:%ld",index);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"点击了:%d",index] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)cardView:(SRDragCardView *)cardView itemView:(MYCardItemView *)itemView index:(NSInteger)index{
//    [itemView bindViewModel:self.dataArray[index]];
    [itemView bindViewModel:@(index)];
}
- (BOOL)reloadDataNeedAnimationCardView:(SRDragCardView *)cardView{
    return self.isAnimation;
}
- (Class)specifiedCardItemViewClass{
    return [MYCardItemView class];
}
#pragma mark ->懒加载
- (SRDragCardView *)dragCardView{
    
    if (nil == _dragCardView) {
        CGSize itemSize = CARD_SIZE(315.0f, 492.0f);
        _dragCardView = [[SRDragCardView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, itemSize.height + 20)];
        _dragCardView.center = self.view.center;
        _dragCardView.delegate = self;
        _dragCardView.dataSource = self;
        _dragCardView.itemSize = itemSize;
        _dragCardView.itemCornerRadius = 8.0f;
        __weak typeof(self) wSelf = self;
        [_dragCardView setRequestSourceData:^(BOOL isAnimation) {
            if (wSelf.dataArray.count<=20) {
                //追加数据不需要动画
                wSelf.isAnimation = isAnimation;
                [wSelf.dataArray addObjectsFromArray:@[@1,@1,@1,@1,@1,
                                                       @1,@1,@1,@1,@1,
                                                       @1,@1,@1,@1]];
            }else{
                //(手动重置或数据全部滑动完成需要重置时)刷新数据需要动画
                wSelf.isAnimation = YES;
            }
            [wSelf.dragCardView reloadData];
        }];
    }
    return _dragCardView;
}


@end
