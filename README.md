# GLChart

[![CI Status](http://img.shields.io/travis/gaoli/GLChart.svg?style=flat)](https://travis-ci.org/gaoli/GLChart)
[![Version](https://img.shields.io/cocoapods/v/GLChart.svg?style=flat)](http://cocoapods.org/pods/GLChart)
[![License](https://img.shields.io/cocoapods/l/GLChart.svg?style=flat)](http://cocoapods.org/pods/GLChart)
[![Platform](https://img.shields.io/cocoapods/p/GLChart.svg?style=flat)](http://cocoapods.org/pods/GLChart)

## Screenshots

<img src="Screenshots/lineChart.png" width="320px" /> &nbsp;
<img src="Screenshots/barChart.png"  width="320px" />

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### LineChart

```
#import "GLChartData.h"
#import "GLLineChart.h"

GLChartData *chartData = [[GLChartData alloc] init];
GLLineChart *lineChart = [[GLLineChart alloc] init];

chartData.xValues = @[@"10:01", @"10:02", @"10:03", @"10:04", @"10:05",
                      @"10:06", @"10:07", @"10:08", @"10:09", @"10:10"];
					  
chartData.yValues = @[@{@"color": @"#7CB5EC",
                        @"value": @[@18, @20, @18, @20, @18,
                                    @20, @18, @20, @18, @20],
                        @"width": @1.0f},
                      @{@"color": @"#F7A35C",
                        @"value": @[@8,  @10, @8,  @10, @8,
                                    @10, @8,  @10, @8,  @10]}];

lineChart.chartData = chartData;
```

### BarChart

```
#import "GLChartData.h"
#import "GLBarChart.h"

GLChartData *chartData = [[GLChartData alloc] init];
GLLineChart *barChart  = [[GLBarChart  alloc] init];

chartData.xValues = @[@"10:01", @"10:02", @"10:03", @"10:04", @"10:05",
                      @"10:06", @"10:07", @"10:08", @"10:09", @"10:10"];
					  
chartData.yValues = @[@[@{@"value": @10, @"color": @"#7ED321"}, @{@"value": @5, @"color": @"#E74C3C"}],
                      @[@{@"value": @10, @"color": @"#7ED321"}, @{@"value": @5, @"color": @"#E74C3C"}],
                      @[@{@"value": @10, @"color": @"#7ED321"}, @{@"value": @5, @"color": @"#E74C3C"}],
                      @[@{@"value": @10, @"color": @"#7ED321"}, @{@"value": @5, @"color": @"#E74C3C"}],
                      @[@{@"value": @10, @"color": @"#7ED321"}, @{@"value": @5, @"color": @"#E74C3C"}],
                      @[@{@"value": @10, @"color": @"#7ED321"}, @{@"value": @5, @"color": @"#E74C3C"}],
                      @[@{@"value": @10, @"color": @"#7ED321"}, @{@"value": @5, @"color": @"#E74C3C"}],
                      @[@{@"value": @10, @"color": @"#7ED321"}, @{@"value": @5, @"color": @"#E74C3C"}],
                      @[@{@"value": @10, @"color": @"#7ED321"}, @{@"value": @5, @"color": @"#E74C3C"}],
                      @[@{@"value": @10, @"color": @"#7ED321"}, @{@"value": @5, @"color": @"#E74C3C"}]];

barChart.chartData = chartData;
```

### Customizing Chart

```
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
```

## Installation

GLChart is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GLChart"
```

## Author

gaoli, 3071730@qq.com

## License

GLChart is available under the MIT license. See the LICENSE file for more info.
