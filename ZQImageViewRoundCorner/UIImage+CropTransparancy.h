//
//  UIImage+CropTransparancy.h
//  ZQImageViewRoundCorner
//
//  Created by Zhou Qian on 16/9/30.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CropTransparancy)

- (UIImage *)cropTransparancy;
+ (CGRect)cropRectForImage:(UIImage *)image;
+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage;
+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage size:(CGSize)size;
+ (CGImageRef)scaledImage:(CGImageRef)inImage size:(CGSize)size;

@end
