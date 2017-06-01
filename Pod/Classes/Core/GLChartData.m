#import "GLChartData.h"

@implementation GLChartData

- (id)init {
    self = [super init];
    
    if (self) {
        
        // ======= 通用属性 =======
        
        self.xValues                     = [NSArray array];
        self.yValues                     = [NSArray array];
        
        self.min                         =  MAXFLOAT;
        self.max                         = -MAXFLOAT;
        self.count                       = 0;
        self.scale                       = 0.0f;
        
        self.margin                      = 15.0f;
        
        self.xStep                       = 5;
        self.yStep                       = 5;
        
        self.gridLineWidth               = 0.5f;
        self.gridLineColor               = @"#DDDDDD";
        
        self.labelFontSize               = 9.0f;
        self.labelTextColor              = @"#999999";
        
        self.animated                    = YES;
        self.duration                    = 0.5;
        
        self.noData                      = YES;
        self.noDataTips                  = @"暂无数据可供展示";
        
        self.chartInitDirection          = GLChartInitDirectionLeft;
        
        // ======= 折线图表 =======
        
        self.lineWidth                   = 0.5f;
        
        self.visibleRangeMaxNum          = 0;
        
        self.isFill                      = YES;
        
        self.isEnabledIndicator          = NO;
        self.indicatorLineWidth          = 0.5f;
        self.indicatorLineColor          = @"#999999";
        self.indicatorBorderColor        = @"#999999";
        self.indicatorLabelFontSize      = 9.0f;
        self.indicatorLabelTextColor     = @"#999999";
        self.indicatorAliasLabelMaxWidth = 0.0f;
        
        self.dots                        = [NSArray array];
        self.lines                       = [NSArray array];
        
        self.isYAxisStartFromZero        = YES;
        
        // ======= 柱状图表 =======
        
        self.barWidth                    = 20.0f;
        
        self.barMargin                   = 5.0f;
    }
    
    return self;
}

@end
