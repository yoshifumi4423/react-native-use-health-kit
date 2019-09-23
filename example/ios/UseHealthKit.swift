
import Foundation

@objc(UseHealthKit)
class UseHealthKit: NSObject {
  
  static func requiresMainQueueSetup() -> Bool {
    return false
  }
  
  @objc
  func increment(_ origin: Int, withCallback callback: RCTResponseSenderBlock) -> Void {
    callback([origin + 1])
  }
  
  @objc
  func decrement(_ origin: Int, withResolve resolve: RCTPromiseResolveBlock, withReject reject: RCTPromiseRejectBlock) -> Void{
    
    if(origin <= 0){
      reject("E_COUNT", "You can't decrement any more!!", nil)
      return
    }
    
    resolve(origin - 1)
    
  }
}
