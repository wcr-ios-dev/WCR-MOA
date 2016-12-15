//
//  LoginView.m
//  WCR-MOA
//
//  Created by wcr－dev on 2016/12/14.
//  Copyright © 2016年 Alijoin. All rights reserved.
//

#import "LoginView.h"
@interface LoginView ()
@property (strong,nonatomic) UIImageView * logoImageView;
@property (strong,nonatomic) UITextField * companyTF;
@property (strong,nonatomic) UITextField * userNameTF;
@property (strong,nonatomic) UITextField * psdTF;
@property (strong,nonatomic) UIButton * LoginBtn;
@property (strong,nonatomic) UIButton * ServerHostBtn;
@end
@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self creatView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * leftConstraint = [NSLayoutConstraint
                                           constraintWithItem:self.logoImageView
                                           attribute:NSLayoutAttributeLeft
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                           attribute:NSLayoutAttributeLeft
                                           multiplier:1.0
                                           constant:100];
    [self addConstraint:leftConstraint];
    
}
- (void)creatView{
    self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
    
    [self addSubview:self.logoImageView];
}

@end
