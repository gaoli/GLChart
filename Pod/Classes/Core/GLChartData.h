#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GLChartInitDirection) {
    GLChartInitDirectionLeft  = 0,
    GLChartInitDirectionRight = 1
};

@interface GLChartData : NSObject

// ======= 通用属性 =======

@property (nonatomic,   copy) NSArray             *xValues;
@property (nonatomic,   copy) NSArray             *yValues;

@property (nonatomic, assign) CGFloat              min;
@property (nonatomic, assign) CGFloat              max;
@property (nonatomic, assign) NSUInteger           count;
@property (nonatomic, assign) CGFloat              scale;

// 图表边距
@property (nonatomic, assign) CGFloat              margin;

// 两轴步长
@property (nonatomic, assign) NSUInteger           xStep;
@property (nonatomic, assign) NSUInteger           yStep;

// 网格样式
@property (nonatomic, assign) CGFloat              gridLineWidth;
@property (nonatomic,   copy) NSString            *gridLineColor;

// 标签样式
@property (nonatomic, assign) CGFloat              labelFontSize;
@property (nonatomic,   copy) NSString            *labelTextColor;

// 动画属性
@property (nonatomic, assign) BOOL                 animated;
@property (nonatomic, assign) CFTimeInterval       duration;

// 初始方向
@property (nonatomic, assign) GLChartInitDirection chartInitDirection;

// ======= 折线图表 =======

// 折线图线宽
@property (nonatomic, assign) CGFloat              lineWidth;

// 每屏显示数
@property (nonatomic, assign) NSUInteger           visibleRangeMaxNum;

// 填充色开关
@property (nonatomic, assign) BOOL                 isFill;

// 指示器开关
@property (nonatomic, assign) BOOL                 isEnabledIndicator;

// 指示器属性
@property (nonatomic, assign) CGFloat              indicatorLineWidth;
@property (nonatomic,   copy) NSString            *indicatorLineColor;
@property (nonatomic,   copy) NSString            *indicatorBorderColor;
@property (nonatomic, assign) CGFloat              indicatorLabelFontSize;
@property (nonatomic,   copy) NSString            *indicatorLabelTextColor;

// ======= 柱状图表 =======

// 柱状图柱宽
@property (nonatomic, assign) CGFloat              barWidth;

// 两柱图间距
@property (nonatomic, assign) CGFloat              barMargin;

@end
