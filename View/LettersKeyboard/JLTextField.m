//
//  JLTextField.m
//  TabacoKit
//
//  Created by xywy on 2022/7/28.
//

#import "JLTextField.h"
#import "JLKeyboardView.h"
#import "TBCDefines.h"
@interface JLTextField ()

@property (nonatomic, strong) JLKeyboardView *keyboardView;

@end
@implementation JLTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.inputView = self.keyboardView;
        [self reloadInputViews];
    }
    return self;
}




#pragma mark - 懒加载
- (JLKeyboardView *)keyboardView{
    if (!_keyboardView) {
        
        _keyboardView = [[JLKeyboardView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenW, 224)];
        
        kWeakSelf(self)
        
        _keyboardView.block = ^(NSString * _Nonnull str) {
            kStrongSelf(self)
            self.text = [NSString stringWithFormat:@"%@%@",self.text,str];
            if (self.block) {
                self.block();
            }
        };
        
        _keyboardView.deleteBlock = ^{
            kStrongSelf(self)
            if (self.text.length >=1) {
                self.text = [self.text substringToIndex:self.text.length - 1];
                if (self.block) {
                    self.block();
                }
            }
        };
        _keyboardView.sureBlock = ^{
            kStrongSelf(self)
            [self resignFirstResponder];
        };
    }
    return _keyboardView;
}

@end
