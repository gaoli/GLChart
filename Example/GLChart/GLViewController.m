#import "GLViewController.h"
#import "GLChartData.h"
#import "GLLineChart.h"
#import "GLBarChart.h"

@interface GLViewController ()

@end

@implementation GLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    GLChartData *lineChartData = [[GLChartData alloc] init];
    GLLineChart *lineChart     = [[GLLineChart alloc] initWithFrame:CGRectMake(0.0f, 50.0f, [UIScreen mainScreen].bounds.size.width, 170)];
    
    lineChartData.isFill  = YES;
    lineChartData.xValues = @[@"10:01", @"10:02", @"10:03", @"10:04", @"10:05", @"10:06", @"10:07", @"10:08", @"10:09", @"10:10",
                              @"10:11", @"10:12", @"10:13", @"10:14", @"10:15", @"10:16", @"10:17", @"10:18", @"10:19", @"10:20",
                              @"10:21", @"10:22", @"10:23", @"10:24", @"10:25", @"10:26", @"10:27", @"10:28", @"10:29", @"10:30",
                              @"10:31", @"10:32", @"10:33", @"10:34", @"10:35", @"10:36", @"10:37", @"10:38", @"10:39", @"10:40",
                              @"10:41", @"10:42", @"10:43", @"10:44", @"10:45", @"10:46", @"10:47", @"10:48", @"10:49", @"10:50",
                              @"10:51", @"10:52", @"10:53", @"10:54", @"10:55", @"10:56", @"10:57", @"10:58", @"10:59", @"11:00"];
    
    lineChartData.yValues = @[@{@"color": @"#7CB5EC", @"value": @[@18, @18, @19, @20, @19, @20, @17, @19, @19, @18,
                                                              @20, @18, @20, @19, @17, @19, @18, @19, @18, @20,
                                                              @19, @19, @19, @18, @19, @17, @17, @17, @19, @17,
                                                              @20, @18, @18, @19, @19, @20, @18, @20, @17, @17,
                                                              @17, @20, @19, @20, @18, @19, @18, @19, @17, @19,
                                                              @19, @19, @19, @18, @19, @17, @17, @19, @19, @19]}];
    
    lineChartData.visibleRangeMaxNum = 30;

    
//    lineChartData.yValues = @[@{@"color": @"#7CB5EC", @"value": @[@20, @16, @12, @15, @17, @18, @19, @15, @13, @13,
//                                                                  @13, @14, @10, @11, @11, @19, @19, @16, @15, @12,
//                                                                  @19, @14, @11, @17, @14, @16, @12, @14, @14, @20,
//                                                                  @15, @14, @17, @18, @15, @15, @15, @19, @19, @13,
//                                                                  @17, @19, @15, @11, @14, @18, @18, @19, @11, @13,
//                                                                  @18, @11, @11, @14, @19, @20, @14, @12, @11, @16]},
//                              @{@"color": @"#F7A35C", @"value": @[@11, @11, @14, @19, @14, @16, @12, @14, @11, @16,
//                                                                  @17, @14, @16, @12, @18, @18, @19, @11, @19, @11,
//                                                                  @17, @18, @15, @15, @15, @14, @19, @20, @14, @16,
//                                                                  @15, @11, @14, @18, @18, @19, @11, @14, @18, @18,
//                                                                  @16, @12, @18, @18, @19, @14, @16, @12, @18, @12,
//                                                                  @12, @15, @17, @18, @19, @15, @13, @13, @14, @18]}];
//    lineChartData.isFill             = NO;
//    lineChartData.isEnabledIndicator = YES;
    
    lineChart.chartData = lineChartData;
    
    [self.view addSubview:lineChart];
    
    GLChartData *barChartData = [[GLChartData alloc] init];
    GLBarChart  *barChart     = [[GLBarChart alloc] initWithFrame:CGRectMake(0.0f, 250.0f, [UIScreen mainScreen].bounds.size.width, 170)];
    
    barChartData.xValues = @[@"10:01", @"10:02", @"10:03", @"10:04", @"10:05", @"10:06", @"10:07", @"10:08", @"10:09", @"10:10",
                             @"10:11", @"10:12", @"10:13", @"10:14", @"10:15", @"10:16", @"10:17", @"10:18", @"10:19", @"10:20"];
    barChartData.yValues = @[@[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}],
                             @[@{@"value": @10, @"color": @"#7ED321"},
                               @{@"value": @5,  @"color": @"#E74C3C"}]
                            ];
    
    barChart.chartData = barChartData;
    
    [self.view addSubview:barChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
