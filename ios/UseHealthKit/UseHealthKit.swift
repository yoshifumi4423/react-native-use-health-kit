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

    let Permissions: [String: HKObjectType] = [
        //        // HKCategoryTypeIdentifier
        //        // Vital Signs
        //        "lowHeartRateEvent": HKObjectType.categoryType(forIdentifier: .lowHeartRateEvent)!, // iOS 12.2 or newer
        //        "highHeartRateEvent": HKObjectType.categoryType(forIdentifier: .highHeartRateEvent)!, // iOS 12.2 or newer
        //        "irregularHeartRhythmEvent": HKObjectType.categoryType(forIdentifier: .irregularHeartRhythmEvent)!, // iOS 12.2 or newer
        //        // Reproductive Health
        //        "cervicalMucusQuality": HKObjectType.categoryType(forIdentifier: .cervicalMucusQuality)!,
        //        "menstrualFlow": HKObjectType.categoryType(forIdentifier: .menstrualFlow)!,
        //        "intermenstrualBleeding": HKObjectType.categoryType(forIdentifier: .intermenstrualBleeding)!,
        //        "ovulationTestResult": HKObjectType.categoryType(forIdentifier: .ovulationTestResult)!,
        //        "sexualActivity": HKObjectType.categoryType(forIdentifier: .sexualActivity)!,
        // Activity
        //        "appleStandHour": HKObjectType.categoryType(forIdentifier: .appleStandHour)!,
        // Mindfullness and Sleep
        //        "mindfulSession": HKObjectType.categoryType(forIdentifier: .mindfulSession)!, // iOS 10.0 or newer
        "sleepAnalysis": HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,

        // HKCharacteristicTypeIdentifier
        //        "biologicalSex": HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
        //        "bloodType": HKObjectType.characteristicType(forIdentifier: .bloodType)!,
        //        "dateOfBirth": HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
        //        "fitzpatrickSkinType": HKObjectType.characteristicType(forIdentifier: .fitzpatrickSkinType)!,
        //        "wheelchairUse": HKObjectType.characteristicType(forIdentifier: .wheelchairUse)!, // iOS 10.0 or newer

        // HKQuantityTypeIdentifier
        "heartRate": HKObjectType.quantityType(forIdentifier: .heartRate)!,
        "dietaryWater": HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
        "bodyMass": HKObjectType.quantityType(forIdentifier: .bodyMass)!,
        "bodyFatPercentage": HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!,
        "restingHeartRate": HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        "activeEnergyBurned": HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        "basalEnergyBurned": HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
        "flightsClimbed": HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
        "stepCount": HKObjectType.quantityType(forIdentifier: .stepCount)!,
        "distanceWalkingRunning": HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        "dietaryEnergyConsumed": HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
        "bodyMassIndex": HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
    ]

    /// Instance of HKHealthStore. Will be initialized in initializer.
    private let healthStore: HKHealthStore

    /// Instance of QuantityType. Will be initialized in initializer.
    private let quantityType: QuantityType

    /// Initializer.
    override init() {
        healthStore = HKHealthStore()
        quantityType = QuantityType(healthStore: healthStore)
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

        var readType: Set<HKObjectType>?
        if !readPermissions.isEmpty {
            let permissions = readPermissions.map { Permissions[$0]! }
            readType = Set(permissions)
        }

        var writeType: Set<HKObjectType>?
        if !writePermissions.isEmpty {
            let permissions = writePermissions.map { Permissions[$0]! }
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
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.sumQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: .kilocalorie())
                        basalEnergyBurned.append([date: value])
                    }
                }

                resolve(["basalEnergyBurned", basalEnergyBurned])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
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
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.sumQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: .liter())
                        values.append([date: value])
                    }
                }

                resolve(["dietaryWater", values])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
        }
    }

    /// Set array of DietaryWater value
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - resolve: Return Bool of success.
    ///   - reject: Return error message.
    @objc func setDietaryWater(_ data: [[String: Double]],
                               _ resolve: @escaping RCTPromiseResolveBlock,
                               _ reject: @escaping RCTPromiseRejectBlock) {
        quantityType.setDietaryWater(data) { success, error in
            do {
                if let error = error { throw error }

                resolve(success)
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
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.averageQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: .gramUnit(with: .kilo))
                        values.append([date: value])
                    }
                }

                resolve(["bodyMass", values])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
        }
    }

    /// Set array of BodyMass value
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - resolve: Return Bool of success.
    ///   - reject: Return error message.
    @objc func setBodyMass(_ data: [[String: Double]],
                           _ resolve: @escaping RCTPromiseResolveBlock,
                           _ reject: @escaping RCTPromiseRejectBlock) {
        quantityType.setBodyMass(data) { success, error in
            do {
                if let error = error { throw error }

                resolve(success)
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
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.averageQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: .percent())
                        values.append([date: value])
                    }
                }

                resolve(["bodyFatPercentage", values])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
        }
    }

    /// Set array of BodyFatPercentage value
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - resolve: Return Bool of success.
    ///   - reject: Return error message.
    @objc func setBodyFatPercentage(_ data: [[String: Double]],
                                    _ resolve: @escaping RCTPromiseResolveBlock,
                                    _ reject: @escaping RCTPromiseRejectBlock) {
        quantityType.setBodyFatPercentage(data) { success, error in
            do {
                if let error = error { throw error }

                resolve(success)
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
        quantityType.getRestingHeartRate(startDate, endDate) { _, result, error in
            do {
                if let error = error { throw error }

                var values: [[String: Double]] = []
                result!.enumerateStatistics(from: Date(timeIntervalSince1970: startDate),
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.averageQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                        values.append([date: value])
                    }
                }

                resolve(["restingHeartRate", values])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
        }
    }

    /// Set array of RestingHeartRate value
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - resolve: Return Bool of success.
    ///   - reject: Return error message.
    @objc func setRestingHeartRate(_ data: [[String: Double]],
                                   _ resolve: @escaping RCTPromiseResolveBlock,
                                   _ reject: @escaping RCTPromiseRejectBlock) {
        quantityType.setRestingHeartRate(data) { success, error in
            do {
                if let error = error { throw error }

                resolve(success)
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
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
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.sumQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: .kilocalorie())
                        values.append([date: value])
                    }
                }

                resolve(["activeEnergyBurned", values])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
        }
    }

    /// Set array of ActiveEnergyBurned value
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - resolve: Return Bool of success.
    ///   - reject: Return error message.
    @objc func setActiveEnergyBurned(_ data: [[String: Double]],
                                     _ resolve: @escaping RCTPromiseResolveBlock,
                                     _ reject: @escaping RCTPromiseRejectBlock) {
        quantityType.setActiveEnergyBurned(data) { success, error in
            do {
                if let error = error { throw error }

                resolve(success)
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
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.sumQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: .count())
                        values.append([date: value])
                    }
                }

                resolve(["flightsClimbed", values])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
        }
    }

    /// Set array of FlightsClimbed value
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - resolve: Return Bool of success.
    ///   - reject: Return error message.
    @objc func setFlightsClimbed(_ data: [[String: Double]],
                                 _ resolve: @escaping RCTPromiseResolveBlock,
                                 _ reject: @escaping RCTPromiseRejectBlock) {
        quantityType.setFlightsClimbed(data) { success, error in
            do {
                if let error = error { throw error }

                resolve(success)
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
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.sumQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: .count())
                        values.append([date: value])
                    }
                }

                resolve(["stepCount", values])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
        }
    }

    /// Set array of StepCount value
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - resolve: Return Bool of success.
    ///   - reject: Return error message.
    @objc func setStepCount(_ data: [[String: Double]],
                            _ resolve: @escaping RCTPromiseResolveBlock,
                            _ reject: @escaping RCTPromiseRejectBlock) {
        quantityType.setStepCount(data) { success, error in
            do {
                if let error = error { throw error }

                resolve(success)
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
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.sumQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: .meter())
                        values.append([date: value])
                    }
                }

                resolve(["distanceWalkingRunning", values])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
        }
    }

    /// Set array of DistanceWalkingRunning value
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - resolve: Return Bool of success.
    ///   - reject: Return error message.
    @objc func setDistanceWalkingRunning(_ data: [[String: Double]],
                                         _ resolve: @escaping RCTPromiseResolveBlock,
                                         _ reject: @escaping RCTPromiseRejectBlock) {
        quantityType.setDistanceWalkingRunning(data) { success, error in
            do {
                if let error = error { throw error }

                resolve(success)
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
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.sumQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: .kilocalorie())
                        values.append([date: value])
                    }
                }

                resolve(["dietaryEnergyConsumed", values])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
        }
    }

    /// Set array of DietaryEnergyConsumed value
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - resolve: Return Bool of success.
    ///   - reject: Return error message.
    @objc func setDietaryEnergyConsumed(_ data: [[String: Double]],
                                        _ resolve: @escaping RCTPromiseResolveBlock,
                                        _ reject: @escaping RCTPromiseRejectBlock) {
        quantityType.setDietaryEnergyConsumed(data) { success, error in
            do {
                if let error = error { throw error }

                resolve(success)
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
                                            to: Date(timeIntervalSince1970: endDate)) { statistic, _ in
                    if let quantity = statistic.averageQuantity() {
                        let date = String(Int(statistic.startDate.timeIntervalSince1970))
                        let value = quantity.doubleValue(for: .count())
                        values.append([date: value])
                    }
                }

                resolve(["bodyMassIndex", values])
            } catch {
                reject(UseHealthKitError.error.rawValue, error.localizedDescription, nil)
            }
        }
    }

    /// Set array of BodyMassIndex value
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - resolve: Return Bool of success.
    ///   - reject: Return error message.
    @objc func setBodyMassIndex(_ data: [[String: Double]],
                                _ resolve: @escaping RCTPromiseResolveBlock,
                                _ reject: @escaping RCTPromiseRejectBlock) {
        quantityType.setBodyMassIndex(data) { success, error in
            do {
                if let error = error { throw error }

                resolve(success)
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
