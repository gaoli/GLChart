#import "GLViewController.h"
#import "GLBarChartViewController.h"
#import "GLLineChartViewController.h"

static NSString *const kChartCellIdentifier = @"GLChartCell";

@interface GLViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GLViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.title = @"首页";
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    // 添加子类视图
    [self.view addSubview:self.tableView];
    
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[[GLLineChartViewController alloc] init] animated:YES];
            break;
            
        case 1:
            [self.navigationController pushViewController:[[GLBarChartViewController alloc] init]  animated:YES];
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChartCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kChartCellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"折线图表";
            break;
            
        case 1:
            cell.textLabel.text = @"柱状图表";
            break;
    }
    
    return cell;
}

#pragma mark - getters and setters

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.frame          = self.view.bounds;
        _tableView.delegate       = self;
        _tableView.dataSource     = self;
        _tableView.rowHeight      = 50.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

@end
