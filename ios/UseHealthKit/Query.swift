import Foundation
import HealthKit

class Query {
    /// Get HKSampleQuery.
    ///
    /// - Parameters:
    ///   - type: type to get data.
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    static func makeHKSampleQuery(_ type: HKQuantityType,
                                  _ startDate: Double,
                                  _ endDate: Double,
                                  _ completion: @escaping (_ query: HKSampleQuery, _ results: [HKSample]?, _ error: Error?) -> Void) -> HKSampleQuery {
        let predicate = HKQuery.predicateForSamples(withStart: Date(timeIntervalSince1970: startDate),
                                                    end: Date(timeIntervalSince1970: endDate),
                                                    options: [.strictStartDate, .strictEndDate])
        let limit = HKObjectQueryNoLimit
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let query = HKSampleQuery(sampleType: type,
                                  predicate: predicate,
                                  limit: limit,
                                  sortDescriptors: [sortDescriptor]) { query, results, error in completion(query, results, error) }

        return query
    }

    /// Get HKStatisticsCollectionQuery.
    /// - Parameters:
    ///   - type: type to get data.
    ///   - options: <#options description#>
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - predicate: <#predicate description#>
    ///   - anchorDate: <#anchorDate description#>
    ///   - interval: interval of collection. Default value is 1 day.
    ///   - completion: handler when the query completes.
    static func makeHKStatisticsCollectionQuery(_ type: HKQuantityType,
                                                _ options: HKStatisticsOptions,
                                                _ startDate: Double,
                                                _ endDate: Double,
                                                _ predicate: NSPredicate? = nil,
                                                _ anchorDate: Date? = nil,
                                                _ interval: DateComponents? = nil) -> HKStatisticsCollectionQuery {
        let _predicate = HKQuery.predicateForSamples(withStart: Date(timeIntervalSince1970: startDate),
                                                     end: Date(timeIntervalSince1970: endDate),
                                                     options: [.strictStartDate, .strictEndDate])

        let from = Date(timeIntervalSince1970: startDate)
        var anchorDateComponent = Calendar.current.dateComponents([.year, .month, .day], from: from)
        anchorDateComponent.hour = 0
        let _anchorDate = Calendar.current.date(from: anchorDateComponent)!

        var _interval = DateComponents()
        _interval.day = 1

        return HKStatisticsCollectionQuery(quantityType: type,
                                           quantitySamplePredicate: (predicate != nil) ? predicate! : _predicate,
                                           options: options,
                                           anchorDate: (anchorDate != nil) ? anchorDate! : _anchorDate,
                                           intervalComponents: (interval != nil) ? interval! : _interval)
    }
}
