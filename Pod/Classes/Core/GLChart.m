#import "GLChart.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"

@interface GLChart ()

@property (nonatomic, strong) CAShapeLayer *gridLayer;
@property (nonatomic, strong) UIView       *xAxisView;
@property (nonatomic, strong) UIView       *yAxisView;

@end

@implementation GLChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 添加子类图层
        [self.layer addSublayer:self.gridLayer];
        
        // 添加子类视图
        [self addSubview:self.chartView];
        [self addSubview:self.xAxisView];
        [self addSubview:self.yAxisView];
    }
    
    return self;
}

#pragma mark - private methods

- (void)parseData {
    if (self.chartData.xStep > self.chartData.xValues.count) {
        self.chartData.xStep = self.chartData.xValues.count;
    }
}

- (void)drawChart {
    
}

- (void)drawGrid {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat w = self.gridLayer.frame.size.width;
    CGFloat h = self.gridLayer.frame.size.height;
    
    for (int i = 0; i <= self.chartData.yStep; i++) {
        CGFloat x = w;
        CGFloat y = h / self.chartData.yStep * i;
        
        [path moveToPoint:CGPointMake(0.0f, y)];
        [path addLineToPoint:CGPointMake(x, y)];
    }
    
    self.gridLayer.path        = path.CGPath;
    self.gridLayer.lineWidth   = self.chartData.gridWidth;
    self.gridLayer.strokeColor = [UIColor colorWithHexString:self.chartData.gridColor].CGColor;
}

- (void)drawAxis {
    [self createXAxisLabels];
    [self createYAxisLabels];
}

- (void)createXAxisLabels {
    CGFloat     w = self.xAxisView.frame.size.width;
    CGFloat     h = self.xAxisView.frame.size.height;
    
    NSUInteger  step   = self.chartData.xStep;
    NSArray    *values = self.chartData.xValues;
    
    CGFloat     labelFontSize  = self.chartData.labelFontSize;
    NSString   *labelTextColor = self.chartData.labelTextColor;
    
    for (int i = 0; i < step; i++) {
        UILabel    *label = [[UILabel alloc] init];
        NSUInteger  index = values.count / step * i;
        
        NSString *labelText = [[NSString alloc] initWithFormat:@"%@", values[index]];
        CGSize    labelSize = [labelText sizeWithAttributes:@{@"NSFontAttributeName": [UIFont systemFontOfSize:labelFontSize]}];
        CGRect    labelRect = {{w / (step - 1) * i - labelSize.width / 2, h}, labelSize};
        
        label.frame           = labelRect;
        label.text            = labelText;
        label.font            = [UIFont systemFontOfSize   :labelFontSize];
        label.textColor       = [UIColor colorWithHexString:labelTextColor];
        label.textAlignment   = NSTextAlignmentCenter;
        
        [self.xAxisView addSubview:label];
    }
}

- (void)createYAxisLabels {
    CGFloat     w = self.yAxisView.frame.size.width;
    CGFloat     h = self.yAxisView.frame.size.height;
    
    CGFloat     min  = self.chartData.min;
    CGFloat     max  = self.chartData.max;
    NSUInteger  step = self.chartData.yStep;
    
    CGFloat     labelFontSize  = self.chartData.labelFontSize;
    NSString   *labelTextColor = self.chartData.labelTextColor;
    
    for (int i = 0; i < step; i++) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat  value = min + (max - min) / step * (step - i);
        
        NSString *labelText = [[NSString alloc] initWithFormat:@"%.2f", value];
        CGSize    labelSize = [labelText sizeWithAttributes:@{@"NSFontAttributeName": [UIFont systemFontOfSize:labelFontSize]}];
        CGRect    labelRect = {{0.0f, h / step * i}, labelSize};

        label.frame           = labelRect;
        label.text            = labelText;
        label.font            = [UIFont systemFontOfSize   :labelFontSize];
        label.textColor       = [UIColor colorWithHexString:labelTextColor];
        label.textAlignment   = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.5f];
        
        label.layer.cornerRadius  = 2.0f;
        label.layer.masksToBounds = YES;
        
        [self.yAxisView addSubview:label];
    }
}

- (CGRect)getFrameWithMargin:(CGFloat)margin {
    return CGRectMake(self.chartData.margin,
                      self.chartData.margin,
                      self.frame.size.width  - self.chartData.margin * 2,
                      self.frame.size.height - self.chartData.margin * 2);
}

#pragma mark - getters and setters

- (void)setChartData:(GLChartData *)chartData {
    _chartData = chartData;
    
    self.gridLayer.frame       = [self getFrameWithMargin:self.chartData.margin];
    self.xAxisView.frame       = [self getFrameWithMargin:self.chartData.margin];
    self.yAxisView.frame       = [self getFrameWithMargin:self.chartData.margin];
    self.chartView.frame       = [self getFrameWithMargin:self.chartData.margin];
    self.chartView.contentSize = self.chartView.frame.size;
    
    [self parseData];
    [self drawChart];
    
    [self drawGrid];
    [self drawAxis];
}

- (CAShapeLayer *)gridLayer {
    if (_gridLayer == nil) {
        _gridLayer = [[CAShapeLayer alloc] init];
    }
    
    return _gridLayer;
}

- (UIView *)xAxisView {
    if (_xAxisView == nil) {
        _xAxisView = [[UIView alloc] init];
    }
    
    return _xAxisView;
}

- (UIView *)yAxisView {
    if (_yAxisView == nil) {
        _yAxisView = [[UIView alloc] init];
    }
    
    return _yAxisView;
}

- (UIScrollView *)chartView {
    if (_chartView == nil) {
        _chartView = [[UIScrollView alloc] init];
        
        _chartView.showsHorizontalScrollIndicator = NO;
        _chartView.showsVerticalScrollIndicator   = NO;
    }
    
    return _chartView;
}

@end
