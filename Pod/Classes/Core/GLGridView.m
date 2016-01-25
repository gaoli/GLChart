#import "GLGridView.h"

@interface GLGridView ()

@property (nonatomic, strong) CAShapeLayer *gridLayer;

@end

@implementation GLGridView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 设置默认参数
        self.min        =  FLT_MAX;
        self.max        = -FLT_MAX;
        self.lineWidth  = 0.5f;
        self.lineColor  = [UIColor lightGrayColor];
        self.labelFont  = [UIFont systemFontOfSize:9.0f];
        self.labelColor = [UIColor lightGrayColor];
        
        // 添加子类图层
        [self.layer addSublayer:self.gridLayer];
    }
    
    return self;
}

#pragma mark - private methods

- (void)getYValueRange {
    for (id item in self.data) {
        CGFloat value = [item floatValue];
        
        if (self.min > value) {
            self.min = value;
        }
        
        if (self.max < value) {
            self.max = value;
        }
    }
}

- (void)drawGrid {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    for (int i = 0; i <= self.step; i++) {
        CGFloat x = w;
        CGFloat y = h / self.step * i;
        
        [path moveToPoint:CGPointMake(0.0f, y)];
        [path addLineToPoint:CGPointMake(x, y)];
    }
    
    self.gridLayer.path = path.CGPath;
}

- (void)drawYAxisLabel {
    CGFloat h = self.frame.size.height;
    
    for (int i = 0; i < self.step; i++) {
        UILabel *label = [[UILabel alloc] init];
        
        CGFloat   value     = self.min + (self.max - self.min) / self.step * (self.step - i);
        NSString *labelText = [[NSString alloc] initWithFormat:@"%.2f", value];
        CGSize    labelSize = [labelText sizeWithAttributes:@{@"NSFontAttributeName": self.labelFont}];
        CGRect    labelRect = {{0.0f, h / self.step * i}, labelSize};
        
        label.frame     = labelRect;
        label.text      = labelText;
        label.font      = self.labelFont;
        label.textColor = self.labelColor;
        
        [self addSubview:label];
    }
}

#pragma mark - getters and setters

- (CAShapeLayer *)gridLayer {
    if (_gridLayer == nil) {
        _gridLayer = [[CAShapeLayer alloc] init];
        
        _gridLayer.lineWidth   = self.lineWidth;
        _gridLayer.strokeColor = self.lineColor.CGColor;
    }
    
    return _gridLayer;
}

- (void)setStep:(NSUInteger)step {
    _step = step;
    
    [self drawGrid];
}

- (void)setData:(NSArray *)data {
    _data = data;
    
    [self getYValueRange];
    [self drawYAxisLabel];
}

@end
