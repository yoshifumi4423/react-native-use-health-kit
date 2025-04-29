import HealthKit

/*!
 @class         UseHealthKit
 @abstract      This class provides an interface for accessing and storing the user's health data.
 */
@objc(UseHealthKit)
class UseHealthKit: NSObject {
  enum UseHealthKitError: String {
      case error = "Error"
      case notAvailable = "HealthData is not available"
      case noPermissions = "No permissions to access user health data"
  }

  /// Instance of HKHealthStore. Will be initialized in initializer.
  private let healthStore: HKHealthStore

  /// Instance of QuantityType. Will be initialized in initializer.
  private let quantityType: QuantityType

  /// Instance of CategoryType. Will be initialized in initializer.
  private let categoryType: CategoryType

  /// Initializer.
  override init() {
      healthStore = HKHealthStore()
      quantityType = QuantityType(healthStore: healthStore)
      categoryType = CategoryType(healthStore: healthStore)
  }

  /// HealthKit is not supported on all iOS devices such as iPad.
  ///
  /// - Returns: Returns true if HealthKit is supported on the device; otherwise false.
  private func isHealthDataAvailable() -> Bool {
      if HKHealthStore.isHealthDataAvailable() {
          return true
      }

      return false
  }

  private func getPermissions() -> [String: HKObjectType] {
      return [
          "activeEnergyBurned": HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
          "basalEnergyBurned": HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
          "bodyFatPercentage": HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!,
          "bodyMass": HKObjectType.quantityType(forIdentifier: .bodyMass)!,
          "bodyMassIndex": HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
          "dietaryEnergyConsumed": HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
          "dietaryWater": HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
          "distanceWalkingRunning": HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
          "flightsClimbed": HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
          "restingHeartRate": HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
          "stepCount": HKObjectType.quantityType(forIdentifier: .stepCount)!,
          "sleepAnalysis": HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
      ]
  }

  /// HealthKit is not supported on all iOS devices such as iPad.
  ///
  /// - Parameters:
  ///   - resolve: Return true if HealthKit is supported on the device.
  ///   - reject: Return false if HealthKit is not supported on the device.
  @objc func isHealthDataAvailable(_ resolve: RCTPromiseResolveBlock, _ reject: RCTPromiseRejectBlock) {
      if !isHealthDataAvailable() {
          reject(UseHealthKitError.error.rawValue, UseHealthKitError.notAvailable.rawValue, nil)
          return
      }

      resolve(true)
  }

  /// Initialize HKHealthStore with write and read permissions. This method should be called once to prevent unnecessary process.
  ///
  /// - Parameters:
  ///   - readPermissions: Array of string for read permission.
  ///   - writePermissions: Array of string for write permission.
  ///   - resolve: Return true if init is succeeded.
  ///   - reject: Return error message if init is failed.
  @objc func initHealthKit(_ readPermissions: [String]!,
                            _ writePermissions: [String]!,
                            _ resolve: @escaping RCTPromiseResolveBlock,
                            _ reject: @escaping RCTPromiseRejectBlock) {
      if !isHealthDataAvailable() {
          reject(UseHealthKitError.error.rawValue, UseHealthKitError.notAvailable.rawValue, nil)
          return
      }

      let permissions = getPermissions()

      var readType: Set<HKObjectType>?
      if !readPermissions.isEmpty {
          let permissions = readPermissions.map { permissions[$0]! }
          readType = Set(permissions)
      }

      var writeType: Set<HKObjectType>?
      if !writePermissions.isEmpty {
          let permissions = writePermissions.map { permissions[$0]! }
          writeType = Set(permissions)
      }

      if readType == nil, writeType == nil {
          reject(UseHealthKitError.error.rawValue, UseHealthKitError.noPermissions.rawValue, nil)
          return
      }

      healthStore.requestAuthorization(toShare: writeType as? Set<HKSampleType>, read: readType) { success, error in
          if !success {
              reject(UseHealthKitError.error.rawValue, UseHealthKitError.noPermissions.rawValue, nil)
              return
          }
          if let error = error {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
              return
          }

          resolve(true)
      }
  }

  /// Get array of DietaryWater value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of DietaryWater value.
  ///   - reject: Return error message.
  @objc func getDietaryWater(_ startDate: Double,
                              _ endDate: Double,
                              _ resolve: @escaping RCTPromiseResolveBlock,
                              _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.getDietaryWater(startDate, endDate) { _, result, error in
          do {
              if let error = error { throw error }

              var values: [[String: Double]] = []
              result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                          to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                  if let quantity = statistics.sumQuantity() {
                      let date = String(Int(statistics.startDate.timeIntervalSince1970))
                      let value = quantity.doubleValue(for: .liter())
                      values.append([date: value])
                  }
              }

              resolve(["dietaryWater": values])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Get array of BodyMass value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of BodyMass value.
  ///   - reject: Return error message.
  @objc func getBodyMass(_ startDate: Double,
                          _ endDate: Double,
                          _ resolve: @escaping RCTPromiseResolveBlock,
                          _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.getBodyMass(startDate, endDate) { _, result, error in
          do {
              if let error = error { throw error }

              var values: [[String: Double]] = []
              result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                          to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                  if let quantity = statistics.averageQuantity() {
                      let date = String(Int(statistics.startDate.timeIntervalSince1970))
                      let value = quantity.doubleValue(for: .gramUnit(with: .kilo))
                      values.append([date: value])
                  }
              }

              resolve(["bodyMass": values])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Get array of BodyFatPercentage value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of BodyFatPercentage value.
  ///   - reject: Return error message.
  @objc func getBodyFatPercentage(_ startDate: Double,
                                  _ endDate: Double,
                                  _ resolve: @escaping RCTPromiseResolveBlock,
                                  _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.getBodyFatPercentage(startDate, endDate) { _, result, error in
          do {
              if let error = error { throw error }

              var values: [[String: Double]] = []
              result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                          to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                  if let quantity = statistics.averageQuantity() {
                      let date = String(Int(statistics.startDate.timeIntervalSince1970))
                      let value = quantity.doubleValue(for: .percent())
                      values.append([date: value])
                  }
              }

              resolve(["bodyFatPercentage": values])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Get array of RestingHeartRate value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of RestingHeartRate value.
  ///   - reject: Return error message.
  @objc func getRestingHeartRate(_ startDate: Double,
                                  _ endDate: Double,
                                  _ resolve: @escaping RCTPromiseResolveBlock,
                                  _ reject: @escaping RCTPromiseRejectBlock) {
      if #available(iOS 11.0, *) {
          quantityType.getRestingHeartRate(startDate, endDate) { _, result, error in
              do {
                  if let error = error { throw error }

                  var values: [[String: Double]] = []
                  result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                              to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                      if let quantity = statistics.averageQuantity() {
                          let date = String(Int(statistics.startDate.timeIntervalSince1970))
                          let value = quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                          values.append([date: value])
                      }
                  }

                  resolve(["restingHeartRate": values])
              } catch {
                  reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
              }
          }
      } else {
          // Fallback on earlier versions
      }
  }

  /// Get array of ActiveEnergyBurned value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of ActiveEnergyBurned value.
  ///   - reject: Return error message.
  @objc func getActiveEnergyBurned(_ startDate: Double,
                                    _ endDate: Double,
                                    _ resolve: @escaping RCTPromiseResolveBlock,
                                    _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.getActiveEnergyBurned(startDate, endDate) { _, result, error in
          do {
              if let error = error { throw error }

              var values: [[String: Double]] = []
              result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                          to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                  if let quantity = statistics.sumQuantity() {
                      let date = String(Int(statistics.startDate.timeIntervalSince1970))
                      let value = quantity.doubleValue(for: .kilocalorie())
                      values.append([date: value])
                  }
              }

              resolve(["activeEnergyBurned": values])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Get array of BasalEnergyBurned value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of BasalEnergyBurned value.
  ///   - reject: Return error.
  @objc func getBasalEnergyBurned(_ startDate: Double,
                                  _ endDate: Double,
                                  _ resolve: @escaping RCTPromiseResolveBlock,
                                  _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.getBasalEnergyBurned(startDate, endDate) { _, result, error in
          do {
              if let error = error { throw error }

              var basalEnergyBurned: [[String: Double]] = []
              result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                          to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                  if let quantity = statistics.sumQuantity() {
                      let date = String(Int(statistics.startDate.timeIntervalSince1970))
                      let value = quantity.doubleValue(for: .kilocalorie())
                      basalEnergyBurned.append([date: value])
                  }
              }

              resolve(["basalEnergyBurned": basalEnergyBurned])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Get array of FlightsClimbed value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of FlightsClimbed value.
  ///   - reject: Return error message.
  @objc func getFlightsClimbed(_ startDate: Double,
                                _ endDate: Double,
                                _ resolve: @escaping RCTPromiseResolveBlock,
                                _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.getFlightsClimbed(startDate, endDate) { _, result, error in
          do {
              if let error = error { throw error }

              var values: [[String: Double]] = []
              result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                          to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                  if let quantity = statistics.sumQuantity() {
                      let date = String(Int(statistics.startDate.timeIntervalSince1970))
                      let value = quantity.doubleValue(for: .count())
                      values.append([date: value])
                  }
              }

              resolve(["flightsClimbed": values])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Get array of StepCount value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of StepCount value.
  ///   - reject: Return error message.
  @objc func getStepCount(_ startDate: Double,
                          _ endDate: Double,
                          _ resolve: @escaping RCTPromiseResolveBlock,
                          _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.getStepCount(startDate, endDate) { _, result, error in
          do {
              if let error = error { throw error }

              var values: [[String: Double]] = []
              result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                          to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                  if let quantity = statistics.sumQuantity() {
                      let date = String(Int(statistics.startDate.timeIntervalSince1970))
                      let value = quantity.doubleValue(for: .count())
                      values.append([date: value])
                  }
              }

              resolve(["stepCount": values])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Get array of DistanceWalkingRunning value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of DistanceWalkingRunning value.
  ///   - reject: Return error message.
  @objc func getDistanceWalkingRunning(_ startDate: Double,
                                        _ endDate: Double,
                                        _ resolve: @escaping RCTPromiseResolveBlock,
                                        _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.getDistanceWalkingRunning(startDate, endDate) { _, result, error in
          do {
              if let error = error { throw error }

              var values: [[String: Double]] = []
              result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                          to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                  if let quantity = statistics.sumQuantity() {
                      let date = String(Int(statistics.startDate.timeIntervalSince1970))
                      let value = quantity.doubleValue(for: .meter())
                      values.append([date: value])
                  }
              }

              resolve(["distanceWalkingRunning": values])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Get array of DietaryEnergyConsumed value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of DietaryEnergyConsumed value.
  ///   - reject: Return error message.
  @objc func getDietaryEnergyConsumed(_ startDate: Double,
                                      _ endDate: Double,
                                      _ resolve: @escaping RCTPromiseResolveBlock,
                                      _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.getDietaryEnergyConsumed(startDate, endDate) { _, result, error in
          do {
              if let error = error { throw error }

              var values: [[String: Double]] = []
              result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                          to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                  if let quantity = statistics.sumQuantity() {
                      let date = String(Int(statistics.startDate.timeIntervalSince1970))
                      let value = quantity.doubleValue(for: .kilocalorie())
                      values.append([date: value])
                  }
              }

              resolve(["dietaryEnergyConsumed": values])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Get array of BodyMassIndex value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of BodyMassIndex value.
  ///   - reject: Return error message.
  @objc func getBodyMassIndex(_ startDate: Double,
                              _ endDate: Double,
                              _ resolve: @escaping RCTPromiseResolveBlock,
                              _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.getBodyMassIndex(startDate, endDate) { _, result, error in
          do {
              if let error = error { throw error }

              var values: [[String: Double]] = []
              result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                          to: Date(timeIntervalSince1970: endDate)) { statistics, _ in
                  if let quantity = statistics.averageQuantity() {
                      let date = String(Int(statistics.startDate.timeIntervalSince1970))
                      let value = quantity.doubleValue(for: .count())
                      values.append([date: value])
                  }
              }

              resolve(["bodyMassIndex": values])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Set data of Quantity type.
  /// - Parameters:
  ///   - data:Dictionary of data. It should be like this.
  ///   - resolve: Return array of DietaryWater value.
  ///   - reject: Return error message.
  @objc func setQuantityData(_ data: [String: Any],
                              _ resolve: @escaping RCTPromiseResolveBlock,
                              _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.setQuantityData(data) { success, error in
          do {
              if let error = error { throw error }

              resolve(success)
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }


  /// Delete data of Quantity type.
  /// - Parameters:
  ///   - data:Dictionary of data. It should be like this.
  ///   - resolve: Return array of DietaryWater value.
  ///   - reject: Return error message.
  @objc func deleteQuantityData(_ data: [String: Any],
                                _ resolve: @escaping RCTPromiseResolveBlock,
                                _ reject: @escaping RCTPromiseRejectBlock) {
      quantityType.deleteQuantityData(data) { success, deletedObjectCount, error in
          do {
              if let error = error { throw error }

              let results: [String: Any] = ["success": success, "deletedObjectCount": deletedObjectCount]
              resolve(results)
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Get array of SleepAnalysis value.
  ///
  /// - Parameters:
  ///   - startDate: start date to get data.
  ///   - endDate: end date to get data.
  ///   - resolve: Return array of SleepAnalysis value.
  ///   - reject: Return error message.
  @objc func getSleepAnalysis(_ startDate: Double,
                              _ endDate: Double,
                              _ resolve: @escaping RCTPromiseResolveBlock,
                              _ reject: @escaping RCTPromiseRejectBlock) {
      let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
      let predicate = HKQuery.predicateForSamples(withStart: Date(timeIntervalSince1970: startDate),
                                                 end: Date(timeIntervalSince1970: endDate),
                                                 options: [.strictStartDate, .strictEndDate])
      
      let query = HKSampleQuery(sampleType: type,
                               predicate: predicate,
                               limit: HKObjectQueryNoLimit,
                               sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]) { _, samples, error in
          do {
              if let error = error { throw error }
              
              guard let samples = samples as? [HKCategorySample] else {
                  resolve(["sleepAnalysis": []])
                  return
              }
              
              let values = samples.map { sample -> [String: Double] in
                  let date = String(Int(sample.startDate.timeIntervalSince1970))
                  let value = Double(sample.value)
                  return [date: value]
              }
              
              print("Sleep Analysis Data:", values) // デバッグ用ログ
              resolve(["sleepAnalysis": values])
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
      
      healthStore.execute(query)
  }

  /// Set data of Category type.
  ///
  /// - Parameters:
  ///   - data: Dictionary of data. It should be like this.
  ///     ```
  ///     {
  ///       "type": "sleepAnalysis",  // Category type name
  ///       "unit": null,  // Units are not required for category types
  ///       "data": [
  ///         {"value": 0, "startDate": 1578915422, "endDate": 1578918422}, // Unix timestamp in seconds
  ///         ...
  ///       ]
  ///     }
  ///     ```
  ///   - resolve: Returns true when the promise is resolved
  ///   - reject: Returns error message when an error occurs
  @objc func setCategoryData(_ data: [String: Any],
                              _ resolve: @escaping RCTPromiseResolveBlock,
                              _ reject: @escaping RCTPromiseRejectBlock) {
      categoryType.setCategoryData(data) { success, error in
          if let error = error {
              if let categoryError = error as? CategoryType.CategoryTypeError {
                  switch categoryError {
                  case .invalidCategoryType:
                      reject(UseHealthKitError.error.rawValue, "Invalid category type. Supported types: sleepAnalysis, mindfulSession, etc.", nil)
                  case .invalidDataFormat:
                      reject(UseHealthKitError.error.rawValue, "Invalid data format. Please check the data structure.", nil)
                  default:
                      reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
                  }
              } else {
                  reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
              }
              return
          }
          
          if !success {
              reject(UseHealthKitError.error.rawValue, "Failed to save category data", nil)
              return
          }
          
          resolve(true)
      }
  }

  /// Delete data of Category type.
  ///
  /// - Parameters:
  ///   - data: Dictionary of data. It should be like this.
  ///     ```
  ///     {
  ///       "type": "sleepAnalysis",  // Category type name
  ///       "startDate": 1578915422,  // Start date for deletion (Unix timestamp in seconds)
  ///       "endDate": 1578918422     // End date for deletion (Unix timestamp in seconds)
  ///     }
  ///     ```
  ///   - resolve: Returns success status and count of deleted objects
  ///   - reject: Returns error message
  @objc func deleteCategoryData(_ data: [String: Any],
                                _ resolve: @escaping RCTPromiseResolveBlock,
                                _ reject: @escaping RCTPromiseRejectBlock) {
      categoryType.deleteCategoryData(data) { success, deletedObjectCount, error in
          do {
              if let error = error {
                  if let categoryError = error as? CategoryType.CategoryTypeError {
                      switch categoryError {
                      case .invalidCategoryType:
                          reject(UseHealthKitError.error.rawValue, "Invalid category type. Supported types: sleepAnalysis, mindfulSession, etc.", nil)
                      case .invalidPayload:
                          reject(UseHealthKitError.error.rawValue, "Invalid payload. Make sure type, startDate, and endDate are included.", nil)
                      default:
                          reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
                      }
                  } else {
                      throw error
                  }
                  return
              }

              let results: [String: Any] = ["success": success, "deletedObjectCount": deletedObjectCount]
              resolve(results)
          } catch {
              reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
          }
      }
  }

  /// Return true to use this native module in main thread for heavy processing such as rendering UI.
  /// Return false to use this native module in secondly thread.
  ///
  /// - Returns: Return true for main thread; otherwise false.
  @objc static func requiresMainQueueSetup() -> Bool {
      return false
  }
}
