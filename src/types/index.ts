/**
 * @param dietaryWater - water intake
 * @param bodyMass - body mass
 * @param bodyFatPercentage - body fat percentage
 * @param restingHeartRate - resting heart rate
 * @param activeEnergyBurned - active energy burned
 * @param basalEnergyBurned - basal energy burned
 * @param flightsClimbed - flights climbed
 * @param stepCount - step count
 * @param distanceWalkingRunning - distance walking running
 * @param dietaryEnergyConsumed - energy consumed
 *  @param bodyMassIndex - body mass index
 */
export type HealthType =
  | 'dietaryWater'
  | 'bodyMass'
  | 'bodyFatPercentage'
  | 'restingHeartRate'
  | 'activeEnergyBurned'
  | 'basalEnergyBurned'
  | 'flightsClimbed'
  | 'stepCount'
  | 'distanceWalkingRunning'
  | 'dietaryEnergyConsumed'
  | 'bodyMassIndex';

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
export type QuantitySetData = {
  type: HealthType;
  unit: Unit;
  data: QuantityData[];
};
