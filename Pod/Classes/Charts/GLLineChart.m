#import "GLLineChart.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"
#import "GLChartDotMarker.h"
#import "GLChartLineMarker.h"
#import "GLChartIndicator.h"

@interface GLLineChart ()

@property (nonatomic, strong) UIView            *maskLView;
@property (nonatomic, strong) UIView            *maskRView;
@property (nonatomic, strong) GLChartDotMarker  *dotMarker;
@property (nonatomic, strong) GLChartLineMarker *lineMarker;
@property (nonatomic, strong) GLChartIndicator  *indicator;

@end

@implementation GLLineChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self           addSubview:self.maskLView];
        [self           addSubview:self.maskRView];
        [self.container addSubview:self.lineMarker];
        [self.container addSubview:self.chartView];
        [self.container addSubview:self.dotMarker];
        [self           addSubview:self.indicator];
    }
    
    return self;
}

#pragma mark - private methods

- (void)parseData {
    [super parseData];
    
    for (NSDictionary *dict in self.chartData.yValues) {
        NSArray *value = dict[@"value"];
        UIColor *color = [UIColor colorWithHexString:dict[@"color"]];
        
        if (value == nil || color == nil) {
            continue;
        }
        
        if (self.chartData.count == 0) {
            self.chartData.count = value.count;
        }
        
        for (NSNumber *item in value) {
            if (self.chartData.min > item.floatValue) {
                self.chartData.min = item.floatValue;
            }
            
            if (self.chartData.max < item.floatValue) {
                self.chartData.max = item.floatValue;
            }
        }
    }
    
    if (self.chartData.isYAxisStartFromZero) {
        self.chartData.min = 0.0f;
    }
}

- (void)checkData {
    [super checkData];
    
    NSArray *xValues = self.chartData.xValues;
    NSArray *yValues = self.chartData.yValues;
    
    if (xValues.count && yValues.count) {
        for (NSDictionary *dict in self.chartData.yValues) {
            NSArray  *value = dict[@"value"];
            NSString *color = dict[@"color"];
            
            if (value && color && value.count) {
                self.chartData.noData = NO;
            }
        }
    } else {
        self.chartData.noData = YES;
    }
}

- (void)initChart {
    [super initChart];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat margin = self.chartData.margin;
    
    CGRect  containerFrame  = {{0.0f,         0.0f}, {w,              h}};
    CGRect  maskLViewFrame  = {{0.0f,         0.0f}, {margin,         h - margin}};
    CGRect  maskRViewFrame  = {{w - margin,   0.0f}, {margin,         h - margin}};
    CGRect  dotMarkerFrame  = {{0.0f,         0.0f}, {w - margin * 2, h - margin * 2}};
    CGRect  lineMarkerFrame = {{0.0f,         0.0f}, {w - margin * 2, h - margin * 2}};
    CGRect  indicatorFrame  = {{margin,     margin}, {w - margin * 2, h - margin * 2}};
    
    self.maskLView.frame        = maskLViewFrame;
    self.maskRView.frame        = maskRViewFrame;
    self.indicator.frame        = indicatorFrame;
    self.dotMarker.frame        = dotMarkerFrame;
    self.lineMarker.frame       = lineMarkerFrame;
    self.container.frame        = containerFrame;
    self.container.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    if (self.chartData.isEnabledIndicator == NO &&
        self.chartData.visibleRangeMaxNum != 0  &&
        self.chartData.visibleRangeMaxNum < self.chartData.xValues.count) {
        CGFloat scale = (CGFloat)self.chartData.xValues.count / (CGFloat)self.chartData.visibleRangeMaxNum;
        CGRect  frame = {{0.0f, 0.0f}, {(w - margin * 2) * scale, h - margin * 2}};
        
        self.chartView.frame       = frame;
        self.dotMarker.frame       = frame;
        self.lineMarker.frame      = frame;
        self.container.contentSize = frame.size;
        
        if (self.chartData.chartInitDirection == GLChartInitDirectionLeft) {
            self.container.contentOffset = CGPointMake(-margin, -margin);
        } else {
            self.container.contentOffset = CGPointMake(frame.size.width - (w - margin), -margin);
        }
        
        self.maskLView.hidden = NO;
        self.maskRView.hidden = NO;
    } else {
        CGRect frame = {{0.0f, 0.0f}, {w - margin * 2, h - margin * 2}};
        
        self.chartView.frame       = frame;
        self.container.contentSize = frame.size;
        
        self.maskLView.hidden = YES;
        self.maskRView.hidden = YES;
    }
    
    self.chartView.layer.sublayers = nil;
}

- (void)drawChart {
    [super drawChart];
    
    if (self.chartData.max == 0.0f) {
        self.chartData.scale = 0.0f;
    } else {
        self.chartData.scale = self.chartView.frame.size.height / (self.chartData.max - self.chartData.min);
    }
    
    for (NSDictionary *dict in self.chartData.yValues) {
        NSArray *value = dict[@"value"];
        UIColor *color = [UIColor colorWithHexString:dict[@"color"]];
        
        if (value == nil || color == nil || !value.count) {
            continue;
        }
        
        CGFloat width = [dict[@"width"] floatValue];
        
        if (width == 0.0f) {
            width = self.chartData.lineWidth;
        }
        
        CAShapeLayer *pathLayer = [[CAShapeLayer alloc] init];
        UIBezierPath *pathFrom  = [self getPathWithValue:value scale:0.0f                 close:NO];
        UIBezierPath *pathTo    = [self getPathWithValue:value scale:self.chartData.scale close:NO];
        
        pathLayer.path        = pathTo.CGPath;
        pathLayer.fillColor   = nil;
        pathLayer.lineWidth   = width;
        pathLayer.strokeColor = color.CGColor;
        
        [self.chartView.layer addSublayer:pathLayer];
        
        if (self.chartData.isFill) {
            CAShapeLayer *fillLayer = [[CAShapeLayer alloc] init];
            UIBezierPath *fillFrom  = [self getPathWithValue:value scale:0.0f                 close:YES];
            UIBezierPath *fillTo    = [self getPathWithValue:value scale:self.chartData.scale close:YES];
            
            fillLayer.path        = fillTo.CGPath;
            fillLayer.fillColor   = [color colorWithAlphaComponent:0.25f].CGColor;
            fillLayer.lineWidth   = 0.0f;
            fillLayer.strokeColor = color.CGColor;
            
            [self.chartView.layer addSublayer:fillLayer];
            
            if (self.chartData.animated) {
                [pathLayer addAnimation:[self fillAnimationWithFromValue:(__bridge id)(pathFrom.CGPath) toValue:(__bridge id)(pathTo.CGPath)]
                                 forKey:@"path"];
                [fillLayer addAnimation:[self fillAnimationWithFromValue:(__bridge id)(fillFrom.CGPath) toValue:(__bridge id)(fillTo.CGPath)]
                                 forKey:@"path"];
            }
        } else {
            if (self.chartData.animated) {
                [pathLayer addAnimation:[self pathAnimationWithFromValue:@0 toValue:@1]
                                 forKey:@"path"];
            }
        }
    }
}

- (void)loadComponents {
    [super loadComponents];
    
    if (self.chartData.dots.count) {
        self.dotMarker.hidden    = NO;
        self.dotMarker.chartData = self.chartData;
    } else {
        self.dotMarker.hidden = YES;
    }
    
    if (self.chartData.lines.count) {
        self.lineMarker.hidden    = NO;
        self.lineMarker.chartData = self.chartData;
    } else {
        self.lineMarker.hidden = YES;
    }
    
    if (self.chartData.isEnabledIndicator && !self.chartData.noData) {
        self.indicator.hidden    = NO;
        self.indicator.chartData = self.chartData;
    } else {
        self.indicator.hidden = YES;
    }
}

- (CGPoint)getPointWithValue:(NSArray *)value index:(NSUInteger)index scale:(CGFloat)scale {
    CGFloat x = self.chartView.frame.size.width  / ((value.count >= 2 ? value.count : 2) - 1) * index;
    CGFloat y = self.chartView.frame.size.height - ([value[index] floatValue] - self.chartData.min) * scale;
    
    return CGPointMake(x, y);
}

- (UIBezierPath *)getPathWithValue:(NSArray *)value scale:(CGFloat)scale close:(BOOL)close {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (int i = 0; i < value.count; i++) {
        CGPoint point = [self getPointWithValue:value index:i scale:scale];
        
        if (i == 0) {
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }
    
    if (close) {
        [path addLineToPoint:[self getPointWithValue:value index:value.count - 1 scale:0.0f]];
        [path addLineToPoint:[self getPointWithValue:value index:0 scale:0.0f]];
        [path addLineToPoint:[self getPointWithValue:value index:0 scale:scale]];
    }
    
    return path;
}

- (CABasicAnimation *)fillAnimationWithFromValue:(id)fromValue toValue:(id)toValue {
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    fillAnimation.duration       = self.chartData.duration;
    fillAnimation.fromValue      = fromValue;
    fillAnimation.toValue        = toValue;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return fillAnimation;
}

- (CABasicAnimation *)pathAnimationWithFromValue:(id)fromValue toValue:(id)toValue {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    pathAnimation.duration       = self.chartData.duration;
    pathAnimation.fromValue      = fromValue;
    pathAnimation.toValue        = toValue;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return pathAnimation;
}

#pragma mark - getters and setters

- (UIView *)maskLView {
    if (_maskLView == nil) {
        _maskLView = [[UIView alloc] init];
        
        _maskLView.hidden          = YES;
        _maskLView.backgroundColor = [UIColor whiteColor];
    }
    
    return _maskLView;
}

- (UIView *)maskRView {
    if (_maskRView == nil) {
        _maskRView = [[UIView alloc] init];
        
        _maskRView.hidden          = YES;
        _maskRView.backgroundColor = [UIColor whiteColor];
    }
    
    return _maskRView;
}

- (GLChartDotMarker *)dotMarker {
    if (_dotMarker == nil) {
        _dotMarker = [[GLChartDotMarker alloc] init];
    }
    
    return _dotMarker;
}

- (GLChartLineMarker *)lineMarker {
    if (_lineMarker == nil) {
        _lineMarker = [[GLChartLineMarker alloc] init];
    }
    
    return _lineMarker;
}

- (GLChartIndicator *)indicator {
    if (_indicator == nil) {
        _indicator = [[GLChartIndicator alloc] init];
    }
    
    return _indicator;
}

@end
