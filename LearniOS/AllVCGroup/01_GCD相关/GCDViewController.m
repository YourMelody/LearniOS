//
//  GCDViewController.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/9.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy)NSArray *dataSource;
@property(nonatomic, strong)dispatch_source_t timer;

@end

@implementation GCDViewController

/*
 GCD优点：
    1、可用于多核的并行运算
    2、会自动利用更多的CPU内核
    3、会自动管理线程的生命周期（创建线程、调度任务、销毁线程等），不需要我们管理线程
 
 异步async具有开辟新线程的能力，但是不一定会开启新线程，还跟任务所指定的队列有关系。
 同步sync不具备开启新线程的能力。
 
 队列是一种特殊的线性表，FIFO（先进先出）
 串行队列和并发队列都符合FIFO的原则
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD相关";
    self.dataSource = @[
        @"1、同步函数+串行队列",
        @"2、同步函数+并发队列",
        @"3、当前线程为主线程时，同步函数+主队列(死锁崩溃，慎点)",
        @"4、当前线程为子线程时，同步函数+主队列",
        @"5、异步函数+串行队列",
        @"6、异步函数+并发队列",
        @"7、当前线程为主线程时，异步函数+主队列",
        @"8、当前线程为子线程时，异步函数+主队列",
        @"9、异步栅栏函数+串行队列（了解）",
        @"10、异步栅栏函数+并发队列",
        @"11、同步栅栏函数+串行队列（了解）",
        @"12、同步栅栏函数+并发队列（了解）",
        @"13、异步任务组+串行队列（了解）",
        @"14、异步任务组+并发队列",
        @"15、任务组wait_forever",
        @"16、任务组wait_now",
        @"17、任务组group_enter和group_leave",
        @"18、GCD快速迭代",
        @"19、GCD延时操作",
        @"20、GCD信号量",
        @"21、GCD定时器",
        @"22、练习测试"
    ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idStr = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self sync_serial];
    } else if (indexPath.row == 1) {
        [self sync_concurrent];
    } else if (indexPath.row == 2) {
        [self sync_mainQueue_mainThread];
    } else if (indexPath.row == 3) {
        [self sync_mainQueue_childThread];
    } else if (indexPath.row == 4) {
        [self async_serial];
    } else if (indexPath.row == 5) {
        [self async_concurrent];
    } else if (indexPath.row == 6) {
        [self async_mainQueue_mainThread];
    } else if (indexPath.row == 7) {
        [self async_mainQueue_childThread];
    } else if (indexPath.row == 8) {
        [self async_barrier_serial];
    } else if (indexPath.row == 9) {
        [self async_barrier_concurrent];
    } else if (indexPath.row == 10) {
        [self sync_barrier_serial];
    } else if (indexPath.row == 11) {
        [self sync_barrier_concurrent];
    } else if (indexPath.row == 12) {
        [self async_group_serial];
    } else if (indexPath.row == 13) {
        [self async_group_concurrent];
    } else if (indexPath.row == 14) {
        [self async_group_wait_forever];
    } else if (indexPath.row == 15) {
        [self async_group_wait_now];
    } else if (indexPath.row == 16) {
        [self group_enter_and_leave];
    } else if (indexPath.row == 17) {
        [self gcg_apply];
    } else if (indexPath.row == 18) {
        [self gcd_after];
    } else if (indexPath.row == 19) {
        [self gcd_semaphore];
    } else if (indexPath.row == 20) {
        [self gcd_timer];
    } else if (indexPath.row == 21) {
        [self test];
    }
}

#pragma mark - 1、同步函数 + 串行队列
- (void)sync_serial {
    // 不会开辟新线程，所有任务在当前线程中串行执行。
    // (start -> 111 -> 222 -> 333 -> end) 全部在同一个线程（当前线程）
    dispatch_queue_t queue = dispatch_queue_create("sync_serial_test", DISPATCH_QUEUE_SERIAL);
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 2、同步函数 + 并发队列
- (void)sync_concurrent {
    // 不会开辟新线程，所有任务在当前线程中串行执行。
    // (start -> 111 -> 222 -> 333 -> end) 全部在同一个线程（当前线程）
    dispatch_queue_t queue = dispatch_queue_create("sync_concurrent_test", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 3、同步函数 + 主队列，且当前线程为主线程
- (void)sync_mainQueue_mainThread {
    // 不会开辟新线程，会造成死锁！！
    // (start -> 死锁崩溃)
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 4、同步函数 + 主队列，且当前线程为子线程
- (void)sync_mainQueue_childThread {
    [NSThread detachNewThreadWithBlock:^{
        // 不会开辟新线程，所有任务在主线程中串行执行。
        // (start -> 111 -> 222 -> 333 -> end) start和end在当前子线程，111、222、333在主线程
        dispatch_queue_t queue = dispatch_get_main_queue();
        NSLog(@"start---%@", [NSThread currentThread]);
        dispatch_sync(queue, ^{
            for (int i = 0; i < 2; i++) {
                NSLog(@"111---%d---%@", i, [NSThread currentThread]);
            }
        });
        dispatch_sync(queue, ^{
            for (int i = 0; i < 2; i++) {
                NSLog(@"222---%d---%@", i, [NSThread currentThread]);
            }
        });
        dispatch_sync(queue, ^{
            for (int i = 0; i < 2; i++) {
                NSLog(@"333---%d---%@", i, [NSThread currentThread]);
            }
        });
        NSLog(@"end---%@", [NSThread currentThread]);
    }];
}

#pragma mark - 5、异步函数 + 串行队列
- (void)async_serial {
    // 会开辟一条线程，所有任务在新线程中串行执行。
    // (start -> end -> 111 -> 222 -> 333) start和end在当前线程，111、222、333在同一新线程
    dispatch_queue_t queue = dispatch_queue_create("async_serial_test", DISPATCH_QUEUE_SERIAL);
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 6、异步函数 + 并发队列
- (void)async_concurrent {
    // 会开辟多条线程，所有任务在不同线程并发执行。
    // (start -> end -> 111 -> 222 -> 333) start和end在当前线程，111、222、333在多个子线程
    dispatch_queue_t queue = dispatch_queue_create("async_concurrent_test", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 7、异步函数 + 主队列，且当前线程为主线程
- (void)async_mainQueue_mainThread {
    // 不会开辟新线程，所有任务在主线程串行执行。
    // (start -> end -> 111 -> 222 -> 333) 都在主线程中
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 8、异步函数 + 主队列，且当前线程为子线程
- (void)async_mainQueue_childThread {
    [NSThread detachNewThreadWithBlock:^{
        // 不会开辟新线程，所有任务在主线程中串行执行。
        // (start -> end -> 111 -> 222 -> 333) start和end在当前子线程，111、222、333在主线程
        dispatch_queue_t queue = dispatch_get_main_queue();
        NSLog(@"start---%@", [NSThread currentThread]);
        dispatch_async(queue, ^{
            for (int i = 0; i < 2; i++) {
                NSLog(@"111---%d---%@", i, [NSThread currentThread]);
            }
        });
        dispatch_async(queue, ^{
            for (int i = 0; i < 2; i++) {
                NSLog(@"222---%d---%@", i, [NSThread currentThread]);
            }
        });
        dispatch_async(queue, ^{
            for (int i = 0; i < 2; i++) {
                NSLog(@"333---%d---%@", i, [NSThread currentThread]);
            }
        });
        NSLog(@"end---%@", [NSThread currentThread]);
    }];
}

#pragma mark - 9、异步栅栏函数+串行队列
- (void)async_barrier_serial {
    // 栅栏函数的队列不能是全局并发队列dispatch_get_global_queue(0, 0)，否则不生效。
    // (start -> end -> 111 -> 222 -> barrier -> 333 -> 444) start和end在当前线程，其他任务在同一个新线程
    dispatch_queue_t queue = dispatch_queue_create("barrier_serial_test", DISPATCH_QUEUE_SERIAL);
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"444---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 10、异步栅栏函数+并发队列
- (void)async_barrier_concurrent {
    // (start -> end -> 111/222 -> barrier -> 333/444) start和end在当前线程，其他任务在多个子线程
    dispatch_queue_t queue = dispatch_queue_create("barrier_concurrent_test", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"444---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 11、同步栅栏函数+串行队列
- (void)sync_barrier_serial {
    // (start -> 111 -> 222 -> barrier -> end -> 333 -> 444) start、end和barrier在当前线程，其他任务在多个子线程
    dispatch_queue_t queue = dispatch_queue_create("sync_barrier_serial_test", DISPATCH_QUEUE_SERIAL);
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    // ⚠️ 当前线程为主线程时，同步栅栏函数+主队列一样会死锁
    dispatch_barrier_sync(queue, ^{
        NSLog(@"barrier---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"444---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 12、同步栅栏函数+并发队列
- (void)sync_barrier_concurrent {
    // (start -> 111/222 -> barrier -> end -> 333/444) start、end和barrier在当前线程，其他任务在多个子线程
    dispatch_queue_t queue = dispatch_queue_create("sync_barrier_concurrent_test", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_barrier_sync(queue, ^{
        NSLog(@"barrier---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"444---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 13、异步任务组+串行队列
- (void)async_group_serial {
    // 任务组中的任务可以在相同的队列，也可以在不同的队列
    // (start -> end -> 111 -> 222 -> 333 -> 444 -> notify) start和end在当前线程，其他所有任务在同一个新线程
    dispatch_queue_t queue = dispatch_queue_create("group_serial_test", DISPATCH_QUEUE_SERIAL);
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"notify---%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"444---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 14、异步任务组+并发队列
- (void)async_group_concurrent {
    // 任务组中的任务可以在相同的队列，也可以在不同的队列
    // (start -> end -> 111/222/333/444 -> notify) start和end在当前线程，其他所有任务在多个新线程
    dispatch_queue_t queue = dispatch_queue_create("group_concurrent_test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"notify---%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"444---%d---%@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 15、任务组wait_forever
- (void)async_group_wait_forever {
    // (start -> before_wait -> 111/222 -> notify/after_wait) start、before、after在当前线程，其他任务在多个子线程
    dispatch_queue_t queue = dispatch_queue_create("async_group_wait_forever", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"notify---%@", [NSThread currentThread]);
    });
    
    NSLog(@"before_wait---%@", [NSThread currentThread]);
    // 阻塞，直到任务组中所有任务执行完毕
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"after_wait---%@", [NSThread currentThread]);
}

#pragma mark - 16、任务组wait_now
- (void)async_group_wait_now {
    // (start -> before_wait -> after_wait -> 111/222 -> notify) start、before、after在当前线程，其他任务在多个子线程
    dispatch_queue_t queue = dispatch_queue_create("async_group_wait_now", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"notify---%@", [NSThread currentThread]);
    });
    
    NSLog(@"before_wait---%@", [NSThread currentThread]);
    dispatch_group_wait(group, DISPATCH_TIME_NOW);
    NSLog(@"after_wait---%@", [NSThread currentThread]);
}

#pragma mark - 17、任务组的group_enter和group_leave
- (void)group_enter_and_leave {
    // dispatch_group_enter标志着一个任务追加到group，group中的未完成任务数+1；
    // dispatch_group_leave标志着一个任务离开group，group中的未完成任务数-1；
    // 当group中未完毕任务数为0时，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。
    
    // (start -> before_wait -> 111/222 -> notify/after_await)
    dispatch_queue_t queue = dispatch_queue_create("group_enter_and_leave", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"notify---%@", [NSThread currentThread]);
    });
    
    NSLog(@"before_wait---%@", [NSThread currentThread]);
    // 阻塞，直到任务组中所有任务执行完毕
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"after_wait---%@", [NSThread currentThread]);
}

#pragma mark - 18、apply快速迭代
- (void)gcg_apply {
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
        // 可能在当前线程，可能在其他子线程执行
        NSLog(@"%zu---%@", index, [NSThread currentThread]);
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}

#pragma mark - 19、延时操作
- (void)gcd_after {
    // dispatch_after函数并不是在指定时间之后立即执行处理，而是在指定时间之后将任务追加到指定的队列中。
    // 所以严格来说，这个时间并不是绝对准确的。
    // 两个延时任务执行顺序不一定
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
    });
}

#pragma mark - 20、GCD信号量
- (void)gcd_semaphore {
    /*
     GCD中的信号量即diapatch_semaphore，是持有计数的信号。当计数为0时，有任务则需要等待；当计数大于等于1时，不需等待直接执行任务，
     并且计数减1。其相关的三个函数：
         1、 dispatch_semaphore_create：创建并初始化信号量
         2、 dispatch_semaphore_signal：发送一个信号，让信号总量+1
         3、 dispatch_semaphore_wait：使信号总量-1，当信号量为0时就会一直等待，阻塞当前线程
     */
    
    /*
     1、初始信号量为0: dispatch_semaphore_create(0)
        start -> 1_wait_b -> 111 -> 1_wait_a -> 2_wait_b -> 222 -> 2_wait_a
     
     2、初始信号量为1: dispatch_semaphore_create(1)
        start -> 1_wait_b -> 1_wait_a -> 2_wait_b -> 111/222/2_wait_a，其中2_wait_a不一定最后执行，但肯定在111/222其中一个完全执行完之后执行
     
     3、初始信号量为2: dispatch_semaphore_create(2)
        start -> 1_wait_b -> 1_wait_a -> 2_wait_b -> 2_wait_a -> 111/222
     */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"start---%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        for (int i = 0; i < 2; i++) {
            NSLog(@"111---%d---%@", i, [NSThread currentThread]);
        }
        dispatch_semaphore_signal(semaphore);
    });
        
    NSLog(@"1---wait_before---%@", [NSThread currentThread]);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"1---wait_after---%@", [NSThread currentThread]);
        
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        for (int i = 0; i < 2; i++) {
            NSLog(@"222---%d---%@", i, [NSThread currentThread]);
        }
        dispatch_semaphore_signal(semaphore);
    });
        
    NSLog(@"2---wait_before---%@", [NSThread currentThread]);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"2---wait_after---%@", [NSThread currentThread]);
}

#pragma mark - 21、GCD定时器
- (void)gcd_timer {
    // GCD定时器是绝对精准且不受线程影响的
    
    // 创建timer 注意这里的timer要有强引用，否则创建一个局部的timer会被释放，不能执行定时任务。
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    // 设置timer，四个参数：timer对象、开始时间、时间间隔、精确度
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    // 添加任务
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"timer---%@", [NSThread currentThread]);
    });
    // 开启定时器
    dispatch_resume(self.timer);
}

#pragma mark - 22、练习测试
- (void)test {
    dispatch_queue_t queue_concurrent = dispatch_queue_create("test1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue_serial = dispatch_queue_create("test2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue_global = dispatch_get_global_queue(0, 0);
    
    // 打印顺序：12345
    NSLog(@"1");
    dispatch_sync(queue_concurrent, ^{
        NSLog(@"2");
        dispatch_sync(queue_concurrent, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
    
    NSLog(@"=====分割线=====");
//    // 打印顺序：12然后线程死锁
//    NSLog(@"1");
//    dispatch_sync(queue_serial, ^{
//        NSLog(@"2");
//        dispatch_sync(queue_serial, ^{
//            NSLog(@"3");
//        });
//        NSLog(@"4");
//    });
//    NSLog(@"5");
    
    // 打印顺序：123，after---2不执行
    dispatch_async(queue_global, ^{
        NSLog(@"1");
        // 当前子线程没有开启RunLoop，因此该方法失效
        [self performSelector:@selector(printLog:) withObject:@(YES) afterDelay:0];
        [self performSelector:@selector(printLog:) withObject:@(NO)];
        NSLog(@"3");
    });
    NSLog(@"=====分割线=====");
}

- (void)printLog:(BOOL)param {
    if (param) {
        NSLog(@"after---2");
    } else {
        NSLog(@"2");
    }
}

@end
