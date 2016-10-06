//
//  UIImageView+RoundCorner.m
//  ZQImageViewRoundCorner
//
//  Created by Zhou Qian on 16/9/28.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import "UIImageView+RoundCorner.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+CropTransparancy.h"


static UIImage *bgImage;
static NSOperationQueue* processQueue()
{
    static NSOperationQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 5;
    });
    
    return queue;
}

@implementation UIImageView (RoundCorner)


- (void)roundCorner:(UIImage*)image {
    UIImage *imageORIG = image;
    self.backgroundColor = [UIColor whiteColor];
    if (!image && bgImage) {
        self.image = bgImage;
    }
    else {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGFloat radius = MIN(width, height);
        CGFloat scale = [UIScreen mainScreen].scale;
        
        __weak __typeof(self) wSelf = self;
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            if (wSelf == nil) {//如果imageView被释放不存在了，直接返回
                return;
            }
            __strong __typeof(self) sSelf = wSelf;
            CGSize outSize;
            //按比例缩小的size
            if (imageORIG) {
                CGFloat wImg = imageORIG.size.width;
                CGFloat hImg = imageORIG.size.height;
                if (wImg < hImg) {
                    outSize = CGSizeMake(width * scale, hImg * width/wImg * scale);
                }
                else {
                    outSize = CGSizeMake(wImg * height/hImg * scale, height * scale);
                }
            }
            else {
                outSize = wSelf.frame.size;
            }
            
            CGContextRef context = [UIImage createARGBBitmapContextFromImage:image.CGImage size:outSize];
            
            CGRect rectMask = CGRectMake((outSize.width-radius*scale)/2, (outSize.height-radius*scale)/2, radius*scale, radius*scale);
            UIBezierPath *outterPath = [UIBezierPath bezierPathWithRoundedRect:rectMask cornerRadius:radius/2*scale];
            CGContextAddPath(context, outterPath.CGPath);
            CGContextClip(context);
            if (imageORIG) {
                
                CGContextDrawImage(context, CGRectMake(0, 0, outSize.width, outSize.height), image.CGImage);
            }
            else if (!bgImage){
                CGContextSetFillColorWithColor(context, wSelf.backgroundColor.CGColor);
                CGContextFillRect(context, wSelf.bounds);
                bgImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
                wSelf.image = bgImage;
                return;
            }
            
            CGImageRef cgImage = CGBitmapContextCreateImage(context);
            
            //解决图片变形拉伸
            if (imageORIG) {
                CGImageRef imageRef = CGImageCreateWithImageInRect(cgImage, CGRectMake(rectMask.origin.x, rectMask.origin.y, radius*scale, radius*scale));
                UIImage *img = [UIImage imageWithCGImage:imageRef];
                dispatch_async(dispatch_get_main_queue(), ^{
                    sSelf.image = img;
                });
                
                CGImageRelease(imageRef);
            }
            CGImageRelease(cgImage);
            CGContextRelease(context);
        }];
        
        [processQueue() addOperation:operation];
        
    }
    
    
}

- (void)UIKitRoundCorner:(UIImage *)image {
    UIImage *imageORIG = image;
    self.backgroundColor = [UIColor whiteColor];
    if (!image && bgImage) {
        self.image = bgImage;
    }
    else {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGFloat radius = MIN(width, height);
        CGFloat scale = [UIScreen mainScreen].scale;
        
        __weak __typeof(self) wSelf = self;
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            if (wSelf == nil) {//如果imageView被释放不存在了，直接返回
                return;
            }
            __strong __typeof(self) sSelf = wSelf;
            CGSize outSize;
            //按比例缩小的size
            if (imageORIG) {
                CGFloat wImg = imageORIG.size.width;
                CGFloat hImg = imageORIG.size.height;
                if (wImg < hImg) {
                    outSize = CGSizeMake(width, hImg * width/wImg);
                }
                else {
                    outSize = CGSizeMake(wImg * height/hImg, height);
                }
            }
            else {
                outSize = wSelf.frame.size;
            }
            
            UIGraphicsBeginImageContextWithOptions(outSize, NO, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGRect rectMask = CGRectMake((outSize.width-radius)/2, (outSize.height-radius)/2, radius, radius);
            UIBezierPath *outterPath = [UIBezierPath bezierPathWithRoundedRect:rectMask cornerRadius:radius/2];
            [outterPath addClip];
            if (imageORIG) {
                [imageORIG drawInRect:CGRectMake(0, 0, outSize.width, outSize.height)];
            }
            else if (!bgImage){
                CGContextSetFillColorWithColor(context, wSelf.backgroundColor.CGColor);
                CGContextFillRect(context, wSelf.bounds);
                bgImage = UIGraphicsGetImageFromCurrentImageContext();
                wSelf.image = bgImage;
                return;
            }
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            
            //解决图片变形拉伸
            if (imageORIG) {
                CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(rectMask.origin.x*scale, rectMask.origin.y*scale, radius*scale, radius*scale));
                UIImage *img = [UIImage imageWithCGImage:imageRef];
                dispatch_async(dispatch_get_main_queue(), ^{
                    sSelf.image = img;
                });
                
                CGImageRelease(imageRef);
            }
            CGContextRelease(context);
        }];
        
        [processQueue() addOperation:operation];
        
    }
    
    
}


@end
