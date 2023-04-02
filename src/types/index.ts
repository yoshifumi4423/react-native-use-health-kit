/**
 * @param activeEnergyBurned - active energy burned
 * @param basalEnergyBurned - basal energy burned
 * @param bodyFatPercentage - body fat percentage
 * @param bodyMass - body mass
 * @param bodyMassIndex - body mass index
 * @param dietaryEnergyConsumed - dietary energy consumed
 * @param dietaryWater - dietary water
 * @param distanceWalkingRunning - distance walking running
 * @param flightsClimbed - flights climbed
 * @param restingHeartRate - resting heart rate
 * @param stepCount - step count
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
  | 'stepCount';

/**
 * @param kcal - kilocalories
 * @param m - meters
 * @param count - count
 * @param ml - milliliters
 * @param count/min - count per minute
 * @param kg - kilograms
 * @param % - percentage
 */
export type Unit = 'kcal' | 'm' | 'count' | 'ml' | 'count/min' | 'kg' | '%';

/**
 * @param startDate - start date of the data in unix time
 * @param endDate - end date of the data in unix time
 * @param value - value of the data
 */
export type QuantityData = {
  startDate: number;
  endDate: number;
  value: number;
};

/**
 * @param type - type of the data
 * @param unit - unit of the data
 * @param data - array of data
 */
export type SetOptions = {
  type: HealthType;
  unit: Unit;
  data: QuantityData[];
};

/**
 * @param type - type of the data
 * @param startDate - start date of the data in unix time
 * @param endDate - end date of the data in unix time
 */
export type DeleteOptions = {
  type: HealthType;
  startDate: number;
  endDate: number;
};

/**
 * @param startDate - start date of the data in unix time
 * @param endDate - end date of the data in unix time
 */
export type GetOptions = {
  startDate: number;
  endDate: number;
};
