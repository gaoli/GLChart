#import "GLLineChart.h"
#import "GLLineChartData.h"
#import "UIColor+Helper.h"
#import "GLGridView.h"

@interface GLLineChart ()

@property (nonatomic, strong) GLGridView *gridView;

@end

@implementation GLLineChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 添加子类视图
        [self addSubview:self.gridView];
    }
    
    return self;
}

#pragma mark - private methods

- (void)getValueRange {
    for (NSDictionary *dict in self.data.yValues) {
        NSArray *value = dict[@"value"];
        UIColor *color = [UIColor colorWithHexString:dict[@"color"]];
        
        if (value == nil || color == nil) {
            continue;
        }
        
        for (NSNumber *item in value) {
            if (self.data.min > item.floatValue) {
                self.data.min = item.floatValue;
            }
            
            if (self.data.max < item.floatValue) {
                self.data.max = item.floatValue;
            }
        }
    }
}

- (void)drawLineChart {
    CGFloat scale = self.frame.size.height / (self.data.max - self.data.min);
    
    for (NSDictionary *dict in self.data.yValues) {
        NSArray *value = dict[@"value"];
        UIColor *color = [UIColor colorWithHexString:dict[@"color"]];
        
        if (value == nil || color == nil) {
            continue;
        }
        
        CAShapeLayer *pathLayer = [[CAShapeLayer alloc] init];
        UIBezierPath *pathFrom  = [self getPathWithValue:value scale:0.0f  close:NO];
        UIBezierPath *pathTo    = [self getPathWithValue:value scale:scale close:NO];
        
        pathLayer.path        = pathTo.CGPath;
        pathLayer.fillColor   = nil;
        pathLayer.lineWidth   = self.data.lineWidth;
        pathLayer.strokeColor = color.CGColor;
        
        [self.layer addSublayer:pathLayer];
        
        if (self.data.isFill) {
            CAShapeLayer *fillLayer = [[CAShapeLayer alloc] init];
            UIBezierPath *fillFrom  = [self getPathWithValue:value scale:0.0f  close:YES];
            UIBezierPath *fillTo    = [self getPathWithValue:value scale:scale close:YES];
            
            fillLayer.path        = fillTo.CGPath;
            fillLayer.fillColor   = [color colorWithAlphaComponent:0.25f].CGColor;
            fillLayer.lineWidth   = 0.0f;
            fillLayer.strokeColor = color.CGColor;
            
            [self.layer addSublayer:fillLayer];
            
            if (self.data.animated) {
                [pathLayer addAnimation:[self fillAnimationWithFromValue:(__bridge id)(pathFrom.CGPath) toValue:(__bridge id)(pathTo.CGPath)]
                                 forKey:@"path"];
                [fillLayer addAnimation:[self fillAnimationWithFromValue:(__bridge id)(fillFrom.CGPath) toValue:(__bridge id)(fillTo.CGPath)]
                                 forKey:@"path"];
            }
        } else {
            if (self.data.animated) {
                [pathLayer addAnimation:[self pathAnimationWithFromValue:@0 toValue:@1]
                                 forKey:@"path"];
            }
        }
    }
}

- (CGPoint)getPointWithValue:(NSArray *)value index:(NSUInteger)index scale:(CGFloat)scale {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat x = w / (value.count - 1) * index;
    CGFloat y = h - scale * [value[index] floatValue];
    
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
    
    fillAnimation.duration       = self.data.duration;
    fillAnimation.fromValue      = fromValue;
    fillAnimation.toValue        = toValue;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return fillAnimation;
}

- (CABasicAnimation *)pathAnimationWithFromValue:(id)fromValue toValue:(id)toValue {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    pathAnimation.duration       = self.data.duration;
    pathAnimation.fromValue      = fromValue;
    pathAnimation.toValue        = toValue;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return pathAnimation;
}

#pragma mark - getters and setters

- (GLGridView *)gridView {
    if (_gridView == nil) {
        _gridView = [[GLGridView alloc] initWithFrame:self.bounds];
    }
    
    return _gridView;
}

- (void)setData:(GLLineChartData *)data {
    _data = data;
    
    [self getValueRange];
    [self drawLineChart];
    
    self.gridView.data = data;
}

@end
