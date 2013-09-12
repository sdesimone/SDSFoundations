/*
 *  Utilities.c
 *
 *  Created by sergio on 12/5/12.
 *  Copyright 2012 Freescapes Labs. All rights reserved.
 *
 */

#include <CoreGraphics/CGGeometry.h>
#include <CoreGraphics/CGAffineTransform.h>

#import "math.h"
#import "Utilities.h"

/////////////////////////////////////////////////////////////////////////////////////////
bool isIpad() {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL isWidescreen() {
    return (BOOL)(fabs((double)[UIScreen mainScreen].bounds.size.height -
                       (double)568) < DBL_EPSILON);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL isRetina() {
    return ([UIScreen mainScreen].scale > 1.0);
}

/////////////////////////////////////////////////////////////////////////////////////////
float pt2ipadf(float pt, float factor) {
    if (isIpad())
        return factor * pt;
    return pt;
}

/////////////////////////////////////////////////////////////////////////////////////////
float pt2ipad(float pt) {
    return pt2ipadf(pt, 2.4);
}

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
@implementation NSObject (DelayBlock)

- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay),
                   dispatch_get_current_queue(), block);
}

@end

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
@implementation UIView (AutoRotation)

- (void) doRotation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    
    CGFloat rotationAngle = 0;
    if (orientation == UIDeviceOrientationPortraitUpsideDown) rotationAngle = M_PI;
        else if (orientation == UIDeviceOrientationLandscapeLeft) rotationAngle = M_PI_2;
            else if (orientation == UIDeviceOrientationLandscapeRight) rotationAngle = -M_PI_2;
                [UIView animateWithDuration:duration animations:^{
                    self.transform = CGAffineTransformMakeRotation(rotationAngle);
                } completion:nil];
}
@end

/////////////////////////////////////////////////////////////////////////////////////////
CGAffineTransform _MakeRoundedRotationTransform(CGFloat angle) {
    
	CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(angle));
    transform.a = roundf(transform.a);
    transform.b = roundf(transform.b);
    transform.c = roundf(transform.c);
    transform.d = roundf(transform.d);
	
	return transform;
}

#pragma mark -
#pragma mark radians/degrees wrapping

/////////////////////////////////////////////////////////////////////////////////////////
// modulu - similar to matlab's mod()
// result is always positive. not similar to fmod()
// Mod(-3,4)= 1   fmod(-3,4)= -3
double modulu(double x, double y) {
    
    if (0 == y)
        return x;
    return x - y * floor(x/y);
}

/////////////////////////////////////////////////////////////////////////////////////////
// wrap [rad] angle to [-PI..PI)
inline double radiansWrapPI(double fAng) {
    return modulu(fAng + M_PI, 2*M_PI) - M_PI;
}

/////////////////////////////////////////////////////////////////////////////////////////
// wrap [rad] angle to [0..TWO_PI)
inline double radiansWrap2PI(double fAng) {
    return modulu(fAng, 2*M_PI);
}

/////////////////////////////////////////////////////////////////////////////////////////
// wrap [deg] angle to [-180..180)
inline double degWrap180(double fAng) {
    return modulu(fAng + 180., 360.) - 180.;
}

/////////////////////////////////////////////////////////////////////////////////////////
// wrap [deg] angle to [0..360)
inline double degWrap360(double fAng) {
    return modulu(fAng, 360.);
}

#pragma mark -
#pragma mark vector ops
/////////////////////////////////////////////////////////////////////////////////////////
CGPoint cgpAdd(CGPoint v1, CGPoint v2) {
    return (CGPoint){v1.x + v2.x, v1.y + v2.y};
}

/////////////////////////////////////////////////////////////////////////////////////////
CGPoint cgpSub(CGPoint v1, CGPoint v2) {
    return (CGPoint){v1.x - v2.x, v1.y - v2.y};
}

/////////////////////////////////////////////////////////////////////////////////////////
CGPoint cgpMult(CGPoint v, float a) {
    v.x *= a;
    v.y *= a;
    return v;
}

/////////////////////////////////////////////////////////////////////////////////////////
CGSize cgsMult(CGSize v, float a) {
    v.width *= a;
    v.height *= a;
    return v;    
}

/////////////////////////////////////////////////////////////////////////////////////////
CGPoint cgpCrossDot(CGPoint v1, CGPoint v2) {
    return (CGPoint){v1.x * v2.x, v1.y * v2.y};
}

/////////////////////////////////////////////////////////////////////////////////////////
float cgpDot(CGPoint v1, CGPoint v2) {
    return v1.x * v2.x + v1.y * v2.y;
}

/////////////////////////////////////////////////////////////////////////////////////////
float cgpLength(CGPoint v) {
    return sqrt(cgpDot(v, v));
}

/////////////////////////////////////////////////////////////////////////////////////////
CGPoint cgpSwap(CGPoint v) {
    return (CGPoint){v.y, v.x};
}


/////////////////////////////////////////////////////////////////////////////////////////
CGPoint cgs2p(CGSize s) {
    return (CGPoint){s.width, s.height};
}

/////////////////////////////////////////////////////////////////////////////////////////
CGSize cgsSwap(CGSize v) {
    return (CGSize){v.height, v.width};
}



/*
/////////////////////////////////////////////////////////////////////////////////////////
CGPoint cgpCrossDot(CGPoint v1, CGSize v2) {
    return (CGPoint){v1.x * v2.width, v1.y * v2.height};
}

/////////////////////////////////////////////////////////////////////////////////////////
float cgpDot(CGPoint v1, CGSize v2) {
    return v1.x * v2.width + v1.y * v2.height;
}
*/