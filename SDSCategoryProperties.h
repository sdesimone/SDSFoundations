//
//  FLCategoryProperties.h
//
// Macro shenanigans to define methods that simulate properities using
// associative references
//
//  Created by sergio on 10/12/12.
//  Copyright 2012 Freescapes Labs. All rights reserved.
//

#import <objc/runtime.h>

//////////////////////////////////////////////////////////////////////////////////////////

#define PROPERTY_PRIMITIVE(NAME, SETTER, TYPE, NSNUMBER_CTOR, PRIMITIVE_GETTER) \
static char NAME##Key; \
- (TYPE) NAME \
{ \
NSNumber *number = (NSNumber *)objc_getAssociatedObject(self, & NAME##Key); \
return number ? number.PRIMITIVE_GETTER : (TYPE)0;\
}\
\
- (void) SETTER:(TYPE)value\
{\
objc_setAssociatedObject(self, & NAME##Key, [NSNumber NSNUMBER_CTOR:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

#define PROPERTY_OBJ(NAME, SET_NAME, TYPE) \
static char NAME##Key; \
- (TYPE) NAME { return (TYPE)objc_getAssociatedObject(self, & NAME##Key); } \
- (void) SET_NAME:(TYPE)value { objc_setAssociatedObject(self, & NAME##Key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

//////////////////////////////////////////////////////////////////////////////////////////
