//
//  CALayer+SDSLayerByName.m
//
//  Created by sergio on 5/2/12.
//  Copyright 2012 Sergio De Simone, Freescapes Labs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "CALayer+SDSLayerByName.h"

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
@implementation CALayer (SDSLayerByName)

+ (void)swizzleMethod:(SEL)originalSel andMethod:(SEL)swizzledSel {
    
    Method original = class_getInstanceMethod(self, originalSel);
    Method swizzled = class_getInstanceMethod(self, swizzledSel);
    if (original && swizzled)
        method_exchangeImplementations(original, swizzled);
    else
        NSLog(@"CALayer+SDSLayerByName Swizzling Fault: methods not found.");

}    

////////////////////////////////////////////////////////////////////////
+ (void)load {
    [self swizzleMethod:@selector(addSublayer:) andMethod:@selector(addSublayerSwizzled:)];
    [self swizzleMethod:@selector(setName:) andMethod:@selector(setNameSwizzled:)];
}

////////////////////////////////////////////////////////////////////////
//-- the two methods below add a cyclic dependency because layer is retained
//-- when added to the dictionary; solution would be using a non retaining structure
////////////////////////////////////////////////////////////////////////
- (void)addSublayerSwizzled:(CALayer*)layer {
    [self addSublayerSwizzled:layer];
    if (layer.name)
        [self setValue:layer forKey:layer.name];
}

////////////////////////////////////////////////////////////////////////
- (void)setNameSwizzled:(NSString*)name {
    [self setNameSwizzled:name];
    if (self.superlayer) {
        [self.superlayer setValue:self forKey:name];
    }
}

////////////////////////////////////////////////////////////////////////
- (CALayer*)layerByName:(NSString*)name {
    return [self valueForKey:name];
}

@end
