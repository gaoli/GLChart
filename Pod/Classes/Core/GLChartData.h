#import <UIKit/UIKit.h>

@interface GLChartData : NSObject

// 通用属性

@property (nonatomic, assign) CGFloat        margin;

@property (nonatomic,   copy) NSArray       *xValues;
@property (nonatomic,   copy) NSArray       *yValues;

@property (nonatomic, assign) CGFloat        min;
@property (nonatomic, assign) CGFloat        max;
@property (nonatomic, assign) NSUInteger     count;
@property (nonatomic, assign) CGFloat        scale;

@property (nonatomic, assign) NSUInteger     xStep;
@property (nonatomic, assign) NSUInteger     yStep;

@property (nonatomic, assign) CGFloat        lineWidth;

@property (nonatomic, assign) CGFloat        gridLineWidth;
@property (nonatomic,   copy) NSString      *gridLineColor;

@property (nonatomic, assign) CGFloat        labelFontSize;
@property (nonatomic,   copy) NSString      *labelTextColor;

@property (nonatomic, assign) BOOL           animated;
@property (nonatomic, assign) CFTimeInterval duration;

// 折线图属性

@property (nonatomic, assign) NSUInteger     visibleRangeMaxNum;

@property (nonatomic, assign) BOOL           isFill;
@property (nonatomic, assign) BOOL           isEnabledIndicator;

@property (nonatomic, assign) CGFloat        indicatorLineWidth;
@property (nonatomic,   copy) NSString      *indicatorLineColor;

@end
