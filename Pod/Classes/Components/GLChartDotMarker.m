#import "GLChartDotMarker.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"

@implementation GLChartDotMarker

- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

#pragma mark - private methods

- (void)resetComponent {
    self.layer.sublayers = nil;
}

- (CGFloat)getPointX:(NSUInteger)index {
    NSUInteger count = self.chartData.xValues.count;
    
    return self.frame.size.width / ((count >= 2 ? count : 2) - 1) * index;
}

- (CGFloat)getPointY:(CGFloat)position {
    return self.frame.size.height * (1 - position);
}

- (void)drawDots:(NSArray *)values color:(UIColor *)color size:(CGFloat)size position:(CGFloat)position {
    CGFloat x = 0.0f;
    CGFloat y = [self getPointY:position];
    
    UIBezierPath *path      = [UIBezierPath bezierPath];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    
    for (NSString *value in values) {
        CGPoint    point = {x, y};
        NSUInteger index = [self.chartData.xValues indexOfObject:value];
        
        if (index < self.chartData.xValues.count) {
            
            // 更新圆点坐标
            point.x = [self getPointX:index];
            
            // 绘制圆点标记
            [path addArcWithCenter:point radius:size / 2 startAngle:0.0f endAngle:M_PI * 2 clockwise:YES];
        }
    }
    
    pathLayer.path      = path.CGPath;
    pathLayer.fillColor = color.CGColor;
    pathLayer.lineWidth = 0.0f;
    
    [self.layer addSublayer:pathLayer];
}

#pragma mark - getters and setters

- (void)setChartData:(GLChartData *)chartData {
    _chartData = chartData;
    
    [self resetComponent];
    
    for (NSDictionary *item in chartData.dots) {
        NSArray *value    = item[@"value"];
        UIColor *color    = [UIColor colorWithHexString:item[@"color"]];
        CGFloat  size     = [item[@"size"]     floatValue];
        CGFloat  position = [item[@"position"] floatValue];
        
        [self drawDots:value color:color size:size position:position];
    }
};

@end
