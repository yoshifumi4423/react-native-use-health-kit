import Foundation
import HealthKit

/// CategoryType
final class CategoryType {
    enum CategoryTypeError: Error {
        case queryExecutionFailure(String)
        case invalidPayload
        case invalidCategoryType
        case invalidDataFormat
    }

    /// Keeps instance of HKHealthStore. Will be initialized in initializer.
    private let healthStore: HKHealthStore

    // Initializer
    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    /// Initializer
    init() {
        self.healthStore = HKHealthStore()
    }

    /// Get category sample.
    private func getCategorySample(
        identifier: HKCategoryTypeIdentifier,
        value: Int,
        startDate: Double,
        endDate: Double
    ) -> HKCategorySample {
        let type = HKObjectType.categoryType(forIdentifier: identifier)!
        
        return HKCategorySample(
            type: type,
            value: value,
            start: Date(timeIntervalSince1970: startDate),
            end: Date(timeIntervalSince1970: endDate)
        )
    }

    /// Get category type identifiers.
    private func getCategoryTypeIdentifiers() -> [String: HKCategoryTypeIdentifier] {
        return [
            "sleepAnalysis": .sleepAnalysis,
            "mindfulSession": .mindfulSession,
            "appleStandHour": .appleStandHour,
            "highHeartRateEvent": .highHeartRateEvent,
            "lowHeartRateEvent": .lowHeartRateEvent,
            "irregularHeartRhythmEvent": .irregularHeartRhythmEvent,
            "audioExposureEvent": .audioExposureEvent,
            "toothbrushingEvent": .toothbrushingEvent
            // Add newer category types conditionally for iOS 14+
            // Add other category types as needed
        ]
    }

    /// Set data of Category type.
    /// - Parameters:
    ///   - data: Dictionary.
    ///     ```
    ///     [
    ///       "type": "sleepAnalysis",
    ///       "data": [
    ///         ["value": 2, "startDate": 1_738_720_000, "endDate": 1_738_723_600]
    ///       ]
    ///     ]
    ///     ```
    func setCategoryData(
        _ data: [String: Any],
        _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void
    ) {
        guard let typeString = data["type"] as? String,
              let identifier = getCategoryTypeIdentifiers()[typeString] else {
            completion(false, CategoryTypeError.invalidCategoryType)
            return
        }

        guard let dataList = data["data"] as? [[String: Any]] else {
            completion(false, CategoryTypeError.invalidDataFormat)
            return
        }

        var categorySamples: [HKCategorySample] = []
        for sample in dataList {
            guard let value = sample["value"] as? Int,
                  let startDate = sample["startDate"] as? Double,
                  let endDate = sample["endDate"] as? Double else {
                continue
            }

            let categorySample = getCategorySample(
                identifier: identifier,
                value: value,
                startDate: startDate,
                endDate: endDate
            )
            categorySamples.append(categorySample)
        }

        if categorySamples.isEmpty {
            completion(false, CategoryTypeError.invalidDataFormat)
            return
        }

        healthStore.save(categorySamples) { success, error in
            completion(success, error)
        }
    }

    /// Get SleepAnalysis samples
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getSleepAnalysis(
        _ startDate: Double,
        _ endDate: Double,
        _ completion: @escaping (_ query: HKSampleQuery,
                               _ result: [HKSample]?,
                               _ error: Error?) -> Void)
    {
        let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = HKQuery.predicateForSamples(
            withStart: Date(timeIntervalSince1970: startDate),
            end: Date(timeIntervalSince1970: endDate),
            options: [.strictStartDate, .strictEndDate])

        let query = HKSampleQuery(
            sampleType: type,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [NSSortDescriptor(
                key: HKSampleSortIdentifierEndDate,
                ascending: true)])
        { query, results, error in
            completion(query, results, error)
        }

        healthStore.execute(query)
    }

    /// Delete Category samples between start-date and end-date
    /// - Parameters:
    ///   - data: Dictionary of data. It should be like this.
    ///         [
    ///             "type" : "sleepAnalysis"
    ///             "startDate" : 1578915422
    ///             "endDate" : 1578915422
    ///         ],
    ///  - completion: handler when the query completes
    func deleteCategoryData(
        _ data: [String: Any],
        _ completion: @escaping (_ success: Bool,
                               _ deletedObjectCount: Int,
                               _ error: Error?) -> Void)
    {
        guard let typeString = data["type"] as? String,
              let identifier = getCategoryTypeIdentifiers()[typeString],
              let start = data["startDate"] as? Double,
              let end = data["endDate"] as? Double else {
            completion(false, 0, CategoryTypeError.invalidPayload)
            return
        }

        let categoryType = HKObjectType.categoryType(forIdentifier: identifier)!
        let predicate = HKQuery.predicateForSamples(
            withStart: Date(timeIntervalSince1970: start),
            end: Date(timeIntervalSince1970: end),
            options: [])

        healthStore.deleteObjects(of: categoryType,
                                predicate: predicate)
        { success, count, error in
            completion(success, count, error)
        }
    }
}
