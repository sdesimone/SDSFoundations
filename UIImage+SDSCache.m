//
//  UIImage+SDSDeviceSuffix.m
//  MantraPhoneTest
//
//  Created by sergio on 5/2/12.
//  Copyright 2012 Sergio De Simone, Freescapes Labs. All rights reserved.
//

#import <objc/runtime.h>

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIImage (SDSDeviceSuffix)

//////////////////////////////////////////////////////////////////////////////////////////////
+ (void)load {
    Method original, swizzled;
    
    original = class_getClassMethod([UIImage class], @selector(imageNamed:));
    swizzled = class_getClassMethod([UIImage class], @selector(imageNamedSwizzled:));
    method_exchangeImplementations(original, swizzled);
}

//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)getPath:(NSString*)path suffix:(NSString*)suffix {
    
    NSString *pathWithoutExtension = [path stringByDeletingPathExtension];
    NSString *name = [pathWithoutExtension lastPathComponent];
    
    //-- check if path already has the suffix.
    if ([name rangeOfString:suffix].location != NSNotFound) {
        return path;
    }
    
    NSString *extension = [path pathExtension];    
    NSString *retinaName = [pathWithoutExtension stringByAppendingString:suffix];
    if ((retinaName = [[NSBundle mainBundle] pathForResource:retinaName ofType:extension]))
        return retinaName;
    
    return nil;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (NSMutableDictionary*)cache {
    static NSMutableDictionary* sdscache_ = nil;
    if (!sdscache_)
        sdscache_ = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
    return sdscache_;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage*)cachedImage:(NSString*)fileName {

    UIImage* img = [[self cache] objectForKey:fileName];
    if (!img) {
        NSString* imgFile = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], fileName];
        img = [UIImage imageWithContentsOfFile:imgFile];
        if (img)
            [[self cache] setObject:img forKey:imgFile];
    }
    return img;
}

/////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage*)imageNamedSwizzled:(NSString*)imageName {
    NSString* retinaName = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (![self getPath:imageName suffix:@"~ipad"]) {            
            if ((retinaName = [self getPath:imageName suffix:@"@2x"])) {
                return [[[UIImage alloc] initWithCGImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:retinaName]].CGImage
                                                  scale:1.0
                                            orientation:UIImageOrientationUp] autorelease];
            }
        }
    }
    return [self imageNamedSwizzled:imageName];
//    return [self cachedImage:imageName];
    
}

@end


