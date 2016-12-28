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


#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define  PROGREESS_WIDTH 40 //圆直径
#define PROGRESS_LINE_WIDTH 4 //弧线的宽度


@interface LoginVC ()
@property (assign,nonatomic) BOOL  isSmall;//按钮是大是小?
@property (strong,nonatomic) UIButton * loginBtn;//指向登陆按钮

//CALayer
@property (strong,nonatomic) CALayer *customerlayer;
@property (strong,nonatomic) CABasicAnimation * scaleAnim;
@property (strong,nonatomic) CABasicAnimation * rotationAnim;
@property (strong,nonatomic) CAShapeLayer * trackLayer;
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
    //登陆按钮点击事件
    self.loginBtn = loginView.LoginBtn;
    [self.loginBtn addTarget:self action:@selector(LoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.isSmall = NO;
    
    
}
//登陆按钮点击事件
- (void)LoginBtn:(UIButton *)btn{
    if (self.isSmall == NO) {
        self.isSmall = YES;
        [self request];
        
    }else if(self.isSmall == YES){
        self.isSmall = NO;
    }
    [self baseAnimation:self.loginBtn];
}
#pragma mark - 登陆按钮缩放动画 -
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
        [self bigLoginBtn];
    }else if(self.isSmall == YES){
        [self smallLoginBtn];
    }
    self.scaleAnim.duration = 0.5;
    
    //添加动画
    [btn.layer addAnimation:self.scaleAnim forKey:nil];
}

#pragma mark - 画圆和动画 -
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
#pragma mark  - 网络请求 -
- (void)request{
    NSDictionary * dict = @{@"company":@"ioaforce",@"username":@"wucr",@"password":@"12345"};
    NSArray * arr = @[@"company",@"username",@"password"];
    
    [[CRNetTool sharedInstance] Post:LoginReqUrl dict:dict paramesArr:arr actionId:nil success:^(id data) {
       
        
        [self bigLoginBtn];
    } fail:^(NSError *error) {
        [self bigLoginBtn];
    }];
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

#pragma mark - 其他的一些处理 -
//放大按钮
- (void)bigLoginBtn{
    self.scaleAnim.toValue = [NSValue valueWithCGRect:CGRectMake(self.loginBtn.bounds.origin.x, self.loginBtn.bounds.origin.y, 200, 45)];
    [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginBtn.layer addAnimation:self.scaleAnim forKey:nil];
    self.isSmall = NO;
    [_trackLayer removeAllAnimations];
    [_trackLayer removeFromSuperlayer];
}
- (void)smallLoginBtn{
    self.scaleAnim.toValue = [NSValue valueWithCGRect:CGRectMake(self.loginBtn.bounds.origin.x, self.loginBtn.bounds.origin.y, 50, 50)];
    [self.loginBtn setTitle:@"" forState:UIControlStateNormal];
    //延迟0.5秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setUpCir:self.loginBtn];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
