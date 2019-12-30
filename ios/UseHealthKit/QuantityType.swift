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

    private func getQuantitySample(identifier: HKQuantityTypeIdentifier,
                                   unit: HKUnit,
                                   value: Double,
                                   startDate: Double,
                                   endDate: Double) -> HKQuantitySample {
        return HKQuantitySample(type: HKObjectType.quantityType(forIdentifier: identifier)!,
                                quantity: HKQuantity(unit: unit, doubleValue: value),
                                start: Date(timeIntervalSince1970: startDate),
                                end: Date(timeIntervalSince1970: endDate))
    }

    func setQuantityData(_ data: [String: Any],
                         _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let identifier = getQuantityTypeIdentifiers()[data["type"] as! String]!
        let unit = HKUnit(from: data["unit"] as! String)
        let dataList = data["data"] as! [[String: Double]]

        let objects = dataList.map { getQuantitySample(identifier: identifier,
                                                       unit: unit,
                                                       value: $0["value"]!,
                                                       startDate: $0["startDate"]!,
                                                       endDate: $0["endDate"]!) }

        healthStore.save(objects) { success, error in completion(success, error) }
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

    /// Get sample data of RestingHeartRate.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    @available(iOS 11.0, *)
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
}
