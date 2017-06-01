#import "GLChartLineMarker.h"
#import "GLChartData.h"
#import "UIColor+Helper.h"

@implementation GLChartLineMarker

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

- (void)drawLines:(NSArray *)values color:(UIColor *)color width:(CGFloat)width {
    UIBezierPath *path      = [UIBezierPath bezierPath];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    
    for (NSString *value in values) {
        NSUInteger index = [self.chartData.xValues indexOfObject:value];
        
        if (index < self.chartData.xValues.count) {
            CGFloat x = 0.0f;
            CGFloat y = 0.0f;
            
            // 计算线条坐标
            x = [self getPointX:index];
            
            CGPoint pointStart = {x, y};
            
            y = self.frame.size.height;
            
            CGPoint pointEnd   = {x, y};
            
            // 绘制线条标记
            [path moveToPoint:pointStart];
            [path addLineToPoint:pointEnd];
        }
    }
    
    pathLayer.path        = path.CGPath;
    pathLayer.strokeColor = color.CGColor;
    pathLayer.fillColor   = nil;
    pathLayer.lineWidth   = width;
    
    [self.layer addSublayer:pathLayer];
}

#pragma mark - getters and setters

- (void)setChartData:(GLChartData *)chartData {
    _chartData = chartData;
    
    [self resetComponent];
    
    for (NSDictionary *item in chartData.lines) {
        NSArray *value = item[@"value"];
        UIColor *color = [UIColor colorWithHexString:item[@"color"]];
        CGFloat  width = [item[@"width"] floatValue];
        
        [self drawLines:value color:color width:width];
    }
};

@end
