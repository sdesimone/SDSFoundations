//
//  UIImage+SDSEmboss.h
//
//  Created by sergio on 3/6/12.
//  Copyright 2012 Sergio De Simone, Freescapes Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (SDSEmboss)

+ (void)setGlobalLightDirection:(float)deg;

+ (UIImage*)embossedImageFromCGImage:(CGImageRef)image maskFile:(NSString*)maskFile;
+ (CGImageRef)newDoubleShadowedImageFromCGImage:(CGImageRef)image mask:(CGImageRef)mask;
+ (UIImage*)doubleShadowedImageFromUIImage:(UIImage*)image mask:(CGImageRef)mask;

@end
