import { NativeModules, Platform } from 'react-native';
import type {
  DeleteOptions,
  GetOptions,
  HealthType,
  SetOptions,
  Unit,
} from './types';

export * from './types';

/**
 * @param value - value of the data
 * @param startDate - start date of the data in unix timestamp
 * @param endDate - end date of the data in unix timestamp
 */
type BridgeQuantityData = {
  value: number;
  startDate: number;
  endDate: number;
};

/**
 * @param type - type of the data
 * @param unit - unit of the data
 * @param data - array of data
 */
type BridgeSetOptions = {
  type: HealthType;
  unit: Unit;
  data: BridgeQuantityData[];
};

/**
 * @param type - type of the data
 * @param startDate - start date of the data in unix timestamp
 * @param endDate - end date of the data in unix timestamp
 */
type BridgeDeleteOptions = {
  type: HealthType;
  startDate: number;
  endDate: number;
};

/**
 * @param startDate - start date of the data in unix timestamp
 * @param endDate - end date of the data in unix timestamp
 */
type BridgeGetOptions = {
  startDate: number;
  endDate: number;
};

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

const convertToUnixTimestamp = (date: Date): number =>
  Math.floor(date.getTime() / 1000);

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

export function deleteQuantityData(options: DeleteOptions): Promise<boolean> {
  const bridgeOptions: BridgeDeleteOptions = {
    type: options.type,
    startDate: convertToUnixTimestamp(options.startDate),
    endDate: convertToUnixTimestamp(options.endDate),
  };

  return UseHealthKit.deleteQuantityData(bridgeOptions);
}

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
