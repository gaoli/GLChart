#import "GLChartIndicator.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"

@interface GLChartIndicator ()

@property (nonatomic, strong) UIView                 *wrapView;
@property (nonatomic, strong) UIView                 *tipsView;
@property (nonatomic, strong) CAShapeLayer           *lineLayer;
@property (nonatomic, strong) NSMutableArray         *dotLayers;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation GLChartIndicator

- (id)init {
    self = [super init];
    
    if (self) {
        self.dotLayers = [NSMutableArray array];
        
        // 添加子类视图
        [self addSubview:self.wrapView];
        [self addSubview:self.tipsView];
        
        // 添加手势响应
        [self addGestureRecognizer:self.panGestureRecognizer];
    }
    
    return self;
}

#pragma mark - event response

- (void)createLineLayer {
    self.lineLayer.lineWidth   = self.chartData.indicatorLineWidth;
    self.lineLayer.strokeColor = [UIColor colorWithHexString:self.chartData.indicatorLineColor].CGColor;
    
    [self.wrapView.layer addSublayer:self.lineLayer];
}

- (void)createdotLayers {
    for (NSDictionary *dict in self.chartData.yValues) {
        NSArray *value = dict[@"value"];
        UIColor *color = [UIColor colorWithHexString:dict[@"color"]];
        
        if (value == nil || color == nil) {
            continue;
        }
        
        CAShapeLayer *dotLayer = [[CAShapeLayer alloc] init];
        
        dotLayer.fillColor   = color.CGColor;
        dotLayer.lineWidth   = self.chartData.indicatorLineWidth;
        dotLayer.strokeColor = color.CGColor;
        
        [self.dotLayers      addObject:  dotLayer];
        [self.wrapView.layer addSublayer:dotLayer];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    // 拖拽已经开始
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.wrapView.hidden = NO;
        self.tipsView.hidden = NO;
        
    // 拖拽正在进行
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        // 获取偏移数值
        CGFloat w = self.frame.size.width;
        CGFloat x = [recognizer locationInView:self].x;
        
        // 纠正偏移数值
        x = x < 0 ? 0 : x;
        x = x > w ? w : x;
        
        [self drawLine:x];
        [self drawDots:x];
        [self drawTips:x];
        
    // 拖拽已经结束
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.wrapView.hidden = YES;
        self.tipsView.hidden = YES;
    }
}

- (void)drawLine:(CGFloat)x {
    CGFloat h = self.frame.size.height;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(x, 0.0f)];
    [path addLineToPoint:CGPointMake(x, h)];
    
    self.lineLayer.path = path.CGPath;
}

- (void)drawDots:(CGFloat)x {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    for (int i = 0; i < self.chartData.yValues.count; i++) {
        NSDictionary *dict  = self.chartData.yValues[i];
        NSArray      *value = dict[@"value"];
        NSString     *color = dict[@"color"];
        
        if (value == nil || color == nil) {
            continue;
        }
        
        NSUInteger count = value.count;
        NSUInteger index = x / (w / count);
        
        if (index < value.count) {
            UIBezierPath *path = [[UIBezierPath alloc] init];
            
            [path addArcWithCenter:CGPointMake(x, h - [value[index] floatValue] * self.chartData.scale)
                            radius:1.5f
                        startAngle:0.0f
                          endAngle:2 * M_PI
                         clockwise:YES];
            
            [(CAShapeLayer *)self.dotLayers[i] setPath:path.CGPath];
        }
    }
}

- (void)drawTips:(CGFloat)x {
    
}

#pragma mark - getters and setters

- (void)setChartData:(GLChartData *)chartData {
    _chartData = chartData;
    
    [self createLineLayer];
    [self createdotLayers];
};

- (UIView *)wrapView {
    if (_wrapView == nil) {
        _wrapView = [[UIView alloc] initWithFrame:self.bounds];
        
        _wrapView.hidden = YES;
    }
    
    return _wrapView;
}

- (UIView *)tipsView {
    if (_tipsView == nil) {
        _tipsView = [[UIView alloc] init];
        
        _tipsView.hidden = YES;
    }
    
    return _tipsView;
}

- (CAShapeLayer *)lineLayer {
    if (_lineLayer == nil) {
        _lineLayer = [[CAShapeLayer alloc] init];
    }
    
    return _lineLayer;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    
    return _panGestureRecognizer;
}

@end
