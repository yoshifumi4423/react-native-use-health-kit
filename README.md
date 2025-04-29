# react-native-use-health-kit

[![NPM Version](https://img.shields.io/npm/v/react-native-use-health-kit?style=flat-square)](https://www.npmjs.com/package/react-native-use-health-kit)
[![NPM Downloads](https://img.shields.io/npm/dt/react-native-use-health-kit?style=flat-square)](https://www.npmjs.com/package/react-native-use-health-kit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/yoshifumi4423/react-native-use-health-kit?style=flat-square)](https://github.com/yoshifumi4423/react-native-use-health-kit/stargazers)

React Native hook library to easily read from and write to Apple HealthKit.

<br />

## Features

*   Simple hook-based API for requesting permissions and accessing data.
*   Supports reading and writing various quantity and category types.
*   Includes an Expo Config Plugin for easy integration with Expo projects.
*   Written in TypeScript.

<br />

## Installation

```bash
# Using yarn
yarn add react-native-use-health-kit

# Using npm
npm install react-native-use-health-kit --save
```

### iOS Setup (React Native CLI)

For React Native CLI projects, ensure you run `pod install` in your `ios` directory after installing the package:

```bash
cd ios && pod install && cd ..
```

You also need to add the necessary usage descriptions and capabilities:

1.  **Info.plist:** Add the following keys with appropriate descriptions explaining why your app needs access to health data:
    *   `NSHealthShareUsageDescription` (Privacy - Health Share Usage Description)
    *   `NSHealthUpdateUsageDescription` (Privacy - Health Update Usage Description)

2.  **Signing & Capabilities:** In Xcode, go to your project target's "Signing & Capabilities" tab and add the "HealthKit" capability. This will add the necessary entitlements file to your project.

### iOS Setup (Expo)

This package includes an [Expo Config Plugin](https://docs.expo.dev/guides/config-plugins/) that automatically configures your iOS project (`Info.plist` and entitlements) during the prebuild process.

1.  Add the plugin to your `app.json` or `app.config.js`:

    ```json
    {
      "expo": {
        "plugins": [
          ["react-native-use-health-kit", {
            "healthSharePermission": "Allow $(PRODUCT_NAME) to read health data.",
            "healthUpdatePermission": "Allow $(PRODUCT_NAME) to write health data."
            // "isClinicalDataEnabled": false // Optional: Set to true if you need access to clinical health records
          }]
        ]
      }
    }
    ```

    *   `healthSharePermission` (optional): Custom description for reading health data.
    *   `healthUpdatePermission` (optional): Custom description for writing health data.
    *   `isClinicalDataEnabled` (optional, defaults to `false`): Set to `true` to enable access to clinical health records (requires specific entitlements).

2.  Run `expo prebuild --platform ios` (or `npx expo prebuild --platform ios`) to apply the changes. You need to use `expo build` or EAS Build, as this package requires native code and is **not available in Expo Go**.

<br />

## Supported Data Types

This library supports reading and/or writing the following `HealthType` identifiers:

**Quantity Types (Read & Write):**

*   `activeEnergyBurned`
*   `basalEnergyBurned`
*   `bodyFatPercentage`
*   `bodyMass` (Weight)
*   `bodyMassIndex` (BMI)
*   `dietaryEnergyConsumed`
*   `dietaryWater`
*   `distanceWalkingRunning`
*   `flightsClimbed`
*   `restingHeartRate`
*   `stepCount`

**Category Types (Read & Write):**

*   `sleepAnalysis`

<br />

## Available Units

You can specify units when writing data. Common units include:

*   Energy: `'cal'`, `'kcal'`
*   Mass: `'g'`, `'kg'`, `'lb'`
*   Length: `'m'`, `'km'`, `'ft'`, `'mi'`
*   Volume: `'l'`, `'ml'`, `'oz'` (Fluid ounce)
*   Percentage: `'%'`
*   Count: `'count'`
*   Time: `'min'`, `'hr'`, `'s'`
*   Rate: `'count/min'` (e.g., for Heart Rate)

Refer to [Apple's HKUnit documentation](https://developer.apple.com/documentation/healthkit/hkunit/1615733-init) for a complete list. The library expects the string representation (e.g., `'kg'`, not `HKUnit.gramUnit(with: .kilo)`).

<br />

## Usage

### 1. Request Authorization

First, check if HealthKit is available and request authorization for the data types you need.

```typescript
import React, { useCallback } from 'react';
import {
  isHealthDataAvailable,
  initHealthKit,
  HealthType,
} from 'react-native-use-health-kit';

const readTypes: HealthType[] = [
  'stepCount',
  'distanceWalkingRunning',
  'activeEnergyBurned',
  'sleepAnalysis',
  // ... add other types you need to read
];

const writeTypes: HealthType[] = [
  'stepCount',
  'distanceWalkingRunning',
  'sleepAnalysis',
  // ... add other types you need to write
];

function MyComponent() {
  const [isAuthorized, setIsAuthorized] = React.useState(false);
  const [error, setError] = React.useState<string | null>(null);

  const requestAuthorization = useCallback(async () => {
    setError(null);
    try {
      const available = await isHealthDataAvailable();
      if (!available) {
        throw new Error('HealthKit is not available on this device.');
      }

      const authorized = await initHealthKit(readTypes, writeTypes);
      if (!authorized) {
        throw new Error('Authorization failed or was denied by the user.');
      }
      setIsAuthorized(true);
      console.log('HealthKit Authorized!');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Authorization error');
      setIsAuthorized(false);
    }
}, []);

  // Call requestAuthorization() when needed, e.g., in a useEffect or button press
  // ...
}
```

### 2. Read Data

Use the specific getter functions for each data type. Provide `startDate` and `endDate` as `Date` objects.

```typescript
import { getStepCount, getSleepAnalysis } from 'react-native-use-health-kit';

// Example: Get step count and sleep data for the last 7 days
const fetchHealthData = async () => {
  const endDate = new Date();
  const startDate = new Date();
  startDate.setDate(endDate.getDate() - 7);

  const options = { startDate, endDate };

  try {
    const steps = await getStepCount(options);
    console.log('Total steps:', steps); // Returns a single aggregated number

    const sleepSamples = await getSleepAnalysis(options);
    console.log('Sleep samples:', sleepSamples);
    // Returns an array of objects:
    // [{ startDate: Date, endDate: Date, value: number (HKCategoryValueSleepAnalysis) }, ...]

  } catch (error) {
    console.error("Error fetching health data:", error);
  }
};
```

**Note:** Most `get...` functions (for quantity types) return a `Promise<number>` representing the sum or average of the data points within the specified range. `getSleepAnalysis` (and potentially future category type getters) returns a `Promise<Array<{ startDate: Date, endDate: Date, value: number }>>`.

### 3. Write Quantity Data

Use `setQuantityData` to write numerical data like steps, weight, or energy.

```typescript
import { setQuantityData, HealthType, HealthUnit } from 'react-native-use-health-kit';

const writeSteps = async () => {
  const now = new Date();
  const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const twoHoursAgo = new Date(now.getTime() - 2 * 60 * 60 * 1000);

  const options = {
    type: 'stepCount' as HealthType, // Explicitly cast or ensure type safety
    unit: 'count' as HealthUnit,
      data: [
      { startDate: twoHoursAgo, endDate: now, value: 500 }, // 500 steps in the last 2 hours
      { startDate: startOfDay, endDate: startOfDay, value: 1200 }, // A single entry for 1200 steps today
    ],
  };

  try {
    const success = await setQuantityData(options);
    if (success) {
      console.log('Step data saved successfully!');
    } else {
      console.log('Failed to save step data.');
    }
  } catch (error) {
    console.error('Error saving step data:', error);
  }
};
```

### 4. Write Category Data

Use `setCategoryData` for category types like sleep analysis. The `value` corresponds to specific constants defined by HealthKit (e.g., `HKCategoryValueSleepAnalysis`).

```typescript
import { setCategoryData, HealthType } from 'react-native-use-health-kit';
// The SleepAnalysisValue type (0 | 1 | ...) is exported, use numeric literals directly.

const writeSleep = async () => {
  const lastNightStart = new Date();
  lastNightStart.setDate(lastNightStart.getDate() - 1);
  lastNightStart.setHours(22, 0, 0, 0); // 10 PM last night

  const thisMorningEnd = new Date();
  thisMorningEnd.setHours(6, 30, 0, 0); // 6:30 AM this morning

  const options = {
    type: 'sleepAnalysis' as HealthType,
    data: [
      {
        startDate: lastNightStart,
        endDate: thisMorningEnd,
        value: 1, // SleepAnalysisValue (0-6)
      },
    ],
  };

  try {
    const success = await setCategoryData(options);
    if (success) {
      console.log('Sleep data saved successfully!');
    } else {
      console.log('Failed to save sleep data.');
    }
  } catch (error) {
    console.error('Error saving sleep data:', error);
  }
};

// Note: The 'value' should correspond to the numeric values defined in the exported
// SleepAnalysisValue (0 | 1 | 2 | 3 | 4 | 5 | 6).
// 0: HKCategoryValueSleepAnalysis.inBed
// 1: HKCategoryValueSleepAnalysis.asleep
// 2: HKCategoryValueSleepAnalysis.awake
// -- iOS 16+ Sleep Stages --
// 3: HKCategoryValueSleepAnalysis.asleepCore
// 4: HKCategoryValueSleepAnalysis.asleepDeep
// 5: HKCategoryValueSleepAnalysis.asleepREM
// 6: HKCategoryValueSleepAnalysis.awake
```

### 5. Delete Data

Use `deleteQuantityData` or `deleteCategoryData`. **Use with caution!** This permanently removes data your app has previously written.

```typescript
import { deleteQuantityData, HealthType } from 'react-native-use-health-kit';

const deleteStepsFromYesterday = async () => {
  const yesterdayStart = new Date();
  yesterdayStart.setDate(yesterdayStart.getDate() - 1);
  yesterdayStart.setHours(0, 0, 0, 0);

  const yesterdayEnd = new Date();
  yesterdayEnd.setDate(yesterdayEnd.getDate() - 1);
  yesterdayEnd.setHours(23, 59, 59, 999);

  const options = {
    type: 'stepCount' as HealthType,
    startDate: yesterdayStart,
    endDate: yesterdayEnd,
  };

  try {
    const success = await deleteQuantityData(options);
    console.log('Attempted to delete yesterday's step data:', success);
  } catch (error) {
    console.error('Error deleting step data:', error);
  }
};
```

<br />

## API Reference Summary

### Initialization

*   `isHealthDataAvailable(): Promise<boolean>`: Checks if HealthKit is available.
*   `initHealthKit(read: HealthType[], write: HealthType[]): Promise<boolean>`: Requests authorization.

### Data Reading (`Promise<number>` or `Promise<Array<...>>`)

*   `getActiveEnergyBurned(options: GetOptions)`
*   `getBasalEnergyBurned(options: GetOptions)`
*   `getBodyFatPercentage(options: GetOptions)`
*   `getBodyMass(options: GetOptions)`
*   `getBodyMassIndex(options: GetOptions)`
*   `getDietaryEnergyConsumed(options: GetOptions)`
*   `getDietaryWater(options: GetOptions)`
*   `getDistanceWalkingRunning(options: GetOptions)`
*   `getFlightsClimbed(options: GetOptions)`
*   `getRestingHeartRate(options: GetOptions)`
*   `getStepCount(options: GetOptions)`
*   `getSleepAnalysis(options: GetOptions)`: Returns `Promise<Array<{ startDate: Date, endDate: Date, value: number }>>`

### Data Writing (`Promise<boolean>`)

*   `setQuantityData(options: SetOptions)`: For numerical data.
    *   `type: HealthType`
    *   `unit: HealthUnit`
    *   `data: Array<{ startDate: Date, endDate: Date, value: number }>`
*   `setCategoryData(options: SetCategoryOptions)`: For category data.
    *   `type: HealthType`
    *   `data: Array<{ startDate: Date, endDate: Date, value: number }>`
    *   `unit` is usually omitted.

### Data Deletion (`Promise<boolean>`)

*   `deleteQuantityData(options: DeleteOptions)`
*   `deleteCategoryData(options: DeleteOptions)`
    *   `type: HealthType`
    *   `startDate: Date`
    *   `endDate: Date`

### Types

*   `HealthType`: String literal union of supported types.
*   `HealthUnit`: String literal union of supported units (pass the string identifier).
*   `GetOptions`: `{ startDate: Date, endDate: Date }`
*   `SetOptions`: `{ type: HealthType, unit: HealthUnit, data: Array<{ startDate: Date, endDate: Date, value: number }> }`
*   `SetCategoryOptions`: `{ type: HealthType, data: Array<{ startDate: Date, endDate: Date, value: number }> }`
*   `DeleteOptions`: `{ type: HealthType, startDate: Date, endDate: Date }`

<br />

## Example Project

Check the [example](./example/src/App.tsx) project for a detailed implementation.

To run the example project:

1.  Clone the repository.
2.  Install dependencies in the root directory: `yarn install`
3.  Install dependencies in the example directory: `yarn --cwd example install`
4.  Install iOS pods: `yarn --cwd example pod:install` (or `cd example/ios && pod install && cd ../..`)
5.  Run the example app: `yarn example ios` (or `yarn --cwd example ios`)

<br />

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

<br />

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
