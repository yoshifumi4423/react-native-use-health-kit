import { NativeModules, Platform } from 'react-native';
import type { HealthType, QuantitySetData } from './types';

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

export function setQuantityData(data: QuantitySetData): Promise<boolean> {
  return UseHealthKit.setQuantityData(data);
}

export function getDietaryWater(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getDietaryWater(startDate, endDate);
}

export function getBodyMass(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getBodyMass(startDate, endDate);
}

export function getBodyFatPercentage(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getBodyFatPercentage(startDate, endDate);
}

export function getRestingHeartRate(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getRestingHeartRate(startDate, endDate);
}

export function getActiveEnergyBurned(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getActiveEnergyBurned(startDate, endDate);
}

export function getBasalEnergyBurned(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getBasalEnergyBurned(startDate, endDate);
}

export function getFlightsClimbed(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getFlightsClimbed(startDate, endDate);
}

export function getStepCount(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getStepCount(startDate, endDate);
}

export function getDistanceWalkingRunning(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getDistanceWalkingRunning(startDate, endDate);
}

export function getDietaryEnergyConsumed(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getDietaryEnergyConsumed(startDate, endDate);
}

export function getBodyMassIndex(
  startDate: number,
  endDate: number
): Promise<number> {
  return UseHealthKit.getBodyMassIndex(startDate, endDate);
}
