//
//  ViewController.m
//  MagicalRecordDemo
//
//  Created by 123456 on 17/3/16.
//  Copyright © 2017年 123456. All rights reserved.
//

#import "ViewController.h"
//#import "MCEpisode.h"
#import <MagicalRecord/MagicalRecord.h>
#import "ShowCell.h"
#import "MagicalRecordDemo-Swift.h"

@interface ViewController ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowCell" bundle:nil] forCellReuseIdentifier:@"Cell"];

    [self reloadData];
//    NSString *abc = @"88888";
    NSLog(@"count________:%@", [Episode MR_numberOfEntities]);
    
    
}


- (void)reloadData {
    /**
     *  Description 如果缓存中有数据，读取缓存；否则重新获取数据并缓存
     *
     */
    NSLog(@"countttt-----:%lu", (unsigned long)[Episode MR_findAll].count);
    

    if ([Episode MR_findAll].count != 0) {
        _dataSource = [Episode MR_findAll];
        [self.tableView reloadData];
    }else {
        _manager = [AFHTTPSessionManager manager];
        // 设置超时时间
        _manager.requestSerializer.timeoutInterval = 5.f;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", @"application/x-javascript", nil];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        [_manager GET:@"https://www.nsscreencast.com/api/episodes.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *array = responseObject[@"episodes"];

            _dataSource = [Episode MR_importFromArray:array];
            [self.tableView reloadData];
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                [Episode MR_importFromArray:array inContext:localContext];
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error-------:%@", error);
        }];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    ShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    Episode *episode = self.dataSource[indexPath.row];
    cell.title.text = episode.title;
    cell.subtitle.text = episode.slug;
    [cell.photo setImageWithURL:[NSURL URLWithString:episode.small_artwork_url] placeholderImage:nil];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
