//
//  BaseNav.m
//  WCR-MOA
//
//  Created by wcr－dev on 2016/12/14.
//  Copyright © 2016年 Alijoin. All rights reserved.
//

#import "BaseNav.h"

@interface BaseNav ()

@end

@implementation BaseNav

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;//视图全屏延伸,设置子视图从导航栏下方开始计算起点
    self.extendedLayoutIncludesOpaqueBars =YES;//设置导航栏的透明,NO为不透明
    self.automaticallyAdjustsScrollViewInsets =NO;// 设置滚动视图不偏移
    self.navigationBar.translucent = NO;//设置左边零点从(0.64)开始,与上面的透明有关系
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //push的时候隐藏tabar
    if (![viewController isKindOfClass:[UITabBarController class]]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
