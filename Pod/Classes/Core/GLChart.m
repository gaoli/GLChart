#import "GLChart.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"

@interface GLChart ()

@property (nonatomic, strong) CAShapeLayer *gridLayer;
@property (nonatomic, strong) UIView       *yAxisView;
@property (nonatomic, strong) UILabel      *tipsLabel;

@end

@implementation GLChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.xAxisLabels = [NSMutableArray array];
        self.yAxisLabels = [NSMutableArray array];
        
        // 添加子类图层
        [self.layer addSublayer:self.gridLayer];
        
        // 添加子类视图
        [self addSubview:self.container];
        [self addSubview:self.yAxisView];
        
        // 设置背景颜色
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

#pragma mark - private methods

- (void)parseData {
    self.chartData.min =  MAXFLOAT;
    self.chartData.max = -MAXFLOAT;
}

- (void)checkData {
    if (self.chartData.xStep > self.chartData.xValues.count) {
        self.chartData.xStep = self.chartData.xValues.count >= 2 ? self.chartData.xValues.count : 2;
    }
    
    if (self.chartData.min >= 0 && self.chartData.max > 0) {
        [self normalizeInterval];
    }
    
}

- (void)initChart {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat margin = self.chartData.margin;
    
    CGRect gridLayerFrame = {{margin, margin}, {w - margin * 2, h - margin * 2}};
    CGRect containerFrame = {{margin, margin}, {w - margin * 2, h - margin}};
    CGRect yAxisViewFrame = {{margin, margin}, {0.0f, h - margin * 2}};
    CGRect tipsLabelFrame = {{margin, margin}, {w - margin * 2, h - margin * 2}};
    
    self.gridLayer.frame = gridLayerFrame;
    self.container.frame = containerFrame;
    self.yAxisView.frame = yAxisViewFrame;
    self.tipsLabel.frame = tipsLabelFrame;
    
    for (UILabel *label in self.xAxisLabels) {
        [label removeFromSuperview];
    }
    
    for (UILabel *label in self.yAxisLabels) {
        [label removeFromSuperview];
    }
    
    self.xAxisLabels = [NSMutableArray array];
    self.yAxisLabels = [NSMutableArray array];
    
    [self.tipsLabel removeFromSuperview];
    
    if (self.chartData.noData) {
        [self addSubview:self.tipsLabel];
    } else {
        _tipsLabel = nil;
    }
}

- (void)drawChart {
    
}

- (void)loadComponents {
    
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
    if (!self.chartData.noData) {
        [self createXAxisLabels];
        [self createYAxisLabels];
    }
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
        
        [self.xAxisLabels addObject:label];
        
        if (index >= values.count) {
            index =  values.count - 1;
        }
        
        NSString *labelText = [[NSString alloc] initWithFormat:@"%@", values[index]];
        CGSize    labelSize = [labelText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:labelFontSize]}];
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
    CGFloat    h = self.gridLayer.frame.size.height;
    
    CGFloat    min  = self.chartData.min;
    CGFloat    max  = self.chartData.max;
    NSUInteger step = self.chartData.yStep;
    
    CGFloat    labelFontSize  = self.chartData.labelFontSize;
    NSString  *labelTextColor = self.chartData.labelTextColor;
    
    for (int i = 0; i < step; i++) {
        UILabel  *label = [[UILabel alloc] init];
        CGFloat   value = min + (max - min) / step * (step - i);
        NSString *unit  = @"";
        
        [self.yAxisLabels addObject:label];
        
        if (value >= 1000000) {
            value = value / 1000000;
            unit  = @"M";
        }
        
        if (value >= 1000) {
            value = value / 1000;
            unit  = @"k";
        }
        
        NSString *labelText = [[NSString alloc] initWithFormat:@"%g%@", value, unit];
        CGSize    labelSize = [labelText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:labelFontSize]}];
        CGRect    labelRect = {{0.0f, h / step * i}, labelSize};
        
        label.frame           = labelRect;
        label.text            = labelText;
        label.font            = [UIFont systemFontOfSize   :labelFontSize];
        label.textColor       = [UIColor colorWithHexString:labelTextColor];
        label.textAlignment   = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
        
        label.layer.cornerRadius  = 2.0f;
        label.layer.masksToBounds = YES;
        
        [self.yAxisView addSubview:label];
    }
}

- (void)normalizeInterval {
    CGFloat  min = self.chartData.min;
    CGFloat  max = self.chartData.max;
    
    CGFloat     interval = (max - min) * (50.0f / self.frame.size.height);
    CGFloat  retInterval = (max - min) * (50.0f / self.frame.size.height);
    
    CGFloat  magnitude = powf(10.0f, floorf(logf(interval) / logf(10.0f)));
    NSArray *multiples = @[@1.0f, @2.0f, @2.5f, @5.0f, @10.0f];
    
       interval /= magnitude;
    retInterval /= magnitude;
    
    for (int i = 0; i < multiples.count; i ++) {
        CGFloat     multiple = [multiples[i] floatValue];
        CGFloat nextMultiple = [multiples[i == multiples.count - 1 ? i : i + 1] floatValue];
        
        if (interval <= ((multiple + nextMultiple) / 2)) {
            retInterval = multiple;
            break;
        }
    }
    
    retInterval *= magnitude;
    
    self.chartData.min   = retInterval * floorf(min / retInterval);
    self.chartData.max   = retInterval * (ceilf(max / retInterval) + 1);
    self.chartData.yStep = (self.chartData.max - self.chartData.min) / retInterval;
}

#pragma mark - getters and setters

- (void)setChartData:(GLChartData *)chartData {
    _chartData = chartData;
    
    [self parseData];
    [self checkData];
    
    [self initChart];
    [self drawChart];
    
    [self drawGrid];
    [self drawAxis];
    
    [self loadComponents];
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
        
        _container.showsHorizontalScrollIndicator = NO;
        _container.showsVerticalScrollIndicator   = NO;
    }
    
    return _container;
}

- (UIView *)yAxisView {
    if (_yAxisView == nil) {
        _yAxisView = [[UIView alloc] init];
    }
    
    return _yAxisView;
}

- (UIView *)chartView {
    if (_chartView == nil) {
        _chartView = [[UIView alloc] init];
    }
    
    return _chartView;
}

- (UILabel *)tipsLabel {
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc] init];
        
        _tipsLabel.text          = self.chartData.noDataTips;
        _tipsLabel.font          = [UIFont systemFontOfSize   :self.chartData.labelFontSize];
        _tipsLabel.textColor     = [UIColor colorWithHexString:self.chartData.labelTextColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _tipsLabel;
}

@end
