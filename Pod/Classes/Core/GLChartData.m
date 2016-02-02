#import "GLChartData.h"

@implementation GLChartData

- (id)init {
    self = [super init];
    
    if (self) {
        self.margin           = 15.0f;
        
        self.xValues          = [NSArray array];
        self.yValues          = [NSArray array];
        
        self.min              = 0.0f;
        self.max              = 0.0f;
        
        self.xStep            = 5;
        self.yStep            = 5;
        
        self.lineWidth        = 0.5f;
        
        self.gridWidth        = 0.5f;
        self.gridColor        = @"#DDDDDD";
        
        self.labelFontSize    = 9.0f;
        self.labelTextColor   = @"#999999";
        
        self.animated         = YES;
        self.duration         = 0.5;
        
        self.xMaxVisibleRange = 30;
        
        self.isFill           = YES;
    }
    
    return self;
}

@end
