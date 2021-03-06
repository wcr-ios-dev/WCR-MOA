//
//  LoginView.m
//  WCR-MOA
//
//  Created by wcr－dev on 2016/12/14.
//  Copyright © 2016年 Alijoin. All rights reserved.
//

#import "LoginView.h"
#import "UIView+SDAutoLayout.h"
#import "LoginModel.h"




@interface LoginView ()<UITextFieldDelegate>
@property (strong,nonatomic) UIImageView * logoImageView;
@property (strong,nonatomic) UITextField * companyTF;
@property (strong,nonatomic) UITextField * userNameTF;
@property (strong,nonatomic) UITextField * psdTF;

@property (strong,nonatomic) UIButton * ServerHostBtn;

//保存公司 ,用户名,密码
@property (strong,nonatomic) NSString * companyStr;
@property (strong,nonatomic) NSString * userNameStr;
@property (strong,nonatomic) NSString * psdStr;






@end
@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self creatView];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTime:) name:@"requestTime" object:nil];
    
    
    return self;
}
////通知方法
//- (void)requestTime:(NSNotification *)notification{
//    MOALog(@"----------网络请求结束");
//}

// 创建view
- (void)creatView{
    //logo imageView
    self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
    
    self.logoImageView.layer.masksToBounds = NO;//超出就剪掉
    self.logoImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.logoImageView.layer.shadowOffset = CGSizeMake(1, 2);
    self.logoImageView.layer.shadowOpacity = 0.3;
    
   
    
    //公司名
    self.companyTF = [[UITextField alloc] init];
    [self setTextField:self.companyTF plachHoldText:@"服务器地址"];
    [self.companyTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    //用户名
    self.userNameTF = [[UITextField alloc] init];
    [self setTextField:self.userNameTF plachHoldText:@"用户名"];
    [self.companyTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    //密码
    self.psdTF = [[UITextField alloc] init];
    [self setTextField:self.psdTF plachHoldText:@"密码"];
    [self.companyTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    //登陆按钮
    self.LoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
    self.LoginBtn.center = CGPointMake(MainScreenWidth/2, 364);
    self.LoginBtn.backgroundColor = MOAColorFromRGB(0x3da1cd);
    [self.LoginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [self.LoginBtn setTintColor:[UIColor whiteColor]];
    self.LoginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    self.LoginBtn.layer.cornerRadius = 8.0;


    //添加到视图
    [self addSubview:self.logoImageView];
    [self addSubview:self.companyTF];
    [self addSubview:self.userNameTF];
    [self addSubview:self.psdTF];
    [self addSubview:self.LoginBtn];
    
    
    //添加约束
    [self addAutoLayout];
}


#pragma mark - textfield Delegate -
//文字发送改变
- (void)textFieldTextDidChange:(UITextField *)textField{
    if (textField == self.companyTF) {
        self.companyStr = textField.text;
    }else if(textField == self.userNameTF){
        self.userNameStr = textField.text;
    }else if (textField == self.psdTF){
        self.psdStr = textField.text;
    }
}
//开始输入
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.masksToBounds = NO;//超出就剪掉
    textField.layer.shadowColor = [UIColor blackColor].CGColor;
    textField.layer.shadowOffset = CGSizeMake(2, 3);
    textField.layer.shadowOpacity = 0.3;
}
//结束输入
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.layer.masksToBounds = NO;//超出就剪掉
    textField.layer.shadowColor = [UIColor whiteColor].CGColor;
    textField.layer.shadowOffset = CGSizeMake(0, 0);
    textField.layer.shadowOpacity = 0;
    
    return YES;
}
//点击return建取消键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
#pragma mark - 模型 -
- (void)setModel:(LoginModel *)model{
    _model = model;
        self.companyTF.text = model.company;
        self.userNameTF.text = model.userName;
        self.psdTF.text = model.psd;

}
- (void)addAutoLayout{
    //logo
    self.logoImageView.autoresizingMask  = NO;
    self.logoImageView.sd_layout.topSpaceToView(self,100);
    self.logoImageView.sd_layout.centerXEqualToView(self);
    self.logoImageView.sd_layout.heightIs(56);
    //公司名输入框
    self.companyTF.autoresizingMask = NO;
    self.companyTF.sd_layout.topSpaceToView(self.logoImageView,30);
    self.companyTF.sd_layout.centerXEqualToView(self);
    self.companyTF.sd_layout.heightIs(40);
    self.companyTF.sd_layout.widthIs(250);
    //用户名
    self.userNameTF.autoresizingMask = NO;
    self.userNameTF.sd_layout.topSpaceToView(self.companyTF,10);
    self.userNameTF.sd_layout.centerXEqualToView(self);
    self.userNameTF.sd_layout.heightIs(40);
    self.userNameTF.sd_layout.widthIs(250);
    //密码
    self.psdTF.autoresizingMask = NO;
    self.psdTF.sd_layout.topSpaceToView(self.userNameTF,10);
    self.psdTF.sd_layout.centerXEqualToView(self);
    self.psdTF.sd_layout.heightIs(40);
    self.psdTF.sd_layout.widthIs(250);
}
- (void)setTextField:(UITextField *)textField plachHoldText:(NSString *)text{
    textField.delegate = self;
    textField.layer.borderWidth = 2;
    textField.layer.borderColor = MOAColorFromRGB(0x3da1cd).CGColor;
    textField.layer.cornerRadius = 8.0;
    textField.placeholder = text;
    //自定义站位字的颜色
    [textField setValue:MOAColorFromRGB(0x8fc4df) forKeyPath:@"_placeholderLabel.textColor"];
    //左内边距
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}


@end
