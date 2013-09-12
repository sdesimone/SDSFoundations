//
//  UIImage+SDSMask.h
//
//  Created by sergio on 3/6/12.
//  Copyright 2012 Sergio De Simone, Freescapes Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (SDSMask)


+ (CGImageRef)newMaskFromFile:(NSString*)path;
+ (CGImageRef)newBlackMaskSized:(float)s;
+ (CGImageRef)newInvertedMaskWithCGMask:(CGImageRef)mask;


@end
