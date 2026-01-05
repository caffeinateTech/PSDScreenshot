
#import <Cocoa/Cocoa.h>

@class AppDelegate;

typedef enum _MAWindowPosition {

    MAPositionLeft          = NSMinXEdge, // 0
    MAPositionRight         = NSMaxXEdge, // 2
    MAPositionTop           = NSMaxYEdge, // 3
    MAPositionBottom        = NSMinYEdge, // 1
    MAPositionLeftTop       = 4,
    MAPositionLeftBottom    = 5,
    MAPositionRightTop      = 6,
    MAPositionRightBottom   = 7,
    MAPositionTopLeft       = 8,
    MAPositionTopRight      = 9,
    MAPositionBottomLeft    = 10,
    MAPositionBottomRight   = 11,
    MAPositionAutomatic     = 12
} MAWindowPosition;

@interface MAAttachedWindow : NSWindow {
    
    NSColor *borderColor;
    float borderWidth;
    float viewMargin;
    float arrowBaseWidth;
    float arrowHeight;
    BOOL hasArrow;
    float cornerRadius;
    BOOL drawsRoundCornerBesideArrow;
    
    @private
    NSColor *_MABackgroundColor;
    __weak NSView *_view;
    __weak NSWindow *_window;
    NSPoint _point;
    MAWindowPosition _side;
    float _distance;
    NSRect _viewFrame;
    BOOL _resizing;

    AppDelegate *appDelegateObject;

    float MAATTACHEDWINDOW_SCALE_FACTOR;
}



@property(retain)AppDelegate *appDelegateObject;

- (MAAttachedWindow *)initWithView:(NSView *)view
                   attachedToPoint:(NSPoint)point 
                          inWindow:(NSWindow *)window 
                            onSide:(MAWindowPosition)side 
                        atDistance:(float)distance;

- (MAAttachedWindow *)initWithView:(NSView *)view
                   attachedToPoint:(NSPoint)point 
                          inWindow:(NSWindow *)window 
                        atDistance:(float)distance;

- (MAAttachedWindow *)initWithView:(NSView *)view
                   attachedToPoint:(NSPoint)point 
                            onSide:(MAWindowPosition)side 
                        atDistance:(float)distance;

- (MAAttachedWindow *)initWithView:(NSView *)view
                   attachedToPoint:(NSPoint)point 
                        atDistance:(float)distance;

- (MAAttachedWindow *)initWithView:(NSView *)view
                   attachedToPoint:(NSPoint)point
                          inWindow:(NSWindow *)window;

- (MAAttachedWindow *)initWithView:(NSView *)view
                   attachedToPoint:(NSPoint)point 
                            onSide:(MAWindowPosition)side;

- (MAAttachedWindow *)initWithView:(NSView *)view
                   attachedToPoint:(NSPoint)point;

// Accessor methods
- (NSColor *)borderColor;
- (void)setBorderColor:(NSColor *)value;
- (float)borderWidth;
- (void)setBorderWidth:(float)value;                   // See note 1 below.
- (float)viewMargin;
- (void)setViewMargin:(float)value;                    // See note 2 below.
- (float)arrowBaseWidth;
- (void)setArrowBaseWidth:(float)value;                // See note 2 below.
- (float)arrowHeight;
- (void)setArrowHeight:(float)value;                   // See note 2 below.
- (float)hasArrow;
- (void)setHasArrow:(float)value;
- (float)cornerRadius;
- (void)setCornerRadius:(float)value;                  // See note 2 below.
- (float)drawsRoundCornerBesideArrow;                  // See note 3 below.
- (void)setDrawsRoundCornerBesideArrow:(float)value;   // See note 2 below.
- (void)setBackgroundImage:(NSImage *)value;
- (NSColor *)windowBackgroundColor;                    // See note 4 below.
- (void)setBackgroundColor:(NSColor *)value;


@end
