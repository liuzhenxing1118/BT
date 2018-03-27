#import <Foundation/Foundation.h>
#import "BTLProtocol.h"


@interface BTLServiceCharacter :NSObject<BTLPeripheralDelegate>


@property(strong, nonatomic, getter=getService) CBService *m_pService;
@property(strong, nonatomic, getter=getCharacteristic) CBCharacteristic *m_pCharacteristic;

@property(assign, nonatomic, getter=getIsConnect) BOOL m_bIsConnect;

@property(assign, nonatomic, getter=getType, setter=initType:) NSInteger m_iType;
@property(assign, nonatomic) NSString* m_sService;
@property(assign, nonatomic) NSString* m_sCharacteristics;



- (void)initBtLManagerOne:(id)_BTLManagerOne;

- (void)initBTLPeripheral:(id)_BTLPeripheral;

- (void)initBTLProtocolDelegate;

- (void)removeBTLProtocolDelegate;

- (void)initUUIDWithService:(NSString*) _service Characteristics:(NSString*) _characteristics;

- (void)discoverServices;

- (void)readRSSI;

- (void)removeTimer;

@end