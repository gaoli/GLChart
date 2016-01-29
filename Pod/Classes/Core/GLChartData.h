#import <UIKit/UIKit.h>

@interface GLChartData : NSObject

@property (nonatomic,   copy) NSArray       *xValues;
@property (nonatomic,   copy) NSArray       *yValues;

@property (nonatomic, assign) CGFloat        min;
@property (nonatomic, assign) CGFloat        max;

@property (nonatomic, assign) CGFloat        margin;

@property (nonatomic, assign) NSUInteger     xStep;
@property (nonatomic, assign) NSUInteger     yStep;

@property (nonatomic, assign) CGFloat        lineWidth;
@property (nonatomic, assign) CGFloat        gridWidth;
@property (nonatomic,   copy) NSString      *gridColor;

@property (nonatomic, assign) CGFloat        labelFontSize;
@property (nonatomic,   copy) NSString      *labelColor;

@property (nonatomic, assign) BOOL           animated;
@property (nonatomic, assign) CFTimeInterval duration;

@end
