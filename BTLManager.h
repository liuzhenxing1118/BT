#import <Foundation/Foundation.h>
#import "BTLCentralManager.h"
#import "BTLManagerOne.h"
#import "BTLProtocol.h"
#import "BTLReceive.h"
#import "BTLScan.h"

@interface BTLManager : NSObject


/** 单例 */
+ (BTLManager *)shardInstance;

@property(strong, nonatomic, getter=getBTLCentralManager)   BTLCentralManager *m_pBTLCentralManager;
@property(strong, nonatomic, getter=getBTLProtocol)         BTLProtocol *m_pBTLProtocol;
@property(strong, nonatomic, getter=getBTLReceive)          BTLReceive* m_pBTLReceive;
@property(strong, nonatomic, getter=getBTLScan)             BTLScan* m_pBTLScan;

//蓝牙是否开启//
@property(assign, nonatomic, getter=getIsPoweredOn, setter=setIsPoweredOn:) BOOL m_bIsPoweredOn;

//是否支持蓝牙4.0//
@property(assign, nonatomic, getter=getIsSupportBT4, setter=setIsSupportBT4:) BOOL m_bIsSupportBT4;

//是否已经有手表数据
@property(assign, nonatomic, setter=setIsHaveWatch:) BOOL m_bIsHaveWatch;

//通过此变量，控制蓝牙开启的位置。最新需求：需要使用蓝牙的时候，手机才需要开启蓝牙，不是进入app就要开启蓝牙
@property(assign,nonatomic, getter=getIsLock, setter=setIsLock:) BOOL m_bIsLock;

@property(assign, nonatomic)BOOL m_bIsRunning;

@property(strong, nonatomic, getter=getManagerOneArray) NSMutableArray *m_pManagerOneArray;

-(void)run;

- (void)initProtocol;

- (void)initBTLCentralManager;

- (BTLManagerOne *)ManagerOneByWatchName:(NSString*) name;

- (void)scan;

- (BTLManagerOne*)getCurManagerOne;

-(void)newWatchList;

- (void)checkWatch;

- (BOOL)getIsCurWatchValid;

- (void)destory;

@end