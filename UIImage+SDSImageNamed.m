//
//  UIImage+UIImage_SDSImageNamed.m
//  JigSaw
//
//  Created by sergio on 6/9/13.
//  Copyright 2013 Freescapes Labs. All rights reserved.
//
//

#import "Utilities.h"
#import "UIImage+SDSImageNamed.h"

@implementation UIImage (SDSImageNamed)

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage*)imageWithName:(NSString*)name deviceQualifier:(NSString*)qualifier type:(NSString*)type {
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@.%@", name, qualifier, type]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//-- this method will return the best approx of an image for the specific device
//-- @2x images will be returned for non retina-display as well if non-retina ones are not av.
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage*)imageWithName:(NSString*)name {
    
    float scale = [UIScreen mainScreen].scale;
    UIImage* result= nil;
    
    NSString* pathExtension = [name pathExtension];
    if (pathExtension && ![pathExtension isEqualToString:@""])
        name = [name stringByDeletingPathExtension];
    else
        pathExtension = @"png";
    
    name = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], name];
    
    if (isWidescreen()) {
        result = [self imageWithName:name deviceQualifier:@"-568h@2x" type:pathExtension];
        if (result)
            return result;
    }
    
    if (isIpad()) {
        if (scale < 1.5)
            result = [self imageWithName:name deviceQualifier:@"~ipad" type:pathExtension];
        if (result)
            return result;
        result = [self imageWithName:name deviceQualifier:@"@2x~ipad" type:pathExtension];
        if (result)
            return result;
    }
    
    if (scale > 1.5 || isIpad())
        result = [self imageWithName:name deviceQualifier:@"@2x" type:pathExtension];
    if (result)
        return result;
    
    return [self imageWithName:name deviceQualifier:@"" type:pathExtension];
}

@end
