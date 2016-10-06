//
//  ZQTestTVC.h
//  ZQImageViewRoundCorner
//
//  Created by Zhou Qian on 16/10/1.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RenderType) {
    RenderTypeUIImageUIKit,
    RenderTypeUIImageCG,
    RenderTypeUIImageViewUIKit,
    RenderTypeUIImageViewCG,
    RenderTypeCornerRadius
};
@interface ZQTestTVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) RenderType type;
@end
