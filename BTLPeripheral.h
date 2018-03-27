#import <Foundation/Foundation.h>
#import "BTLProtocol.h"


@interface BTLPeripheral :NSObject<BTLCentralManagerDelegate>

//连接手表
@property(strong, nonatomic) CBPeripheral *m_pCBPeripheral;

@property(assign, nonatomic, getter=getIsConnect) BOOL m_bIsConnect;


- (void)initBTLManagerOne:(id)_BTLManagerOne;

- (void)initBTLProtocolDelegate;

- (void)removeBTLProtocolDelegate;

@end