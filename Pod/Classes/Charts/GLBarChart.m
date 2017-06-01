#import "GLBarChart.h"
#import "GLChartData.h"
#import "GLBar.h"
#import "UIColor+Helper.h"

@implementation GLBarChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self.container addSubview:self.chartView];
    }
    
    return self;
}

#pragma mark - private methods

- (void)parseData {
    [super parseData];
    
    self.chartData.min = 0.0f;
    
    [self getYValueRange];
}

- (void)checkData {
    [super checkData];
    
    NSArray *xValues = self.chartData.xValues;
    NSArray *yValues = self.chartData.yValues;
    
    [self getYValueGrade];
    
    if (xValues.count && yValues.count) {
        self.chartData.noData = NO;
    } else {
        self.chartData.noData = YES;
    }
}

- (void)initChart {
    [super initChart];
    
    CGFloat  w = self.frame.size.width;
    CGFloat  h = self.frame.size.height;
    
    NSArray *values = self.chartData.xValues;
    
    CGFloat  margin    = self.chartData.margin;
    CGFloat  barWidth  = self.chartData.barWidth;
    CGFloat  barMargin = self.chartData.barMargin;
    
    CGFloat contentWidth  = (barWidth + barMargin * 2) * values.count;
    CGFloat contentHeight = h - margin * 2;
    
    if (contentWidth < w - margin * 2) {
        contentWidth = w - margin * 2;
    }
    
    CGRect frame = {{0.0f, 0.0f}, {contentWidth, contentHeight}};
    
    self.chartView.frame       = frame;
    self.container.contentSize = frame.size;
    
    if (self.chartData.chartInitDirection == GLChartInitDirectionLeft) {
        self.container.contentOffset = CGPointMake(0.0f, 0.0f);
    } else {
        self.container.contentOffset = CGPointMake(contentWidth - (w - margin * 2), 0.0f);
    }
    
    for (GLBar *bar in self.chartView.subviews) {
        [bar removeFromSuperview];
    }
}

- (void)drawChart {
    [super drawChart];
    
    CGFloat   h = self.container.contentSize.height;
    
    NSArray  *values = self.chartData.yValues;
    
    CGFloat   barWidth  = self.chartData.barWidth;
    CGFloat   barMargin = self.chartData.barMargin;
    
    for (int i = 0; i < values.count; i++) {
        GLBar *bar = [[GLBar alloc] init];
        
        CGRect frame = {{(barWidth + barMargin * 2) * i + barMargin, 0.0f}, {barWidth, h}};
        
        bar.frame = frame;
        bar.data  = values[i];
        
        [self.chartView addSubview:bar];
    }
}

- (void)getYValueRange {
    for (NSArray *list in self.chartData.yValues) {
        CGFloat value = 0.0f;
        
        for (NSDictionary *item in list) {
            value += [item[@"value"] floatValue];
        }
        
        if (self.chartData.count == 0) {
            self.chartData.count = list.count;
        }
        
        if (self.chartData.max < value) {
            self.chartData.max = value;
        }
    }
}

- (void)getYValueGrade {
    NSMutableArray *yValues = [self.chartData.yValues mutableCopy];
    
    for (int i = 0; i < yValues.count; i++) {
        NSMutableArray *list = [yValues[i] mutableCopy];
        
        for (int j = 0; j < list.count; j++) {
            NSMutableDictionary *item = [list[j] mutableCopy];
            
            CGFloat value = [item[@"value"] floatValue];
            
            if (self.chartData.max == 0 || value == 0) {
                item[@"grade"] = @0.0f;
            } else {
                item[@"grade"] = @(value / self.chartData.max);
            }
            
            [list replaceObjectAtIndex:j withObject:item];
        }
        
        [yValues replaceObjectAtIndex:i withObject:list];
    }
    
    self.chartData.yValues = yValues;
}

- (void)createXAxisLabels {
    CGFloat   h = self.container.contentSize.height;
    
    NSArray  *values = self.chartData.xValues;
    
    CGFloat   barWidth  = self.chartData.barWidth;
    CGFloat   barMargin = self.chartData.barMargin;
    
    CGFloat   labelFontSize  = self.chartData.labelFontSize;
    NSString *labelTextColor = self.chartData.labelTextColor;
    
    for (int i = 0; i < values.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        
        [self.xAxisLabels addObject:label];
        
        NSString *labelText = [[NSString alloc] initWithFormat:@"%@", values[i]];
        CGSize    labelSize = [labelText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:labelFontSize]}];
        CGRect    labelRect = {{(barWidth + barMargin * 2) * i, h}, {barWidth + barMargin * 2, labelSize.height}};
        
        label.frame         = labelRect;
        label.text          = labelText;
        label.font          = [UIFont systemFontOfSize   :labelFontSize];
        label.textColor     = [UIColor colorWithHexString:labelTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.container addSubview:label];
    }
}

@end
