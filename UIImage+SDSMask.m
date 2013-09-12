//
//  UIImage+SDSMask.h.m
//
//  Created by sergio on 3/6/12.
//  Copyright 2012 Sergio De Simone, Freescapes Labs. All rights reserved.
//

#import "UIImage+SDSMask.h"
#import "Utilities.h"

@implementation UIImage (SDSEmboss)

#pragma mark masking
/*
/////////////////////////////////////////////////////////////////////////////////////////
+ (CGImageRef)newMaskFromFile:(NSString*)path {
    
    CGDataProviderRef provider = CGDataProviderCreateWithFilename([[[NSBundle mainBundle] pathForResource:path ofType:@"png"] UTF8String]);
    CGImageRef maskRef = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    
    return CGImageMaskCreate(CGImageGetWidth(maskRef),
                             CGImageGetHeight(maskRef),
                             CGImageGetBitsPerComponent(maskRef),
                             CGImageGetBitsPerPixel(maskRef),
                             CGImageGetBytesPerRow(maskRef),
                             CGImageGetDataProvider(maskRef), NULL, false);

    
    //    CGColorSpaceRef maskColorSpace = CGColorSpaceCreateDeviceGray();
    //    CGImageRef mask = CGImageCreateCopyWithColorSpace(tile, maskColorSpace);
    //    CGImageRelease(tile);
    //    CGColorSpaceRelease(maskColorSpace);
    //    return mask;
}
*/

/////////////////////////////////////////////////////////////////////////////////////////
+ (CGImageRef)newMaskFromFile:(NSString*)path {
    
    CGDataProviderRef provider = CGDataProviderCreateWithFilename([[[NSBundle mainBundle] pathForResource:path ofType:@"png"] UTF8String]);
    CGImageRef tile = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRef maskColorSpace = CGColorSpaceCreateDeviceGray();
    CGImageRef mask = CGImageCreateCopyWithColorSpace(tile, maskColorSpace);
    CGImageRelease(tile);
    CGColorSpaceRelease(maskColorSpace);
    return mask;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (CGImageRef)newBlackMaskSized:(float)s {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(s, s), NO, 0.0);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(gc, CGRectMake(0, 0, s, s));
    [[UIColor blackColor] setFill];
    CGContextFillRect(gc, CGRectMake(2, 2, s-4, s-4));
    CGImageRef img = CGBitmapContextCreateImage(gc);
    UIGraphicsEndImageContext();
    
    CGImageRef newImg = CGImageMaskCreate(CGImageGetWidth(img),
                                          CGImageGetHeight(img),
                                          CGImageGetBitsPerComponent(img),
                                          CGImageGetBitsPerPixel(img),
                                          CGImageGetBytesPerRow(img),
                                          CGImageGetDataProvider(img), NULL, false);
    
    CGImageRelease(img);
    return newImg;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (CGImageRef)newInvertedMaskWithCGMask:(CGImageRef)mask {
    
    CGRect rect = CGRectMake(0, 0, CGImageGetWidth(mask), CGImageGetHeight(mask));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kOptimalByteOrder);
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextClipToMask(context, rect, mask);
    CGContextClearRect(context, rect);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return imgRef;
}

#pragma mark -

@end
