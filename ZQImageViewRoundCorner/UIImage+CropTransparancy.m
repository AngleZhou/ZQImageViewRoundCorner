//
//  UIImage+CropTransparancy.m
//  ZQImageViewRoundCorner
//
//  Created by Zhou Qian on 16/9/30.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import "UIImage+CropTransparancy.h"

@implementation UIImage (CropTransparancy)

- (UIImage *)cropTransparancy {
    CGRect newRect = [UIImage cropRectForImage:self];
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, newRect);
    UIImage *imageNew = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return imageNew;
}

//返回一个最大的不透明的rect范围
+ (CGRect)cropRectForImage:(UIImage *)image {
    
    CGImageRef cgImage = image.CGImage;
    CGContextRef context = [UIImage createARGBBitmapContextFromImage:cgImage];
    if (context == NULL) return CGRectZero;
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGContextDrawImage(context, rect, cgImage);

    unsigned char *data = CGBitmapContextGetData(context);
    CGContextRelease(context);
    
    //Filter through data and look for non-transparent pixels.
    NSUInteger lowX = width;
    NSUInteger lowY = height;
    int highX = 0;
    int highY = 0;
    if (data != NULL) {
        for (int y=0; y<height; y++) {
            for (int x=0; x<width; x++) {
                int pixelIndex = (width * y + x) * 4 /* 4 for A, R, G, B */;
                if (data[pixelIndex] != 0) { //Alpha value is not zero; pixel is not transparent.
                    if (x < lowX) lowX = x;
                    if (x > highX) highX = x;
                    if (y < lowY) lowY = y;
                    if (y > highY) highY = y;
                }
            }
        }
        free(data);
    } else {
        return CGRectZero;
    }
    
    return CGRectMake(lowX, lowY, highX-lowX, highY-lowY);
}

+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage size:(CGSize)size {
    size_t bitsPerComponent = CGImageGetBitsPerComponent(inImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(inImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(inImage);
    CGBitmapInfo bitMapInfo = CGImageGetBitmapInfo(inImage);
    
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 size.width,
                                                 size.height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 CGColorSpaceCreateDeviceRGB(),
                                                 kCGImageAlphaPremultipliedFirst);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    return context;
}
+ (CGImageRef)scaledImage:(CGImageRef)inImage size:(CGSize)size {
    CGContextRef context = [UIImage createARGBBitmapContextFromImage:inImage size:size];
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), inImage);
    return CGBitmapContextCreateImage(context);
}

//创建一个参数确定的BitmapContext
+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage {
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    size_t bitmapByteCount;
    size_t bitmapBytesPerRow;
    
    size_t width = CGImageGetWidth(inImage);
    size_t height = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (width * 4);
    bitmapByteCount = (bitmapBytesPerRow * height);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) return NULL;
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     width,
                                     height,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL) free (bitmapData);
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease(colorSpace);
    
    return context;
}
@end
