//
//  JLKeyboardView.m
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import "JLKeyboardView.h"
#import <Masonry/Masonry.h>
#import "TBCDefines.h"
#define btnHeight 50
#define btnWidth (kmainScreenW - 20) / 10

@interface JLKeyboardView ()

@property (nonatomic, strong) NSArray *array1;
@property (nonatomic, strong) NSArray *array2;
@property (nonatomic, strong) NSArray *array3;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation JLKeyboardView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.array1 = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P"];
        self.array2 = @[@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L"];
        self.array3 = @[@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
        [self initView];
    }
    return self;
}

- (void)initView{
    for (int i = 0; i < self.array1.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setTitle:self.array1[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:25];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(btnWidth * i);
            make.width.offset(btnWidth);
            make.height.offset(btnHeight);
            make.top.mas_equalTo(self).offset(10);;
        }];
    }
    for (int i = 0; i < self.array2.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setTitle:self.array2[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:25];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(btnWidth * i);
            make.width.offset(btnWidth);
            make.height.offset(btnHeight);
            make.top.mas_equalTo(self).offset(btnHeight + 20);
        }];
    }
    
    
    for (int i = 0; i < self.array3.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setTitle:self.array3[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:25];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(btnWidth * i);
            make.width.offset(btnWidth);
            make.height.offset(btnHeight);
            make.top.mas_equalTo(self).offset(10 + (btnHeight + 10) * 2);
        }];
    }
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.width.offset(50);
        make.height.offset(btnHeight);
        make.top.mas_equalTo(self).offset(btnHeight + 20);
    }];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.sureBtn];
    [self addSubview:self.deleteBtn];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.width.offset(60);
        make.height.offset(btnHeight);
        make.top.mas_equalTo(self).offset(10 + (btnHeight + 10) * 2);
    }];
}

- (void)btnClicked:(UIButton *)sender{
    if (self.block) {
        self.block(sender.titleLabel.text);
    }
}

- (void)deleteBtnClicked{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)sureBtnClicked{
    if (self.sureBlock) {
        self.sureBlock();
    }
}
@end
