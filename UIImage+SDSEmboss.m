//
//  UIImage+SDSEmboss.m
//
//  Created by sergio on 3/6/12.
//  Copyright 2012 Sergio De Simone, Freescapes Labs. All rights reserved.
//

#import "UIImage+SDSEmboss.h"
#import "UIImage+SDSMask.h"
#import "Utilities.h"

static float gGlobalLightDirection = 1.5 * M_PI;

@implementation UIImage (SDSEmboss)

/////////////////////////////////////////////////////////////////////////////////////////
+ (void)setGlobalLightDirection:(float)deg {
    gGlobalLightDirection = DEGREES_TO_RADIANS(deg);
}

#define kShadowColorDarkEmboss [UIColor colorWithWhite:0.9 alpha:.75].CGColor
#define kShadowColorLightEmboss [UIColor colorWithWhite:0.3 alpha:1.0].CGColor
//#define kShadowColorLightEmboss [UIColor colorWithWhite:0.3 alpha:.1].CGColor
#define kEmbossColorForDarkBack [UIColor colorWithWhite:0 alpha:0.75].CGColor
#define kEmbossColorForLightBack [UIColor colorWithWhite:0.9 alpha:0.75].CGColor
#define kEmbossColor kEmbossColorForDarkBack
#define kShadowColor kShadowColorDarkEmboss
/////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage*)reliefBorderedImageWithWithImage:(UIImage*)image {
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, -1), 1, kEmbossColor);
    [image drawAtPoint:CGPointZero];
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(-1, 0), 1, kEmbossColor);
    [image drawAtPoint:CGPointZero];
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 1, kEmbossColor);
    [image drawAtPoint:CGPointZero];
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(1, 0), 1, kEmbossColor);
    [image drawAtPoint:CGPointZero];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (CGImageRef)newEmbossedBordedImageWithImage:(CGImageRef)imageRef {
    
    float w = CGImageGetWidth(imageRef);
    float h = CGImageGetHeight(imageRef);
    CGRect rect = (CGRect){ CGPointZero, {w, h}};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 0, colorSpace, kOptimalByteOrder);

    CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 1, kEmbossColor);
    CGContextDrawImage(context, rect, imageRef);
    CGContextSetShadowWithColor(context, CGSizeMake(-1, 0), 1, kEmbossColor);
    CGContextDrawImage(context, rect, imageRef);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return imgRef;
}

#define kShadowYOffset 2.0
#define kShadowStrength 0.85
#define kShadowBlur 6.0
/////////////////////////////////////////////////////////////////////////////////////////
+ (CGImageRef)newImageWithInteriorShadowFromCGImage:(CGImageRef)srcImage mask:(CGImageRef)mask {
    
    float scaleFactor = [UIScreen mainScreen].scale;
    float w = CGImageGetWidth(srcImage);
    float h = CGImageGetHeight(srcImage);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef gc = CGBitmapContextCreate(NULL, w, h, 8, 0, colorSpace, kOptimalByteOrder);
    CGContextSetInterpolationQuality(gc, kCGInterpolationMedium);

    CGContextClipToMask(gc, rect, mask);
    CGContextClipToMask(gc, rect, mask);  //-- duplication makes edges less sharp
    
    CGContextDrawImage(gc, rect, srcImage);
    
    //-- Draw the interior shadow
    CGImageRef invertedMaskRef = [self newInvertedMaskWithCGMask:mask];
    CGContextSetShadowWithColor(gc,
                                (CGSize){0.0, -sinf(gGlobalLightDirection) * pt2ipad(kShadowYOffset) * scaleFactor},
                                kShadowBlur,
                                kShadowColor);
    CGContextDrawImage(gc, rect, invertedMaskRef);
    CGImageRelease(invertedMaskRef);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(gc);
    
    CGContextRelease(gc);
    CGColorSpaceRelease(colorSpace);
    
    return imgRef;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (CGImageRef)newImageWithUpwardShadowFromImage:(CGImageRef)image {
    
    float scaleFactor = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef gc = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kOptimalByteOrder);
    CGContextSetInterpolationQuality(gc, kCGInterpolationMedium);

    CGContextSetShadowWithColor(gc,
                                (CGSize){0.0, -sinf(gGlobalLightDirection) * pt2ipad(kShadowYOffset) * scaleFactor},
                                kShadowBlur,
                                [UIColor colorWithWhite:1.0 alpha:kShadowStrength].CGColor);
    
    CGContextDrawImage(gc, rect, image);
    CGImageRef imgRef = CGBitmapContextCreateImage(gc);
    
    CGContextRelease(gc);
    CGColorSpaceRelease(colorSpace);
    
    return imgRef;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (CGImageRef)newDoubleShadowedImageFromCGImage:(CGImageRef)image mask:(CGImageRef)mask {
    
    CGImageRef shadowedImage = [self newImageWithInteriorShadowFromCGImage:image mask:mask];
    CGImageRef imgRef = [self newImageWithUpwardShadowFromImage:shadowedImage];
    CGImageRelease(shadowedImage);
    
    return imgRef;
}


/////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage*)doubleShadowedImageFromUIImage:(UIImage*)image mask:(CGImageRef)mask {
    
    CGImageRef shadowedImage = [self newImageWithInteriorShadowFromCGImage:image.CGImage mask:mask];
    CGImageRef imgRef = [self newImageWithUpwardShadowFromImage:shadowedImage];
    image = [UIImage imageWithCGImage:imgRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imgRef);
    CGImageRelease(shadowedImage);
    return image;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (CGImageRef)newEmbossedImageFromCGImage:(CGImageRef)image mask:(CGImageRef)mask {
    CGImageRef shadowedImage = [self newImageWithInteriorShadowFromCGImage:image mask:mask];
    CGImageRef embossedImage = [self newEmbossedBordedImageWithImage:shadowedImage];
    CGImageRelease(shadowedImage);
    return embossedImage;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage*)embossedImageFromCGImage:(CGImageRef)image maskFile:(NSString*)maskFile {

    CGImageRef mask = [self newMaskFromFile:@"puzzleMask"];

    CGImageRef imgRef = [UIImage newEmbossedImageFromCGImage:image mask:mask];
    UIImage* resultImage = [UIImage imageWithCGImage:imgRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];

    CGImageRelease(imgRef);
    CGImageRelease(mask);

    return resultImage;
}

#pragma mark -

@end
