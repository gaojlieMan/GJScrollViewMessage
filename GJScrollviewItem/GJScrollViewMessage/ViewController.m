//
//  ViewController.m
//  GJScrollViewMessage
//
//  Created by gaojie on 18/5/7.
//  Copyright © 2018年 iteam. All rights reserved.
//

#import "ViewController.h"

#define kDefaltVectorViewH 44.0
#define kDefaltVectorViewW self.view.bounds.size.width

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollMessageView;
@property (weak, nonatomic) IBOutlet UIView *vectorView;

@property (strong, nonatomic) UIView *containterView;
@property (strong, nonatomic) NSArray *models;
@property (strong, nonatomic) NSString *linkingUrl;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.models = @[@"第一条滚动信息",@"第二条滚动信息",@"第三条滚动信息"];
    self.scrollMessageView.showsHorizontalScrollIndicator = NO;
    self.scrollMessageView.showsVerticalScrollIndicator = NO;
    self.scrollMessageView.bounces = NO;
    self.scrollMessageView.contentOffset = CGPointMake(0, 0);
    self.scrollMessageView.contentSize = CGSizeMake(0, NSNotFound);
    self.scrollMessageView.scrollEnabled = NO;
    self.scrollMessageView.pagingEnabled = YES;
    self.scrollMessageView.autoresizesSubviews = YES;
    self.scrollMessageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.containterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDefaltVectorViewW ,self.models.count * kDefaltVectorViewH)];
    [self.scrollMessageView addSubview:self.containterView];
    [self updateMessageWithGroupRestModels:self.models];
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(scrollNextMessage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
//    [self performSelector:@selector(scrollNextMessage) withObject:self afterDelay:3];
}

#pragma mark - Private method

- (void)updateMessageWithGroupRestModels:(NSArray *)models {
    self.models = models;
    CGFloat buttonX = 0.0;
    CGFloat buttonY = 0.0;
    for (int i = 0;i <models.count;i++) {
        NSString *model = models[i];
        buttonY = i * kDefaltVectorViewH;
        UIButton *messgaeButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonX,buttonY,kDefaltVectorViewW,kDefaltVectorViewH)];
        messgaeButton.tag = i;
        [messgaeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [messgaeButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [messgaeButton addTarget:self action:@selector(userDidClickMessageButton:) forControlEvents:UIControlEventTouchUpInside];
        messgaeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [messgaeButton setTitle:model forState:UIControlStateNormal];
        [self.containterView addSubview:messgaeButton];
    }
}

#pragma mark - ScrollView method

- (void)scrollNextMessage {
    [self performSelector:@selector(scrollNextMessage) withObject:self afterDelay:3];
    float currentOffsetY = self.scrollMessageView.contentOffset.y;
    currentOffsetY += kDefaltVectorViewH;
    NSInteger pageIndex = (currentOffsetY/ (self.models.count * kDefaltVectorViewH));
    if (pageIndex > 0) {
        self.containterView.frame = CGRectMake(0, pageIndex * self.models.count * kDefaltVectorViewH, kDefaltVectorViewH, self.models.count * kDefaltVectorViewH);
    }
    [UIView animateWithDuration:2 animations:^{
        [self.scrollMessageView setContentOffset:CGPointMake(0, currentOffsetY) animated:YES];
    }];
}

#pragma mark - Use actions

- (void)userDidClickMessageButton:(UIButton*)button {
    
    NSLog(@"你点击的是第%ld按钮",(long)button.tag);
    
}

#pragma mark - Destroy timer

// 切记timer 不使用时要销毁 也可以选取 [self performSelector:@selector(scrollNextMessage) withObject:self afterDelay:3]; 这样就避免内存泄漏问题

- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
    
}

@end
