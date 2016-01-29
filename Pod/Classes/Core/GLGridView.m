#import "GLGridView.h"
#import "UIColor+Helper.h"
#import "GLChartData.h"

@interface GLGridView ()

@property (nonatomic, strong) CAShapeLayer *gridLayer;

@end

@implementation GLGridView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self.layer addSublayer:self.gridLayer];
    }
    
    return self;
}

#pragma mark - private methods

- (void)drawGrid {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    for (int i = 0; i <= self.data.yStep; i++) {
        CGFloat x = w;
        CGFloat y = h / self.data.yStep * i;
        
        [path moveToPoint:CGPointMake(0.0f, y)];
        [path addLineToPoint:CGPointMake(x, y)];
    }
    
    self.gridLayer.path        = path.CGPath;
    self.gridLayer.lineWidth   = self.data.gridWidth;
    self.gridLayer.strokeColor = [UIColor colorWithHexString:self.data.gridColor].CGColor;
}

- (void)drawXAxisLabel {
    
}

- (void)drawYAxisLabel {
    CGFloat h = self.frame.size.height;
    
    for (int i = 0; i < self.data.yStep; i++) {
        UILabel *label = [[UILabel alloc] init];
        
        CGFloat   value     = self.data.min + (self.data.max - self.data.min) / self.data.yStep * (self.data.yStep - i);
        NSString *labelText = [[NSString alloc] initWithFormat:@"%.2f", value];
        CGSize    labelSize = [labelText sizeWithAttributes:@{@"NSFontAttributeName": [UIFont systemFontOfSize:self.data.labelFontSize]}];
        CGRect    labelRect = {{0.0f, h / self.data.yStep * i}, labelSize};
        
        label.frame     = labelRect;
        label.text      = labelText;
        label.font      = [UIFont systemFontOfSize:self.data.labelFontSize];
        label.textColor = [UIColor colorWithHexString:self.data.labelColor];
        
        [self addSubview:label];
    }
}

#pragma mark - getters and setters

- (CAShapeLayer *)gridLayer {
    if (_gridLayer == nil) {
        _gridLayer = [[CAShapeLayer alloc] init];
    }
    
    return _gridLayer;
}

- (void)setData:(GLChartData *)data {
    _data = data;
    
    [self drawGrid];
    [self drawXAxisLabel];
    [self drawYAxisLabel];
}

@end
