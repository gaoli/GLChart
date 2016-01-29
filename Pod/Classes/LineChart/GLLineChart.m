#import "GLLineChart.h"
#import "UIColor+Helper.h"
#import "GLChartData.h"
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
        
        CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
        
        lineLayer.path        = [self getPathWithValue:value scale:scale close:YES].CGPath;
        lineLayer.lineWidth   = self.data.lineWidth;
        lineLayer.fillColor   = nil;
        lineLayer.strokeColor = color.CGColor;
        
        [self.layer addSublayer:lineLayer];
    }
}

- (UIBezierPath *)getPathWithValue:(NSArray *)value scale:(CGFloat)scale close:(BOOL)close {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    for (int i = 0; i < value.count; i++) {
        CGFloat x = w / (value.count - 1) * i;
        CGFloat y = h - scale * [value[i] floatValue];
        CGPoint p = {x, y};
        
        if (i == 0) {
            [path moveToPoint:p];
        } else {
            [path addLineToPoint:p];
        }
    }
    
    if (close) {
        
    }
    
    return path;
}

#pragma mark - getters and setters

- (GLGridView *)gridView {
    if (_gridView == nil) {
        _gridView = [[GLGridView alloc] initWithFrame:self.bounds];
    }
    
    return _gridView;
}

- (void)setData:(GLChartData *)data {
    _data = data;
    
    [self getValueRange];
    [self drawLineChart];
    
    self.gridView.data = data;
}

@end
