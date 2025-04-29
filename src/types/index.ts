// ==========================================
// Basic Type Definitions
// ==========================================

/**
 * HealthKit data types that can be accessed and modified.
 * Each type corresponds to a specific HealthKit identifier.
 * 
 * @param activeEnergyBurned - Active energy burned during exercise and daily activities (HKQuantityTypeIdentifier.activeEnergyBurned)
 * @param basalEnergyBurned - Basal energy burned at rest (HKQuantityTypeIdentifier.basalEnergyBurned)
 * @param bodyFatPercentage - Body fat percentage (HKQuantityTypeIdentifier.bodyFatPercentage)
 * @param bodyMass - Body mass (weight) (HKQuantityTypeIdentifier.bodyMass)
 * @param bodyMassIndex - Body mass index (HKQuantityTypeIdentifier.bodyMassIndex)
 * @param dietaryEnergyConsumed - Dietary energy consumed (HKQuantityTypeIdentifier.dietaryEnergyConsumed)
 * @param dietaryWater - Dietary water intake (HKQuantityTypeIdentifier.dietaryWater)
 * @param distanceWalkingRunning - Distance walked or run (HKQuantityTypeIdentifier.distanceWalkingRunning)
 * @param flightsClimbed - Flights of stairs climbed (HKQuantityTypeIdentifier.flightsClimbed)
 * @param restingHeartRate - Resting heart rate (HKQuantityTypeIdentifier.restingHeartRate)
 * @param sleepAnalysis - Sleep analysis data (HKCategoryTypeIdentifier.sleepAnalysis)
 * @param stepCount - Step count (HKQuantityTypeIdentifier.stepCount)
 * @param heartRate - Heart rate (HKQuantityTypeIdentifier.heartRate)
 * @param mindfulSession - Mindful session (HKCategoryTypeIdentifier.mindfulSession)
 * @param appleStandHour - Apple stand hour (HKCategoryTypeIdentifier.appleStandHour)
 * @param highHeartRateEvent - High heart rate event (HKCategoryTypeIdentifier.highHeartRateEvent)
 * @param lowHeartRateEvent - Low heart rate event (HKCategoryTypeIdentifier.lowHeartRateEvent)
 * @param irregularHeartRhythmEvent - Irregular heart rhythm event (HKCategoryTypeIdentifier.irregularHeartRhythmEvent)
 */
export type HealthType =
  | 'activeEnergyBurned'
  | 'basalEnergyBurned'
  | 'bodyFatPercentage'
  | 'bodyMass'
  | 'bodyMassIndex'
  | 'dietaryEnergyConsumed'
  | 'dietaryWater'
  | 'distanceWalkingRunning'
  | 'flightsClimbed'
  | 'restingHeartRate'
  | 'sleepAnalysis'
  | 'stepCount'
  | 'heartRate';


/**
 * HealthKit units for different types of measurements.
 * Each unit corresponds to a specific HKUnit.
 * 
 * @param kcal - Kilocalories (HKUnit.kilocalorie())
 * @param kJ - Kilojoules (HKUnit.kilojoule())
 * @param m - Meters (HKUnit.meter())
 * @param km - Kilometers (HKUnit.kilometer())
 * @param mi - Miles (HKUnit.mile())
 * @param ft - Feet (HKUnit.foot())
 * @param in - Inches (HKUnit.inch())
 * @param kg - Kilograms (HKUnit.gramUnit(with: .kilo))
 * @param g - Grams (HKUnit.gram())
 * @param mg - Milligrams (HKUnit.milligram())
 * @param lb - Pounds (HKUnit.pound())
 * @param oz - Ounces (HKUnit.ounce())
 * @param ml - Milliliters (HKUnit.literUnit(with: .milli))
 * @param L - Liters (HKUnit.liter())
 * @param fl_oz - Fluid ounces (HKUnit.fluidOunce())
 * @param min - Minutes (HKUnit.minute())
 * @param hr - Hours (HKUnit.hour())
 * @param day - Days (HKUnit.day())
 * @param week - Weeks (HKUnit.week())
 * @param month - Months (HKUnit.month())
 * @param year - Years (HKUnit.year())
 * @param count - Count (HKUnit.count())
 * @param count/min - Count per minute (HKUnit.count().unitDivided(by: HKUnit.minute()))
 * @param % - Percentage (HKUnit.percent())
 * @param bpm - Beats per minute (HKUnit.count().unitDivided(by: HKUnit.minute()))
 * @param null - No unit (used for category types like sleepAnalysis)
 */
export type Unit =
  | 'kcal'
  | 'kJ'
  | 'm'
  | 'km'
  | 'mi'
  | 'ft'
  | 'in'
  | 'kg'
  | 'g'
  | 'mg'
  | 'lb'
  | 'oz'
  | 'ml'
  | 'L'
  | 'fl_oz'
  | 'min'
  | 'hr'
  | 'day'
  | 'week'
  | 'month'
  | 'year'
  | 'count'
  | 'count/min'
  | '%'
  | 'bpm'
  | null;

// ==========================================
// Data Structure Definitions (Public)
// ==========================================

/**
 * Represents a single data point for quantity type measurements.
 * 
 * @param value - The numerical value of the measurement
 * @param startDate - The start date of the measurement period
 * @param endDate - The end date of the measurement period
 */
export type QuantityData = {
  value: number;
  startDate: Date;
  endDate: Date;
};

/**
 * Represents a single data point for category type measurements (like sleep analysis).
 * Note: For internal bridge communication, dates are converted to Unix timestamps.
 * 
 * @param value - The integer value representing the category
 * @param startDate - The start date of the measurement period
 * @param endDate - The end date of the measurement period
 */
export type CategoryData = {
  value: number;
  startDate: Date;
  endDate: Date;
};

// ==========================================
// Data Structure Definitions (Internal)
// ==========================================

/**
 * Basic bridge data type for quantity data
 * Contains value and timestamps
 */
export type BridgeQuantityData = {
  value: number;
  startDate: number; // Unix timestamp in seconds
  endDate: number;   // Unix timestamp in seconds
};

/**
 * Basic bridge data type for category data
 * This is used internally for communication with native modules
 */
export type BridgeCategoryData = {
  value: number;
  startDate: number; // Unix timestamp in seconds
  endDate: number;   // Unix timestamp in seconds
};

/**
 * Bridge options for queries - time range only
 */
export type BridgeGetOptions = {
  startDate: number; // Unix timestamp in seconds
  endDate: number;   // Unix timestamp in seconds
};

/**
 * Bridge options for setting data - quantity data
 */
export type BridgeSetOptions = {
  type: HealthType;
  unit: Unit;
  data: BridgeQuantityData[];
};

/**
 * Bridge options for deleting data
 */
export type BridgeDeleteOptions = {
  type: HealthType;
  startDate: number; // Unix timestamp in seconds
  endDate: number;   // Unix timestamp in seconds
};

// ==========================================
// API Interface Definitions
// ==========================================

/**
 * Options for setting HealthKit data.
 * 
 * @param type - The type of health data to set (must be a valid HealthType)
 * @param unit - The unit of measurement (must be a valid Unit for the specified type)
 * @param data - Array of data points to set
 */
export type SetOptions = {
  type: HealthType;
  unit: Unit;
  data: QuantityData[] | CategoryData[];
};

/**
 * Options for setting Category type HealthKit data.
 * This specialized type is used for category data like sleep analysis.
 * 
 * @param type - The category type (e.g., 'sleepAnalysis')
 * @param unit - Always null for category types
 * @param data - Array of category data points
 */
export type SetCategoryOptions = {
  type: Extract<HealthType, 'sleepAnalysis'>;
  unit: null;
  data: CategoryData[];
};

/**
 * Internal bridge options for setting category data
 * This is used internally for communication with native modules
 */
export type BridgeSetCategoryOptions = {
  type: Extract<HealthType, 'sleepAnalysis'>;
  unit: null;
  data: BridgeCategoryData[];
};

/**
 * Options for deleting HealthKit data.
 * 
 * @param type - The type of health data to delete (must be a valid HealthType)
 * @param startDate - The start date of the period to delete
 * @param endDate - The end date of the period to delete
 */
export type DeleteOptions = {
  type: HealthType;
  startDate: Date;
  endDate: Date;
};

/**
 * Options for retrieving HealthKit data.
 * 
 * @param startDate - The start date of the period to retrieve
 * @param endDate - The end date of the period to retrieve
 */
export type GetOptions = {
  startDate: Date;
  endDate: Date;
};

// ==========================================
// Specific Category Value Definitions
// ==========================================

/**
 * Sleep analysis values for HKCategoryValueSleepAnalysis.
 * 
 * @param inBed - The user is in bed (value: 0)
 * @param asleep - The user is asleep (value: 1)
 * @param awake - The user is awake (value: 2)
 * @param asleepCore - The user is asleep (core) (value: 3)
 * @param asleepDeep - The user is asleep (deep) (value: 4)
 * @param asleepREM - The user is asleep (REM) (value: 5)
 * @param asleepUnspecified - The user is asleep (unspecified) (value: 6)
 */
export type SleepAnalysisValue = 0 | 1 | 2 | 3 | 4 | 5 | 6;

// /**
//  * Mindful session values for HKCategoryValueMindfulSession.
//  * 
//  * @param mindful - The user is in a mindful session (value: 0)
//  */
// export type MindfulSessionValue = 0;

// /**
//  * Apple stand hour values for HKCategoryValueAppleStandHour.
//  * 
//  * @param stood - The user stood for the hour (value: 0)
//  * @param idle - The user did not stand for the hour (value: 1)
//  */
// export type AppleStandHourValue = 0 | 1;
