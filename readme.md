# 高效地给图片加圆角

标签（空格分隔）： iOS

---

---
layout: post
title: "高效地给图片加圆角"
date: 2016-10-04 12:35:48 +0800
comments: true
categories: 
---
最近研究了一下如何高效地给图片加圆角这个问题，总结一下常用的三种方法：

####1.setCornerRadius && maskToBounds
最简单直接，不考虑性能或者圆角较少的时候使用。如果只用setCornerRadius，不会引起离屏渲染（引起离屏渲染的是setCornerRadius **+** maskToBounds），所以不会影响性能。
####2.UIKit绘制圆角
>UIGraphicsBeginImageContextWithOptions & UIImage -drawInRect:

此方法提高性能的原理是自己实现离屏渲染，放在后台线程运行，从而提高CPU利用率防止主线程阻塞。
可以给UIImageView或者Image加一个category，直接绘制一个圆形的图片。

```
UIGraphicsBeginImageContextWithOptions(size, NO, scale);
UIBezierPath *outterPath = [UIBezierPath bezierPathWithRoundedRect:rectMask cornerRadius:radius];
[outterPath addClip];
[originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();
CGImageRef imageRef = CGImageCreateWithImageInRect(getImage.CGImage, CGRectMake(rectMask.origin.x, rectMask.origin.y, radius*scale, radius*scale));
UIImage *img = [UIImage imageWithCGImage:imageRef];
```

>1: 先创建一个临时的指定size的context.
2~6: 添加圆形的UIBezierPath，剪切，再将图片绘制到context中，会得到一个内容为圆形的矩形图片。(这里可以直接创建正方形的context，从context创建的图片为一个四角透明的正方形图片直接使用，但是图片可能产生形变，类似ScaleToFill的效果，不是图片本身的宽高比压缩所以会形变)
7~8: (可以创建一个按比例缩小的context，然后绘制)再把context创建的图片从```CGImageCreateWithImageInRect```剪裁成正方形，类似AspectToFill的效果，图片没有形变但不能完整显示，边缘部分会被剪掉。

####3.Core Graphics绘制圆角: CGBitmapContextCreate & CGContextDrawImage
思路跟方法2相同，只是创建context及绘制用的是CoreGraphics API。

```
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
    UIBezierPath *outterPath = [UIBezierPath bezierPathWithRoundedRect:rectMask 	cornerRadius:radius];
	[outterPath addClip];
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius*scale];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, outSize.width, outSize.height), self.CGImage);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
```





