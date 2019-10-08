import HealthKit

/// Get BaselEnergyBurned.
///
/// - Parameters:
///   - resolve: Return true if process is succeeded.
///   - reject: Return error message if process is failed.
func getQueryOfBasalEnergyBurned(_ startDate: Date, _ endDate: Date, _ callback: @escaping (HKSampleQuery, [HKSample]?, Error?) -> Void) -> HKQuery {
    let type = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
//    let startDate = RCTAppleHealthKit.date(fromOptions: input, key: "startDate", withDefault: nil)
//    let endDate = RCTAppleHealthKit.date(fromOptions: input, key: "endDate", withDefault: Date())
    let endDate = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

//    if startDate == nil {
//        reject(Error.error.rawValue, Error.noStartDate.rawValue, nil)
//        return
//    }

    return HKSampleQuery(sampleType: type,
                         predicate: nil,
                         limit: HKObjectQueryNoLimit,
                         sortDescriptors: [endDate]) { query, results, error in callback(query, results, error) }
}
