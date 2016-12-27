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


#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define  PROGREESS_WIDTH 40 //圆直径
#define PROGRESS_LINE_WIDTH 4 //弧线的宽度

@interface LoginView ()<UITextFieldDelegate>
@property (strong,nonatomic) UIImageView * logoImageView;
@property (strong,nonatomic) UITextField * companyTF;
@property (strong,nonatomic) UITextField * userNameTF;
@property (strong,nonatomic) UITextField * psdTF;
@property (strong,nonatomic) UIButton * LoginBtn;
@property (strong,nonatomic) UIButton * ServerHostBtn;

//保存公司 ,用户名,密码
@property (strong,nonatomic) NSString * companyStr;
@property (strong,nonatomic) NSString * userNameStr;
@property (strong,nonatomic) NSString * psdStr;


@property (assign,nonatomic) BOOL  isSmall;
//CALayer
@property (strong,nonatomic) CALayer *customerlayer;
@property (strong,nonatomic) CABasicAnimation * scaleAnim;
@property (strong,nonatomic) CABasicAnimation * rotationAnim;
@property (strong,nonatomic) CAShapeLayer * trackLayer;


@end
@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self creatView];
    }
    self.isSmall = NO;
    return self;
}
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
    [self.LoginBtn addTarget:self action:@selector(LoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    //添加到视图
    [self addSubview:self.logoImageView];
    [self addSubview:self.companyTF];
    [self addSubview:self.userNameTF];
    [self addSubview:self.psdTF];
    [self addSubview:self.LoginBtn];
    
    
    //添加约束
    [self addAutoLayout];
}
//登陆按钮点击事件
- (void)LoginBtn:(UIButton *)btn{
    if (self.isSmall == NO) {
        self.isSmall = YES;
        
    }else if(self.isSmall == YES){
        self.isSmall = NO;
       
    }
    [self baseAnimation:self.LoginBtn];
}
#pragma mark - 动画 -
//基础动画
- (void)baseAnimation:(UIButton *)btn{

    
    //设置动画对象
    //动画执行完毕不用删除动画
    self.scaleAnim.removedOnCompletion = NO;
    //保存最新状态
    self.scaleAnim.fillMode = kCAFillModeForwards;

    //keyPath决定了执行怎样的动画. 调整哪个属性来执行
    self.scaleAnim.keyPath = @"bounds";
    //anim.fromValue = ;
    if (self.isSmall == NO) {
        self.scaleAnim.toValue = [NSValue valueWithCGRect:CGRectMake(btn.bounds.origin.x, btn.bounds.origin.y, 200, 45)];
        [self.LoginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        //移除动画
        [_trackLayer removeAllAnimations];
        [_trackLayer removeFromSuperlayer];
        
    }else if(self.isSmall == YES){
        
        self.scaleAnim.toValue = [NSValue valueWithCGRect:CGRectMake(btn.bounds.origin.x, btn.bounds.origin.y, 50, 50)];
        [self.LoginBtn setTitle:@"" forState:UIControlStateNormal];
        //延迟0.5秒
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setUpCir:self.LoginBtn];
        });
        
    }
    self.scaleAnim.duration = 0.5;

    //添加动画
    [btn.layer addAnimation:self.scaleAnim forKey:nil];
}
//真动画
//- (void)KeyFrameAnimation:(UIButton *)btn{
//    CAKeyframeAnimation * keyAnima = [CAKeyframeAnimation animation];
//
//    keyAnima.keyPath = @"position";
//    
//    
//}

- (void)setUpCir:(UIButton *)btn{
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer layer];//创建一个track shape layer
    }
    _trackLayer.bounds = CGRectMake(0, 0, 45, 45);
    _trackLayer.position = CGPointMake(25, 25);
//    [_trackLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [btn.layer addSublayer:_trackLayer];
    
    
    _trackLayer.fillColor = [[UIColor clearColor] CGColor];
    _trackLayer.strokeColor = [[UIColor whiteColor] CGColor];//指定path的渲染颜色
    _trackLayer.opacity = 1;
    _trackLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _trackLayer.lineWidth = PROGRESS_LINE_WIDTH;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:(PROGREESS_WIDTH-PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(0) endAngle:degreesToRadians(360) clockwise:YES];//上面说明过了用来构建圆形
    _trackLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    //处理动画
    self.rotationAnim.removedOnCompletion = NO;
    //保存最新状态
    self.rotationAnim.fillMode = kCAFillModeForwards;
    
    //keyPath决定了执行怎样的动画. 调整哪个属性来执行
    self.rotationAnim.keyPath = @"transform.rotation";
    self.rotationAnim.fromValue = [NSNumber numberWithFloat:0];
    self.rotationAnim.toValue = [NSNumber numberWithFloat:M_PI*2];
    self.rotationAnim.duration = 1;
    
    self.rotationAnim.repeatCount = MAXFLOAT;
    //添加动画
    [_trackLayer addAnimation:self.rotationAnim forKey:nil];
    
    
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

#pragma mark - 懒加载 -
- (CABasicAnimation *)scaleAnim{
    if (!_scaleAnim) {
        _scaleAnim = [CABasicAnimation animation];
    }
    return _scaleAnim;
}
- (CABasicAnimation *)rotationAnim{
    if (!_rotationAnim) {
        _rotationAnim = [CABasicAnimation animation];
    }
    return _rotationAnim;
}
@end
