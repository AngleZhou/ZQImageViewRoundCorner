//
//  UIImage+RoundImage.m
//  ZQImageViewRoundCorner
//
//  Created by Zhou Qian on 16/9/29.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import "UIImage+RoundImage.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+CropTransparancy.h"



@implementation UIImage (RoundImage)

- (UIImage *)roundImageWithSize:(CGSize)size {
    return [self roundImageWithSize:size radius:size.width/2];
}

- (UIImage *)roundImageWithSize:(CGSize)size radius:(CGFloat)radius {
    if (self == nil) {
        return nil;
    }
    CGFloat w = size.width;
    CGFloat h = size.height;
    CGFloat widthImg = self.size.width;
    CGFloat heightImg = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize outSize;
    //按比例缩小的size
    
    if (widthImg < heightImg) {
        outSize = CGSizeMake(w * scale, heightImg * w/widthImg * scale);
    }
    else {
        outSize = CGSizeMake(widthImg * h/heightImg * scale, h * scale);
    }
    
    CGFloat diameter = MIN(outSize.width, outSize.height);
    CGRect rect = CGRectMake((outSize.width-diameter)/2, (outSize.height-diameter)/2, diameter, diameter);
    
    CGContextRef context = [UIImage createARGBBitmapContextFromImage:self.CGImage size:outSize];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius*scale];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, outSize.width, outSize.height), self.CGImage);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CGImageRef cropImage = CGImageCreateWithImageInRect(cgImage, rect);
    UIImage *result = [UIImage imageWithCGImage:cropImage];
    
    CGContextRelease(context);
    CGImageRelease(cgImage);
    CGImageRelease(cropImage);
    
    
    return result;
}

- (UIImage *)UIKitRoundImageWithSize:(CGSize)size {
    if (self == nil) {
        return nil;
    }
    CGFloat w = size.width;
    CGFloat h = size.height;
    CGFloat widthImg = self.size.width;
    CGFloat heightImg = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat radius = size.width/2;
    
    CGSize outSize;
    //按比例缩小的size
    
    if (widthImg < heightImg) {
        outSize = CGSizeMake(w, heightImg * w/widthImg);
    }
    else {
        outSize = CGSizeMake(widthImg * h/heightImg, h);
    }
    
    CGFloat diameter = MIN(outSize.width, outSize.height);
    CGRect rectMask = CGRectMake((outSize.width-diameter)/2, (outSize.height-diameter)/2, diameter, diameter);
    
    
    UIGraphicsBeginImageContextWithOptions(outSize, NO, 0.0);
    UIBezierPath *outterPath = [UIBezierPath bezierPathWithRoundedRect:rectMask cornerRadius:radius];
    [outterPath addClip];
    [self drawInRect:CGRectMake(0, 0, outSize.width, outSize.height)];
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = CGImageCreateWithImageInRect(getImage.CGImage, CGRectMake(rectMask.origin.x*scale, rectMask.origin.y*scale, diameter*scale, diameter*scale));
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    
    
    CGImageRelease(imageRef);
    return img;
}


@end
