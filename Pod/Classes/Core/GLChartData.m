#import "GLChartData.h"

@implementation GLChartData

- (id)init {
    self = [super init];
    
    if (self) {
        
        // 通用属性
        
        self.margin              = 15.0f;
        
        self.xValues             = [NSArray array];
        self.yValues             = [NSArray array];
        
        self.min                 = 0.0f;
        self.max                 = 0.0f;
        self.count               = 0;
        self.scale               = 0.0f;
        
        self.xStep               = 5;
        self.yStep               = 5;
        
        self.lineWidth           = 0.5f;
        
        self.gridLineWidth       = 0.5f;
        self.gridLineColor       = @"#DDDDDD";
        
        self.labelFontSize       = 9.0f;
        self.labelTextColor      = @"#999999";
        
        self.animated            = YES;
        self.duration            = 0.5;
        
        // 折线图属性
        
        self.visibleRangeMaxNum  = 0;
        
        self.isFill              = YES;
        self.isEnabledIndicator  = NO;

        self.indicatorLineWidth  = 0.5f;
        self.indicatorLineColor  = @"#999999";
        
        // 柱状图属性
        
        self.barWidth            = 20.0f;
        self.barMargin           = 5.0f;
    }
    
    return self;
}

@end
