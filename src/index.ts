import { NativeModules, Platform } from 'react-native';
import type {
  DeleteOptions,
  GetOptions,
  HealthType,
  SetOptions,
  SetCategoryOptions,
  BridgeSetCategoryOptions,
  BridgeSetOptions,
  BridgeDeleteOptions,
  BridgeGetOptions,
} from './types';

export * from './types';

// ==========================================
// Native Module Configuration
// ==========================================

const LINKING_ERROR =
  `The package 'react-native-use-health-kit' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const UseHealthKit =
  NativeModules.UseHealthKit ??
  new Proxy(
    {},
    {
      get() {
        throw new Error(LINKING_ERROR);
      },
    }
  );

// ==========================================
// Utility Functions
// ==========================================

/**
 * Convert Date object to Unix timestamp in seconds
 */
const convertToUnixTimestamp = (date: Date): number =>
  Math.floor(date.getTime() / 1000);

// ==========================================
// Initialization & Access Functions
// ==========================================

/**
 * Check if HealthKit is available on the device
 */
export function isHealthDataAvailable(): Promise<boolean> {
  return UseHealthKit.isHealthDataAvailable();
}

/**
 * Initialize HealthKit and request permissions
 * @param readPermissions Array of data types that need read permission
 * @param writePermissions Array of data types that need write permission
 */
export function initHealthKit(
  readPermissions: HealthType[],
  writePermissions: HealthType[]
): Promise<boolean> {
  return UseHealthKit.initHealthKit(readPermissions, writePermissions);
}

// ==========================================
// Data Retrieval Functions
// ==========================================

/**
 * Get dietary water intake data
 */
export function getDietaryWater(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getDietaryWater(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get body mass (weight) data
 */
export function getBodyMass(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getBodyMass(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get body fat percentage data
 */
export function getBodyFatPercentage(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getBodyFatPercentage(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get resting heart rate data
 */
export function getRestingHeartRate(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getRestingHeartRate(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get active energy burned data
 */
export function getActiveEnergyBurned(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getActiveEnergyBurned(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get basal energy burned data
 */
export function getBasalEnergyBurned(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getBasalEnergyBurned(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get flights climbed data
 */
export function getFlightsClimbed(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getFlightsClimbed(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get step count data
 */
export function getStepCount(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getStepCount(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get distance walking/running data
 */
export function getDistanceWalkingRunning(
  options: GetOptions
): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getDistanceWalkingRunning(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get dietary energy consumed data
 */
export function getDietaryEnergyConsumed(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getDietaryEnergyConsumed(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get BMI data
 */
export function getBodyMassIndex(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getBodyMassIndex(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

/**
 * Get sleep analysis data
 */
export function getSleepAnalysis(options: GetOptions): Promise<number> {
  const bridgeOptions: BridgeGetOptions = {
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.getSleepAnalysis(
    bridgeOptions.startDate,
    bridgeOptions.endDate
  );
}

// ==========================================
// Data Setting & Deletion Functions
// ==========================================

/**
 * Set quantity data
 */
export function setQuantityData(options: SetOptions): Promise<boolean> {
  const bridgeOptions: BridgeSetOptions = {
    type: options.type,
    unit: options.unit,
    data: options.data.map((d) => ({
      value: d.value,
      startDate: convertToUnixTimestamp(d.startDate),
      endDate: convertToUnixTimestamp(d.endDate),
    })),
  };

  return UseHealthKit.setQuantityData(bridgeOptions);
}

/**
 * Delete quantity data
 */
export function deleteQuantityData(options: DeleteOptions): Promise<boolean> {
  const bridgeOptions: BridgeDeleteOptions = {
    type: options.type,
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.deleteQuantityData(bridgeOptions);
}

/**
 * Set category data (like sleep analysis)
 */
export function setCategoryData(options: SetCategoryOptions): Promise<boolean> {
  const bridgeOptions: BridgeSetCategoryOptions = {
    type: options.type,
    unit: options.unit,
    data: options.data.map((d) => ({
      value: d.value,
      startDate: convertToUnixTimestamp(d.startDate),
      endDate: convertToUnixTimestamp(d.endDate),
    })),
  };

  return UseHealthKit.setCategoryData(bridgeOptions);
}

/**
 * Delete category data
 */
export function deleteCategoryData(options: DeleteOptions): Promise<boolean> {
  const bridgeOptions: BridgeDeleteOptions = {
    type: options.type,
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.deleteCategoryData(bridgeOptions);
}
