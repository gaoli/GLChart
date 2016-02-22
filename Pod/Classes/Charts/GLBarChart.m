#import "GLBarChart.h"
#import "GLChartData.h"

@implementation GLBarChart

#pragma mark - private methods

- (void)parseData {
    [super parseData];
    
    [self getYValueRange];
    [self getYValueGrade];
}

- (void)getYValueRange {
    for (NSArray *list in self.chartData.yValues) {
        CGFloat value = 0.0f;
        
        for (NSDictionary *item in list) {
            value += [item[@"value"] floatValue];
        }
        
        if (self.chartData.min > value) {
            self.chartData.min = value;
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

@end
