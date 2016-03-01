#import "GLChart.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"

@interface GLChart ()

@property (nonatomic, strong) CAShapeLayer *gridLayer;
@property (nonatomic, strong) UIView       *yAxisView;

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

- (BOOL)isPureInt:(CGFloat)value {
    NSString  *string  = [[NSString alloc] initWithFormat:@"%.2f", value];
    NSScanner *scanner = [[NSScanner alloc] initWithString:string];
    
    int val;
    
    [scanner scanInt:&val];
    
    return val == value;
}

- (void)parseData {
    self.chartData.min =  MAXFLOAT;
    self.chartData.max = -MAXFLOAT;
}

- (void)checkData {
    if (self.chartData.xStep > self.chartData.xValues.count) {
        self.chartData.xStep = self.chartData.xValues.count;
    }
    
    // 优化Y轴增量
    NSUInteger scale = 1;
    
    if (self.chartData.max < 10) {
        scale = 100;
    }
    
    NSUInteger max = (NSUInteger)(self.chartData.max * scale);
    NSUInteger len = [[[NSString alloc] initWithFormat:@"%lu", max] length];
    
    NSUInteger cha = 5 * pow(10, len - 2);
    NSUInteger mod = max % cha;
    
    if (mod != 0) {
        max = max + (cha - mod);
    }
    
    while ((max / 5) % cha != 0) {
        max = max + cha;
    }
    
    self.chartData.max = (CGFloat)max / (CGFloat)scale;
}

- (void)initChart {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat margin = self.chartData.margin;
    
    CGRect  gridLayerFrame = {{margin, margin}, {w - margin * 2, h - margin * 2}};
    CGRect  containerFrame = {{margin, margin}, {w - margin * 2, h - margin}};
    CGRect  yAxisViewFrame = {{margin, margin}, {w - margin * 2, h - margin * 2}};
    
    self.gridLayer.frame = gridLayerFrame;
    self.container.frame = containerFrame;
    self.yAxisView.frame = yAxisViewFrame;
    
    for (UILabel *label in self.xAxisLabels) {
        [label removeFromSuperview];
    }
    
    for (UILabel *label in self.yAxisLabels) {
        [label removeFromSuperview];
    }
    
    self.xAxisLabels = [NSMutableArray array];
    self.yAxisLabels = [NSMutableArray array];
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
        
        [self.xAxisLabels addObject:label];
        
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
    
    CGFloat     min  = self.chartData.min;
    CGFloat     max  = self.chartData.max;
    NSUInteger  step = self.chartData.yStep;
    
    CGFloat     labelFontSize  = self.chartData.labelFontSize;
    NSString   *labelTextColor = self.chartData.labelTextColor;
    
    for (int i = 0; i < step; i++) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat  value = max / step * (step - i);
        
        [self.yAxisLabels addObject:label];
        
        NSString *format = @"";
        
        if ([self isPureInt:value]) {
            format = @"%.0f";
        } else {
            format = @"%.2f";
        }
        
        NSString *labelText = [[NSString alloc] initWithFormat:format, value];
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
        
        [_container addSubview:self.chartView];
        
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

@end
