#import "GLChartIndicator.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"

static CGFloat const kTipsPadding = 5.0f;
static CGFloat const kTipsRectW   = 8.0f;
static CGFloat const kTipsRectH   = 4.0f;

@interface GLChartIndicator ()

@property (nonatomic, strong) UIView                 *wrapView;
@property (nonatomic, strong) UIView                 *tipsView;
@property (nonatomic, strong) CAShapeLayer           *lineLayer;
@property (nonatomic, strong) NSMutableArray         *dotLayers;
@property (nonatomic, strong) UILabel                *timeLabel;
@property (nonatomic, strong) NSMutableArray         *numLabels;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation GLChartIndicator

- (id)init {
    self = [super init];
    
    if (self) {
        self.dotLayers = [NSMutableArray array];
        self.numLabels = [NSMutableArray array];
        
        // 添加子类视图
        [self addSubview:self.wrapView];
        [self addSubview:self.tipsView];
        
        // 添加手势响应
        [self addGestureRecognizer:self.panGestureRecognizer];
    }
    
    return self;
}

#pragma mark - event response

- (void)createTipsView {
    CGFloat   labelFontSize  = self.chartData.labelFontSize;
    NSString *labelTextColor = self.chartData.labelTextColor;
    
    NSString *labelText = @"11:11";
    CGSize    labelSize = [labelText sizeWithAttributes:@{@"NSFontAttributeName": [UIFont systemFontOfSize:labelFontSize]}];
    CGFloat   tipsViewH = kTipsPadding * 2 + labelSize.height * (self.chartData.yValues.count + 1);
    
    self.timeLabel.frame = CGRectMake(kTipsPadding, kTipsPadding, 0.0f, labelSize.height);
    
    [self.tipsView addSubview:self.timeLabel];
    
    for (int i = 0; i < self.chartData.yValues.count; i++) {
        NSDictionary *dict  = self.chartData.yValues[i];
        NSArray      *value = dict[@"value"];
        UIColor      *color = [UIColor colorWithHexString:dict[@"color"]];
        
        if (value == nil || color == nil) {
            continue;
        }
        
        CGRect   rectViewFrame = {{kTipsPadding, kTipsPadding + labelSize.height * (i + 1) + (labelSize.height - kTipsRectH) / 2},
                                  {kTipsRectW, kTipsRectH}};
        CGRect   numLabelFrame = {{kTipsPadding * 2 + kTipsRectW, kTipsPadding + labelSize.height * (i + 1)},
                                  {0.0f, labelSize.height}};
        
        UIView  *rectView = [[UIView  alloc] initWithFrame:rectViewFrame];
        UILabel *numLabel = [[UILabel alloc] initWithFrame:numLabelFrame];
        
        rectView.backgroundColor = color;
        
        numLabel.font      = [UIFont  systemFontOfSize  :labelFontSize];
        numLabel.textColor = [UIColor colorWithHexString:labelTextColor];
        
        [self.numLabels addObject:numLabel];
        [self.tipsView addSubview:rectView];
        [self.tipsView addSubview:numLabel];
    }
    
    self.tipsView.frame = CGRectMake(0.0f, (self.frame.size.height - tipsViewH) / 2, 0.0f, tipsViewH);
    
    [self addSubview:self.tipsView];
}

- (void)createLineLayer {
    self.lineLayer.lineWidth   = self.chartData.indicatorLineWidth;
    self.lineLayer.strokeColor = [UIColor colorWithHexString:self.chartData.indicatorLineColor].CGColor;
    
    [self.wrapView.layer addSublayer:self.lineLayer];
}

- (void)createDotLayers {
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
    CGFloat         w    = self.frame.size.width;
    CGFloat         h    = self.frame.size.height;
    
    NSUInteger      index = 0;
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < self.chartData.yValues.count; i++) {
        NSDictionary *dict  = self.chartData.yValues[i];
        NSArray      *value = dict[@"value"];
        UIColor      *color = [UIColor colorWithHexString:dict[@"color"]];
        
        if (value == nil || color == nil) {
            continue;
        }
        
        index = x / (w / value.count);
        
        if (index < value.count) {
            UIBezierPath *path = [[UIBezierPath alloc] init];
            
            [path addArcWithCenter:CGPointMake(x, h - [value[index] floatValue] * self.chartData.scale)
                            radius:1.5f
                        startAngle:0.0f
                          endAngle:2 * M_PI
                         clockwise:YES];
            
            [array addObject:value[index]];
            
            [(CAShapeLayer *)self.dotLayers[i] setPath:path.CGPath];
        }
    }
    
    [self drawTipsWithData:@{@"index": @(index), @"value": array}
                         x:x];
}

- (void)drawTipsWithData:(NSDictionary *)data x:(CGFloat)x {
    NSNumber  *index = data[@"index"];
    NSArray   *value = data[@"value"];
    
    CGFloat   labelMaxWidth = 0.0f;
    CGFloat   labelFontSize = self.chartData.labelFontSize;
    
    NSString *timeLabelText = self.chartData.xValues[index.integerValue];
    CGSize    timeLabelSize = [timeLabelText sizeWithAttributes:@{@"NSFontAttributeName": [UIFont systemFontOfSize:labelFontSize]}];
    
    labelMaxWidth = timeLabelSize.width;
    
    self.timeLabel.frame = CGRectMake(self.timeLabel.frame.origin.x,
                                      self.timeLabel.frame.origin.y,
                                      timeLabelSize.width,
                                      timeLabelSize.height);
    
    self.timeLabel.text  = timeLabelText;
    
    for (int i = 0; i < value.count; i++) {
        NSString *labelText = [[NSString alloc] initWithFormat:@"%.2f", [value[i] floatValue]];
        CGSize    labelSize = [labelText sizeWithAttributes:@{@"NSFontAttributeName": [UIFont systemFontOfSize:labelFontSize]}];
        
        if (labelMaxWidth < labelSize.width) {
            labelMaxWidth = labelSize.width;
        }
        
        UILabel *numLabel = self.numLabels[i];
        
        numLabel.frame = CGRectMake(numLabel.frame.origin.x,
                                    numLabel.frame.origin.y,
                                    labelSize.width,
                                    labelSize.height);
        
        numLabel.text  = labelText;
    }
    
    CGRect frame = self.tipsView.frame;
    
    frame.size.width = kTipsPadding * 2 + kTipsRectW + labelMaxWidth;
    
    if (self.frame.size.width - x > frame.size.width) {
        frame.origin.x = x + kTipsPadding;
    } else {
        frame.origin.x = x - kTipsPadding - frame.size.width;
    }
    
    self.tipsView.frame = frame;
}

#pragma mark - getters and setters

- (void)setChartData:(GLChartData *)chartData {
    _chartData = chartData;

    [self createTipsView];
    [self createLineLayer];
    [self createDotLayers];
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
        
        _tipsView.hidden              = YES;
        _tipsView.backgroundColor     = [UIColor whiteColor];
        
        _tipsView.layer.borderWidth   = 0.5f;
        _tipsView.layer.borderColor   = [UIColor colorWithHexString:@"#7DB9FF"].CGColor;
        _tipsView.layer.cornerRadius  = 4.0f;
        _tipsView.layer.masksToBounds = YES;
    }
    
    return _tipsView;
}

- (CAShapeLayer *)lineLayer {
    if (_lineLayer == nil) {
        _lineLayer = [[CAShapeLayer alloc] init];
    }
    
    return _lineLayer;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        
        _timeLabel.font      = [UIFont  systemFontOfSize  :self.chartData.labelFontSize];
        _timeLabel.textColor = [UIColor colorWithHexString:self.chartData.labelTextColor];
    }
    
    return _timeLabel;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    
    return _panGestureRecognizer;
}

@end
