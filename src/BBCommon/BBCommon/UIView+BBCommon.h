//
//  Created by Lee Fastenau on 8/2/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>

// origin and size property macros
#define BBX(UIVIEW)                 UIVIEW.frame.origin.x /**< Gets the origin.x value of the passed UIView's frame. */
#define BBY(UIVIEW)                 UIVIEW.frame.origin.y /**< Gets the origin.y value of the passed UIView's frame. */
#define BBW(UIVIEW)                 UIVIEW.frame.size.width /**< Gets the size.width value of the passed UIView's frame. */
#define BBH(UIVIEW)                 UIVIEW.frame.size.height /**< Gets the size.height value of the passed UIView's frame. */
    
#define BBEmptyRect(X,Y)            CGRectMake(X,Y,0,0) /**< Gets a CGRect with its origin set to (X,Y) with size (0,0). */
#define BBMoveRect(RECT,X,Y)        CGRectMake(X,Y,RECT.size.width,RECT.size.height) /**< Gets a CGRect with its origin set to (X,Y) and size set to the size of the passed CGRect. */
#define BBResizeRect(RECT,W,H)      CGRectMake(RECT.origin.x,RECT.origin.y,W,H) /**< Gets a CGRect with its size set to (W,H) and origin set to the origin of the passed CGRect. */

#define BBMoveFrame(UIVIEW,X,Y)     UIVIEW.frame = BBMoveRect(UIVIEW.frame,X,Y) /**< Sets the passed UIView's frame origin to (X,Y) without changing its size. */
#define BBResizeFrame(UIVIEW,W,H)   UIVIEW.frame = BBResizeRect(UIVIEW.frame,W,H) /**< Sets the passed UIView's frame size to (W,H) without changing its origin. */

// BBHorizontalAlignment and BBVerticalAlignment enumerated values used in fast alignment math, do not modify enums
// without modifying BBAlignedOrigin macro as well.
/**
 * Gets a computed position based on alignment, the length of the outer container (superview), and the length of the object being aligned (subview).
 */
#define BBAlignedOrigin(ALIGNMENT,OUTER_LENGTH,INNER_LENGTH) roundf((((OUTER_LENGTH - INNER_LENGTH) / 2.0f) * ALIGNMENT))

/**
 * Horizontal alignment of a subview.
 */
typedef enum {
    BBHorizontalAlignmentLeft = 0, /**< Left horizontal alignment. */
    BBHorizontalAlignmentCenter = 1, /**< Center horizontal alignment. */
    BBHorizontalAlignmentRight = 2 /**< Right horizontal alignment. */
} BBHorizontalAlignment;

/**
 * Vertical alignment of a subview.
 */
typedef enum {
    BBVerticalAlignmentTop = 0, /**< Top vertical alignment. */
    BBVerticalAlignmentCenter = 1, /**< Center vertical alignment. */
    BBVerticalAlignmentBottom = 2 /**< Bottom vertical alignment. */
} BBVerticalAlignment;

/**
 * Category helper methods for UIView. Most of these methods support fluent programming or method chaining.
 */
@interface UIView(BBCommon)

// horizontal & vertical alignment helpers
// TODO: Rename to alignHorizontally and alignVertically (sounds more verb-y and less propert-y)

/**
 * Sets the horizontal and vertical alignment of a view based on the supplied superview.
 * @see horizontalAlignment:verticalAlignment:
 */
- (id)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment verticalAlignment:(BBVerticalAlignment)verticalAlignment superview:(UIView *)superview;

/**
 * Sets the horizontal and vertical alignment of a view based on its superview. The view must be a subview.
 * @see horizontalAlignment:verticalAlignment:superview:
 */
- (id)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment verticalAlignment:(BBVerticalAlignment)verticalAlignment;

/**
 * Sets the horizontal alignment of a view based on the supplied superview.
 * @see horizontalAlignment:
 */
- (id)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment superview:(UIView *)superview;

/**
 * Sets the horizontal alignment of a view based on its superview. The view must be a subview.
 * @see horizontalAlignment:superview:
 */
- (id)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment;

/**
 * Sets the vertical alignment of a view based on the supplied superview.
 * @see verticalAlignment:
 */
- (id)verticalAlignment:(BBVerticalAlignment)verticalAlignment superview:(UIView *)superview;

/**
 * Sets the vertical alignment of a view based on its superview. The view must be a subview.
 * @see verticalAlignment:superview:
 */
- (id)verticalAlignment:(BBVerticalAlignment)verticalAlignment;

// sizing helpers

/**
 * Resizes a view's frame to fit all of its subviews. This method does not change the origin of the view.
 */
- (id)sizeToSubviews;

/**
 * Adds a spacer view to this view.
 */
- (void)addSpacer:(CGSize)size;

/**
 * Take a screenshot of the view and return it as a UIImage
 */
- (UIImage *)getScreenshot;


@end