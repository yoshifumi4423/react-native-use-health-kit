import Foundation
import HealthKit

/// QuantityType
class QuantityType {
    enum QuantityTypeError: Error {
        case queryExecutionFailure(String)
    }

    /// Keeps instance of HKHealthStore. Will be initialized in initializer.
    private let healthStore: HKHealthStore

    /// Initializer.
    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    /// Initializer
    init() {
        healthStore = HKHealthStore()
    }

    /// Get sample data of DietaryWater.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getDietaryWater(_ startDate: Double,
                         _ endDate: Double,
                         _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        let options: HKStatisticsOptions = [.cumulativeSum]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of DietaryWater value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setDietaryWater(_ data: [[String: Double]],
                         _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        let unit = HKUnit.liter()
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of BodyMass.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getBodyMass(_ startDate: Double,
                     _ endDate: Double,
                     _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let options: HKStatisticsOptions = [.discreteAverage]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of BodyMass value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setBodyMass(_ data: [[String: Double]],
                     _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let unit = HKUnit.gramUnit(with: .kilo)
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of BodyFatPercentage.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getBodyFatPercentage(_ startDate: Double,
                              _ endDate: Double,
                              _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!
        let options: HKStatisticsOptions = [.discreteAverage]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of BodyFatPercentage value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setBodyFatPercentage(_ data: [[String: Double]],
                              _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!
        let unit = HKUnit.percent()
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of RestingHeartRate.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getRestingHeartRate(_ startDate: Double,
                             _ endDate: Double,
                             _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        let options: HKStatisticsOptions = [.discreteAverage]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of RestingHeartRate value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setRestingHeartRate(_ data: [[String: Double]],
                             _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        let unit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of ActiveEnergyBurned.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getActiveEnergyBurned(_ startDate: Double,
                               _ endDate: Double,
                               _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let options: HKStatisticsOptions = [.cumulativeSum]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of ActiveEnergyBurned value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setActiveEnergyBurned(_ data: [[String: Double]],
                               _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let unit = HKUnit.kilocalorie()
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of BasalEnergyBurned.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getBasalEnergyBurned(_ startDate: Double,
                              _ endDate: Double,
                              _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        let options: HKStatisticsOptions = [.cumulativeSum]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of BasalEnergyBurned value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setBasalEnergyBurned(_ data: [[String: Double]],
                              _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        let unit = HKUnit.kilocalorie()
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of FlightsClimbed.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getFlightsClimbed(_ startDate: Double,
                           _ endDate: Double,
                           _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .flightsClimbed)!
        let options: HKStatisticsOptions = [.cumulativeSum]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of FlightsClimbed value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setFlightsClimbed(_ data: [[String: Double]],
                           _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .flightsClimbed)!
        let unit = HKUnit.count()
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of StepCount.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getStepCount(_ startDate: Double,
                      _ endDate: Double,
                      _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let options: HKStatisticsOptions = [.cumulativeSum]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of StepCount value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setStepCount(_ data: [[String: Double]],
                      _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let unit = HKUnit.count()
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of DistanceWalkingRunning.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getDistanceWalkingRunning(_ startDate: Double,
                                   _ endDate: Double,
                                   _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let options: HKStatisticsOptions = [.cumulativeSum]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of DistanceWalkingRunning value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setDistanceWalkingRunning(_ data: [[String: Double]],
                                   _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let unit = HKUnit.meter()
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of DietaryEnergyConsumed.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getDietaryEnergyConsumed(_ startDate: Double,
                                  _ endDate: Double,
                                  _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let options: HKStatisticsOptions = [.cumulativeSum]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of DietaryEnergyConsumed value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setDietaryEnergyConsumed(_ data: [[String: Double]],
                                  _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let unit = HKUnit.kilocalorie()
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of BodyMassIndex.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getBodyMassIndex(_ startDate: Double,
                          _ endDate: Double,
                          _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
        let options: HKStatisticsOptions = [.discreteAverage]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

        healthStore.execute(query)
    }

    /// Set array of BodyMassIndex value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setBodyMassIndex(_ data: [[String: Double]],
                          _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
        let unit = HKUnit.count()
        let objects = data.map { HKQuantitySample(type: type,
                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }
}
