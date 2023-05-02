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
 * @param value - value of the data
 * @param startDate - start date of the data
 * @param endDate - end date of the data
 */
export type QuantityData = {
  value: number;
  startDate: Date;
  endDate: Date;
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
 * @param startDate - start date of the data
 * @param endDate - end date of the data
 */
export type DeleteOptions = {
  type: HealthType;
  startDate: Date;
  endDate: Date;
};

/**
 * @param startDate - start date of the data
 * @param endDate - end date of the data
 */
export type GetOptions = {
  startDate: Date;
  endDate: Date;
};
