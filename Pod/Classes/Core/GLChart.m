#import "GLChart.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"
#import "GLChartIndicator.h"

@interface GLChart ()

@property (nonatomic, strong) CAShapeLayer     *gridLayer;
@property (nonatomic, strong) UIScrollView     *container;
@property (nonatomic, strong) UIView           *maskLView;
@property (nonatomic, strong) UIView           *maskRView;
@property (nonatomic, strong) GLChartIndicator *indicator;
@property (nonatomic, strong) NSMutableArray   *xAxisLabels;
@property (nonatomic, strong) NSMutableArray   *yAxisLabels;

@end

@implementation GLChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 添加子类图层
        [self.layer addSublayer:self.gridLayer];
        
        // 添加子类视图
        [self addSubview:self.container];
        [self addSubview:self.maskLView];
        [self addSubview:self.maskRView];
        [self addSubview:self.indicator];
        
        // 设置背景颜色
        self.backgroundColor = [UIColor whiteColor];
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
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat margin = self.chartData.margin;
    
    CGRect  gridLayerFrame = {{margin,     margin}, {w - margin * 2, h - margin * 2}};
    CGRect  containerFrame = {{0.0f,       margin}, {w,              h - margin}};
    CGRect  maskLViewFrame = {{0.0f,       0.0f},   {margin,         h - margin}};
    CGRect  maskRViewFrame = {{w - margin, 0.0f},   {margin,         h - margin}};
    
    self.gridLayer.frame        = gridLayerFrame;
    self.maskLView.frame        = maskLViewFrame;
    self.maskRView.frame        = maskRViewFrame;
    self.container.frame        = containerFrame;
    self.container.contentInset = UIEdgeInsetsMake(0.0f, margin, 0.0f, margin);
    
    if (self.chartData.isEnabledIndicator == NO &&
        self.chartData.visibleRangeMaxNum != 0  &&
        self.chartData.visibleRangeMaxNum < self.chartData.xValues.count) {
        CGFloat scale = (CGFloat)self.chartData.xValues.count / (CGFloat)self.chartData.visibleRangeMaxNum;
        CGRect  frame = {{0.0f, 0.0f}, {(w - margin * 2) * scale, h - margin * 2}};
        
        self.chartView.frame       = frame;
        self.container.contentSize = frame.size;
    } else {
        CGRect frame = {{0.0f, 0.0f}, {w - margin * 2, h - margin * 2}};
        
        self.chartView.frame       = frame;
        self.container.contentSize = frame.size;
    }
    
    if (self.chartData.isEnabledIndicator) {
        CGRect frame = {{margin, margin}, {w - margin * 2, h - margin * 2}};
        
        self.indicator.frame  = frame;
        self.indicator.hidden = NO;
    } else {
        self.indicator.hidden = YES;
    }
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
    self.gridLayer.lineWidth   = self.chartData.gridLineWidth;
    self.gridLayer.strokeColor = [UIColor colorWithHexString:self.chartData.gridLineColor].CGColor;
}

- (void)drawAxis {
    [self createXAxisLabels];
    [self createYAxisLabels];
}

- (void)createXAxisLabels {
    CGFloat     w = self.container.contentSize.width;
    CGFloat     h = self.container.contentSize.height;
    
    NSUInteger  step   = self.chartData.xStep;
    NSArray    *values = self.chartData.xValues;
    
    CGFloat     labelFontSize  = self.chartData.labelFontSize;
    NSString   *labelTextColor = self.chartData.labelTextColor;
    
    for (int i = 0; i < step; i++) {
        UILabel    *label = [[UILabel alloc] init];
        NSUInteger  index = values.count / (step - 1) * i;
        
        if (index >= values.count) {
            index =  values.count - 1;
        }
        
        NSString *labelText = [[NSString alloc] initWithFormat:@"%@", values[index]];
        CGSize    labelSize = [labelText sizeWithAttributes:@{@"NSFontAttributeName": [UIFont systemFontOfSize:labelFontSize]}];
        CGRect    labelRect = {{w / (step - 1) * i - labelSize.width / 2, h}, labelSize};
        
        label.frame           = labelRect;
        label.text            = labelText;
        label.font            = [UIFont systemFontOfSize   :labelFontSize];
        label.textColor       = [UIColor colorWithHexString:labelTextColor];
        label.textAlignment   = NSTextAlignmentCenter;
        
        [self.container addSubview:label];
    }
}

- (void)createYAxisLabels {
    CGFloat     h = self.gridLayer.frame.size.height;
    
    CGFloat     min    = self.chartData.min;
    CGFloat     max    = self.chartData.max;
    NSUInteger  step   = self.chartData.yStep;
    CGFloat     margin = self.chartData.margin;
    
    CGFloat     labelFontSize  = self.chartData.labelFontSize;
    NSString   *labelTextColor = self.chartData.labelTextColor;
    
    for (int i = 0; i < step; i++) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat  value = min + (max - min) / step * (step - i);
        
        NSString *labelText = [[NSString alloc] initWithFormat:@"%.2f", value];
        CGSize    labelSize = [labelText sizeWithAttributes:@{@"NSFontAttributeName": [UIFont systemFontOfSize:labelFontSize]}];
        CGRect    labelRect = {{margin, h / step * i + margin}, labelSize};

        label.frame           = labelRect;
        label.text            = labelText;
        label.font            = [UIFont systemFontOfSize   :labelFontSize];
        label.textColor       = [UIColor colorWithHexString:labelTextColor];
        label.textAlignment   = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.5f];
        
        label.layer.cornerRadius  = 2.0f;
        label.layer.masksToBounds = YES;
        
        [self addSubview:label];
    }
}

#pragma mark - getters and setters

- (void)setChartData:(GLChartData *)chartData {
    _chartData = chartData;
    
    [self parseData];
    [self drawChart];
    
    [self drawGrid];
    [self drawAxis];
    
    self.indicator.chartData = chartData;
}

- (CAShapeLayer *)gridLayer {
    if (_gridLayer == nil) {
        _gridLayer = [[CAShapeLayer alloc] init];
    }
    
    return _gridLayer;
}

- (UIScrollView *)container {
    if (_container == nil) {
        _container = [[UIScrollView alloc] init];
        
        [_container addSubview:self.chartView];
        
        _container.showsHorizontalScrollIndicator = NO;
        _container.showsVerticalScrollIndicator   = NO;
    }
    
    return _container;
}

- (UIView *)chartView {
    if (_chartView == nil) {
        _chartView = [[UIView alloc] init];
    }
    
    return _chartView;
}

- (UIView *)maskLView {
    if (_maskLView == nil) {
        _maskLView = [[UIView alloc] init];
        
        _maskLView.backgroundColor = [UIColor whiteColor];
    }
    
    return _maskLView;
}

- (UIView *)maskRView {
    if (_maskRView == nil) {
        _maskRView = [[UIView alloc] init];
        
        _maskRView.backgroundColor = [UIColor whiteColor];
    }
    
    return _maskRView;
}

- (GLChartIndicator *)indicator {
    if (_indicator == nil) {
        _indicator = [[GLChartIndicator alloc] init];
    }
    
    return _indicator;
}

@end
