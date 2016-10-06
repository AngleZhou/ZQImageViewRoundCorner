//
//  UIImage+RoundImage.h
//  ZQImageViewRoundCorner
//
//  Created by Zhou Qian on 16/9/29.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundImage)


- (UIImage *)roundImageWithSize:(CGSize)size;
- (UIImage *)roundImageWithSize:(CGSize)size radius:(CGFloat)radius;
- (UIImage *)UIKitRoundImageWithSize:(CGSize)size;
@end
