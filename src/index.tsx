import { NativeModules, Platform } from 'react-native';
import type {
  DeleteOptions,
  GetOptions,
  HealthType,
  SetOptions,
} from './types';

export * from './types';

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

export function isHealthDataAvailable(): Promise<boolean> {
  return UseHealthKit.isHealthDataAvailable();
}

export function initHealthKit(
  readPermissions: HealthType[],
  writePermissions: HealthType[]
): Promise<boolean> {
  return UseHealthKit.initHealthKit(readPermissions, writePermissions);
}

export function setQuantityData(options: SetOptions): Promise<boolean> {
  return UseHealthKit.setQuantityData(options);
}

export function deleteQuantityData(options: DeleteOptions): Promise<boolean> {
  return UseHealthKit.deleteQuantityData(options);
}

export function getDietaryWater(options: GetOptions): Promise<number> {
  return UseHealthKit.getDietaryWater(options.startDate, options.endDate);
}

export function getBodyMass(options: GetOptions): Promise<number> {
  return UseHealthKit.getBodyMass(options.startDate, options.endDate);
}

export function getBodyFatPercentage(options: GetOptions): Promise<number> {
  return UseHealthKit.getBodyFatPercentage(options.startDate, options.endDate);
}

export function getRestingHeartRate(options: GetOptions): Promise<number> {
  return UseHealthKit.getRestingHeartRate(options.startDate, options.endDate);
}

export function getActiveEnergyBurned(options: GetOptions): Promise<number> {
  return UseHealthKit.getActiveEnergyBurned(options.startDate, options.endDate);
}

export function getBasalEnergyBurned(options: GetOptions): Promise<number> {
  return UseHealthKit.getBasalEnergyBurned(options.startDate, options.endDate);
}

export function getFlightsClimbed(options: GetOptions): Promise<number> {
  return UseHealthKit.getFlightsClimbed(options.startDate, options.endDate);
}

export function getStepCount(options: GetOptions): Promise<number> {
  return UseHealthKit.getStepCount(options.startDate, options.endDate);
}

export function getDistanceWalkingRunning(
  options: GetOptions
): Promise<number> {
  return UseHealthKit.getDistanceWalkingRunning(
    options.startDate,
    options.endDate
  );
}

export function getDietaryEnergyConsumed(options: GetOptions): Promise<number> {
  return UseHealthKit.getDietaryEnergyConsumed(
    options.startDate,
    options.endDate
  );
}

export function getBodyMassIndex(options: GetOptions): Promise<number> {
  return UseHealthKit.getBodyMassIndex(options.startDate, options.endDate);
}
