//
//  NSObject+iCarousel_SDSCarousel.m
//  JigSaw
//
//  Created by sergio on 2/24/13.
//
//

#import "iCarousel+SDSCarousel.h"
#import "Utilities.h"

@implementation iCarousel (SDSCarousel)

//////////////////////////////////////////////////////////////////////////////////////////
+ (id)carouselWithRect:(CGRect)frame
              delegate:(id<SDSCarouselDataSource, iCarouselDelegate>)delegate
                  type:(iCarouselType)type {
    
    iCarousel* coverView = [[[iCarousel alloc] initWithFrame:frame] autorelease];
    coverView.type = type;
    coverView.delegate = delegate;
    coverView.dataSource = delegate;
    coverView.backgroundColor = [UIColor clearColor];
    coverView.autoresizingMask = UIViewAutoresizingFlexibleSize;
    
    [coverView scrollToItemAtIndex:[delegate currentCarouselItemIndex] animated:NO];
    
    return coverView;
}



@end
