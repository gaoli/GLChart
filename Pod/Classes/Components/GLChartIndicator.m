#import "GLChartIndicator.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"

static CGFloat const kTipsRectW   = 2.0f;
static CGFloat const kTipsRectH   = 7.0f;
static CGFloat const kTipsPadding = 5.0f;
static CGFloat const kTipsYOffset = 24.0f;

@interface GLChartIndicator () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView                 *wrapView;
@property (nonatomic, strong) UIView                 *tipsView;
@property (nonatomic, strong) CAShapeLayer           *lineLayer;
@property (nonatomic, strong) NSMutableArray         *dotLayers;
@property (nonatomic, strong) UILabel                *timeLabel;
@property (nonatomic, strong) NSMutableArray         *numLabels;
@property (nonatomic, assign) CGFloat                 lastX;
@property (nonatomic, assign) CGFloat                 lastY;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation GLChartIndicator

- (id)init {
    self = [super init];
    
    if (self) {
        
        // 添加子类视图
        [self addSubview:self.wrapView];
        [self addSubview:self.tipsView];
        
        // 添加手势响应
        [self addGestureRecognizer:self.panGestureRecognizer];
    }
    
    return self;
}

#pragma mark - event response

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    // 拖拽已经开始
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.wrapView.hidden = NO;
        self.tipsView.hidden = NO;
        
    // 拖拽正在进行
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        // 获取偏移数值
        CGFloat x = [recognizer locationInView:self].x;
        CGFloat y = [recognizer locationInView:self].y;
        
        // 纠正偏移数值
        x = x < 0 ? 0 : x;
        x = x > w ? w : x;
        y = y < 0 ? 0 : y;
        y = y > h ? h : y;
        
        NSUInteger count = self.chartData.count;
        CGFloat    width = w / ((count >= 2 ? count : 2) - 1);
        NSUInteger index = x / width;
        
        if (index < count) {
            x = index * width;
            
            [self drawLine:CGPointMake(x, y) index:index];
            [self drawDots:CGPointMake(x, y) index:index];
        }
        
    // 拖拽已经结束
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.wrapView.hidden = YES;
        self.tipsView.hidden = YES;
    }
}

#pragma mark - private methods

- (void)resetComponent {
    for (UIView *view in self.tipsView.subviews) {
        [view removeFromSuperview];
    }
    
    self.wrapView.layer.sublayers = nil;
    
    self.lastX     = 0.0f;
    self.lastY     = 0.0f;
    self.lineLayer = nil;
    self.timeLabel = nil;
    self.dotLayers = [NSMutableArray array];
    self.numLabels = [NSMutableArray array];
}

- (void)createTipsView {
    CGFloat   labelFontSize  = self.chartData.indicatorLabelFontSize;
    NSString *labelTextColor = self.chartData.indicatorLabelTextColor;
    
    NSString *labelText = @"11:11";
    CGSize    labelSize = [labelText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:labelFontSize]}];
    
    CGFloat   numLabelX = 0.0f;
    CGFloat   tipsViewH = 0.0f;
    
    tipsViewH += kTipsPadding;
    tipsViewH += labelSize.height;
    
    self.timeLabel.frame = CGRectMake(kTipsPadding, kTipsPadding, 0.0f, labelSize.height);
    
    [self.tipsView addSubview:self.timeLabel];
    
    for (int i = 0; i < self.chartData.yValues.count; i++) {
        NSDictionary *dict  = self.chartData.yValues[i];
        NSString     *alias = dict[@"alias"];
        NSArray      *value = dict[@"value"];
        UIColor      *color = [UIColor colorWithHexString:dict[@"color"]];
        
        if (value == nil || value.count == 0 || color == nil) {
            continue;
        }
        
        if (color) {
            CGRect  rectViewFrame = {{kTipsPadding, tipsViewH + (labelSize.height - kTipsRectH) / 2}, {kTipsRectW, kTipsRectH}};
            UIView *rectView      = [[UIView  alloc] initWithFrame:rectViewFrame];
            
            rectView.backgroundColor = color;
            
            [self.tipsView addSubview:rectView];
            
            if (numLabelX < kTipsRectW + kTipsPadding * 2) {
                numLabelX = kTipsRectW + kTipsPadding * 2;
            }
        }
        
        if (alias) {
            NSString *aliasLabelText = alias;
            CGSize    aliasLabelSize = [aliasLabelText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:labelFontSize]}];
            
            CGFloat aliasLabelW = aliasLabelSize.width;
            CGFloat aliasLabelH = aliasLabelSize.height;
            
            if (aliasLabelW > self.chartData.indicatorAliasLabelMaxWidth && self.chartData.indicatorAliasLabelMaxWidth != 0) {
                aliasLabelW = self.chartData.indicatorAliasLabelMaxWidth;
            }
            
            CGRect   aliasLabelFrame = {{kTipsRectW + kTipsPadding * 2, tipsViewH}, {aliasLabelW, aliasLabelH}};
            UILabel *aliasLabel      = [[UILabel alloc] initWithFrame:aliasLabelFrame];
            
            aliasLabel.text      = aliasLabelText;
            aliasLabel.font      = [UIFont  systemFontOfSize  :labelFontSize];
            aliasLabel.textColor = [UIColor colorWithHexString:labelTextColor];
            
            [self.tipsView addSubview:aliasLabel];
            
            if (numLabelX < kTipsRectW + aliasLabelW + kTipsPadding * 3) {
                numLabelX = kTipsRectW + aliasLabelW + kTipsPadding * 3;
            }
        }
        
        CGRect   numLabelFrame = {{0.0f, tipsViewH}, {0.0f, labelSize.height}};
        UILabel *numLabel      = [[UILabel alloc] initWithFrame:numLabelFrame];
        
        numLabel.font      = [UIFont  systemFontOfSize  :labelFontSize];
        numLabel.textColor = [UIColor colorWithHexString:labelTextColor];
        
        [self.numLabels addObject:numLabel];
        [self.tipsView addSubview:numLabel];
        
        tipsViewH += labelSize.height;
    }
    
    tipsViewH += kTipsPadding;
    
    for (UILabel *numLabel in self.numLabels) {
        numLabel.frame = CGRectMake(numLabelX,
                                    numLabel.frame.origin.y,
                                    numLabel.frame.size.width,
                                    numLabel.frame.size.height);
    }
    
    self.tipsView.frame             = CGRectMake(0.0f, (self.frame.size.height - tipsViewH) / 2, 0.0f, tipsViewH);
    self.tipsView.layer.borderColor = [UIColor colorWithHexString:self.chartData.indicatorBorderColor].CGColor;
    
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

- (void)drawLine:(CGPoint)point index:(NSUInteger)index {
    CGFloat h = self.frame.size.height;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(point.x, 0.0f)];
    [path addLineToPoint:CGPointMake(point.x, h)];
    
    self.lineLayer.path = path.CGPath;
}

- (void)drawDots:(CGPoint)point index:(NSUInteger)index {
    CGFloat h = self.frame.size.height;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < self.chartData.yValues.count; i++) {
        NSDictionary *dict  = self.chartData.yValues[i];
        NSArray      *value = dict[@"value"];
        UIColor      *color = [UIColor colorWithHexString:dict[@"color"]];
        
        if (value == nil || color == nil) {
            continue;
        }
        
        if (index < value.count) {
            UIBezierPath *path = [[UIBezierPath alloc] init];
            
            [path addArcWithCenter:CGPointMake(point.x, h - ([value[index] floatValue] - self.chartData.min) * self.chartData.scale)
                            radius:1.5f
                        startAngle:0.0f
                          endAngle:2 * M_PI
                         clockwise:YES];
            
            [array addObject:value[index]];
            
            [(CAShapeLayer *)self.dotLayers[i] setPath:path.CGPath];
        }
    }
    
    [self drawTipsWithData:@{@"index": @(index), @"value": array} point:point];
}

- (void)drawTipsWithData:(NSDictionary *)data point:(CGPoint)point {
    NSNumber  *index = data[@"index"];
    NSArray   *value = data[@"value"];
    
    CGFloat   tipsViewWidth = 0.0f;
    CGFloat   labelFontSize = self.chartData.indicatorLabelFontSize;
    
    NSString *timeLabelText = self.chartData.xValues[index.integerValue];
    CGSize    timeLabelSize = [timeLabelText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:labelFontSize]}];
    
    tipsViewWidth = timeLabelSize.width + kTipsPadding * 2;
    
    self.timeLabel.frame = CGRectMake(self.timeLabel.frame.origin.x,
                                      self.timeLabel.frame.origin.y,
                                      timeLabelSize.width,
                                      timeLabelSize.height);
    
    self.timeLabel.text  = timeLabelText;
    
    for (int i = 0; i < value.count; i++) {
        
        NSString *labelText = [[NSString alloc] initWithFormat:@"%@", value[i]];
        CGSize    labelSize = [labelText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:labelFontSize]}];
        
        UILabel *numLabel = self.numLabels[i];
        
        numLabel.text  = labelText;
        numLabel.frame = CGRectMake(numLabel.frame.origin.x, numLabel.frame.origin.y, labelSize.width, labelSize.height);
        
        if (tipsViewWidth < numLabel.frame.origin.x + labelSize.width + kTipsPadding) {
            tipsViewWidth = numLabel.frame.origin.x + labelSize.width + kTipsPadding;
        }
    }
    
    CGRect tipsViewFrame = self.tipsView.frame;
    
    tipsViewFrame.size.width = tipsViewWidth;
    
    if (point.x < self.frame.size.width - tipsViewFrame.size.width) {
        tipsViewFrame.origin.x = point.x + kTipsPadding;
    } else {
        tipsViewFrame.origin.x = point.x - kTipsPadding - tipsViewFrame.size.width;
    }
    
    if (point.y < kTipsPadding + tipsViewFrame.size.height + kTipsYOffset) {
        tipsViewFrame.origin.y = kTipsPadding;
    } else {
        tipsViewFrame.origin.y = point.y - kTipsPadding - tipsViewFrame.size.height - kTipsYOffset;
    }
    
    self.tipsView.frame = tipsViewFrame;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:NSClassFromString(@"UIGestureRecognizer")] &&
        [gestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] == NO) {
        CGPoint p = [gestureRecognizer locationInView:self];
        CGFloat x = p.x;
        CGFloat y = p.y;
        
        CGFloat offsetX = fabs(self.lastX - x);
        CGFloat offsetY = fabs(self.lastY - y);
        
        self.lastX = 0.0f;
        self.lastY = 0.0f;
        
        if (offsetX > offsetY) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self];
    CGFloat x = p.x;
    CGFloat y = p.y;
    
    self.lastX = x;
    self.lastY = y;
    
    if ([gestureRecognizer      isKindOfClass:NSClassFromString(@"UIGestureRecognizer")] &&
        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - getters and setters

- (void)setChartData:(GLChartData *)chartData {
    _chartData = chartData;
    
    [self resetComponent];
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
        
        _timeLabel.font      = [UIFont  systemFontOfSize  :self.chartData.indicatorLabelFontSize];
        _timeLabel.textColor = [UIColor colorWithHexString:self.chartData.indicatorLabelTextColor];
    }
    
    return _timeLabel;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        
        _panGestureRecognizer.delegate = self;
    }
    
    return _panGestureRecognizer;
}

@end
