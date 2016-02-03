#import "GLLineChart.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"

@interface GLLineChart ()

@end

@implementation GLLineChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
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
        
        for (NSNumber *item in value) {
            if (self.chartData.min > item.floatValue) {
                self.chartData.min = item.floatValue;
            }
            
            if (self.chartData.max < item.floatValue) {
                self.chartData.max = item.floatValue;
            }
        }
    }
}

- (void)drawChart {
    [super drawChart];
    
    self.chartData.scale = self.chartView.frame.size.height / (self.chartData.max - self.chartData.min);
    
    for (NSDictionary *dict in self.chartData.yValues) {
        NSArray *value = dict[@"value"];
        UIColor *color = [UIColor colorWithHexString:dict[@"color"]];
        
        if (value == nil || color == nil) {
            continue;
        }
        
        CAShapeLayer *pathLayer = [[CAShapeLayer alloc] init];
        UIBezierPath *pathFrom  = [self getPathWithValue:value scale:0.0f                 close:NO];
        UIBezierPath *pathTo    = [self getPathWithValue:value scale:self.chartData.scale close:NO];
        
        pathLayer.path        = pathTo.CGPath;
        pathLayer.fillColor   = nil;
        pathLayer.lineWidth   = self.chartData.lineWidth;
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

- (CGPoint)getPointWithValue:(NSArray *)value index:(NSUInteger)index scale:(CGFloat)scale {
    CGFloat w = self.chartView.frame.size.width;
    CGFloat h = self.chartView.frame.size.height;
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

@end
