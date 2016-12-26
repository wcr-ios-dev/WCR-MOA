//
//  LoginVC.m
//  WCR-MOA
//
//  Created by wcr－dev on 2016/12/14.
//  Copyright © 2016年 Alijoin. All rights reserved.
//

#import "LoginVC.h"
#import "LoginView.h"
#import "LoginModel.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //登陆的View
    LoginView * loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    LoginModel * model = [[LoginModel alloc] init];
    loginView.model = model;
    
    [self.view addSubview:loginView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
