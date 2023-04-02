# react-native-use-health-kit

React Native module which allows app to access Health Kit.

<br />

## Getting started

### Installation For Expo

Expo: This package is not available in the [Expo Go](https://expo.io/client) app. Learn how you can use it with [custom dev clients](/docs/Expo.md).

### Installation - For yarn

```bash
$ yarn add react-native-use-health-kit
```

### Installation - For npm

```
$ npm install react-native-use-health-kit --save
```

<br />

## Usage

### Permissions & Types for Write Data

You can access below types for both of Read and Write.

```ts
'activeEnergyBurned',
'basalEnergyBurned',
'bodyFatPercentage',
'bodyMass',
'bodyMassIndex',
'dietaryEnergyConsumed',
'dietaryWater',
'distanceWalkingRunning',
'flightsClimbed',
'restingHeartRate',
'stepCount',
```

### Unit

You can check more unit in [Apple's document](https://developer.apple.com/documentation/healthkit/hkunit/1615733-init).

```ts
'cal' // Calories.
'g' // Grams.
'm' // Meters.
'L' or 'l' // Liters.
'count' // Count.
'min' // Minute.
'%' // Percentage.
```

<br />

## Example

### Check [example](./example/src/App.tsx) project for details.

### How to run `example` project.

```bash
$ yarn
$ yarn example ios
```

<br />

## Example code

### Authorization

```typescript
import {
  isHealthDataAvailable,
  initHealthKit,
  HealthType,
  getActiveEnergyBurned,
  getBasalEnergyBurned,
  getBodyFatPercentage,
  getBodyMass,
  getBodyMassIndex,
  getDietaryEnergyConsumed,
  getDietaryWater,
  getDistanceWalkingRunning,
  getFlightsClimbed,
  getRestingHeartRate,
  getStepCount,
  setQuantityData,
  deleteQuantityData,
  SetOptions,
  DeleteOptions,
} from 'react-native-use-health-kit';

// Authorization
const TYPES: HealthType[] = [
  'activeEnergyBurned',
  'basalEnergyBurned',
  'bodyFatPercentage',
  'bodyMass',
  'bodyMassIndex',
  'dietaryEnergyConsumed',
  'dietaryWater',
  'distanceWalkingRunning',
  'flightsClimbed',
  'restingHeartRate',
  'stepCount',
];
const authorize = useCallback(async () => {
  if (TYPES.length === 0) return;

  const isAvailable = await isHealthDataAvailable();
  if (!isAvailable) throw new Error('HealthKit is not available.');

  const isAuthorized = await initHealthKit(TYPES, TYPES);
  if (!isAuthorized) throw new Error('HealthKit is not authorized.');
}, []);
```

### Read data from Apple-Health

```typescript
// Read data from Apple-Health
const getData = useCallback(async () => {
  const today = moment().startOf('days');
  const startDate = moment(today).add(-3, 'months').unix();
  const endDate = moment(today).endOf('days').unix();
  const options = { startDate, endDate };

  const functions = [];
  functions.push(getActiveEnergyBurned(options));
  functions.push(getBasalEnergyBurned(options));
  functions.push(getBodyFatPercentage(options));
  functions.push(getBodyMass(options));
  functions.push(getBodyMassIndex(options));
  functions.push(getDietaryEnergyConsumed(options));
  functions.push(getDietaryWater(options));
  functions.push(getDistanceWalkingRunning(options));
  functions.push(getFlightsClimbed(options));
  functions.push(getRestingHeartRate(options));
  functions.push(getStepCount(options));

  return Promise.all(functions);
}, []);
```

### Write data to Apple-Health

```typescript
// Write data to Apple-Health
const setData = useCallback(async () => {
  const date = moment().startOf('days');
  const twoDaysAgo = moment(date).add(-2, 'days').unix();
  const yesterday = moment(date).add(-1, 'days').unix();
  const today = moment(date).unix();

  const optionsList: SetOptions[] = [
    // Active Energy
    {
      type: 'activeEnergyBurned',
      unit: 'kcal',
      data: [
        { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 1000 },
        { startDate: yesterday, endDate: yesterday, value: 1100 },
        { startDate: today, endDate: today, value: 1200 },
      ],
    },
    // Basal Energy
    {
      type: 'basalEnergyBurned',
      unit: 'kcal',
      data: [
        { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 1000 },
        { startDate: yesterday, endDate: yesterday, value: 1100 },
        { startDate: today, endDate: today, value: 1200 },
      ],
    },
    // Walking + Running Distance
    {
      type: 'distanceWalkingRunning',
      unit: 'm',
      data: [
        { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 1000 },
        { startDate: yesterday, endDate: yesterday, value: 1100 },
        { startDate: today, endDate: today, value: 1200 },
      ],
    },
    // Flights Climbed
    {
      type: 'flightsClimbed',
      unit: 'count',
      data: [
        { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 100 },
        { startDate: yesterday, endDate: yesterday, value: 110 },
        { startDate: today, endDate: today, value: 120 },
      ],
    },
    // Steps
    {
      type: 'stepCount',
      unit: 'count',
      data: [
        { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 1000 },
        { startDate: yesterday, endDate: yesterday, value: 1100 },
        { startDate: today, endDate: today, value: 1200 },
      ],
    },
    // Water
    {
      type: 'dietaryWater',
      unit: 'ml',
      data: [
        { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 1000 },
        { startDate: yesterday, endDate: yesterday, value: 1100 },
        { startDate: today, endDate: today, value: 1200 },
      ],
    },
    // Resting Heart Rate
    {
      type: 'restingHeartRate',
      unit: 'count/min',
      data: [
        { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 65 },
        { startDate: yesterday, endDate: yesterday, value: 66 },
        { startDate: today, endDate: today, value: 67 },
      ],
    },
    // Weight
    {
      type: 'bodyMass',
      unit: 'kg',
      data: [
        { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 70 },
        { startDate: yesterday, endDate: yesterday, value: 70.5 },
        { startDate: today, endDate: today, value: 71 },
      ],
    },
    // Body Mass Index
    {
      type: 'bodyMassIndex',
      unit: 'count',
      data: [
        { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 18.0 },
        { startDate: yesterday, endDate: yesterday, value: 18.0 },
        { startDate: today, endDate: today, value: 18.0 },
      ],
    },
    // Body Fat Percentage
    {
      type: 'bodyFatPercentage',
      unit: '%',
      data: [
        { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 0.18 },
        { startDate: yesterday, endDate: yesterday, value: 0.18 },
        { startDate: today, endDate: today, value: 0.18 },
      ],
    },
  ];

  return await Promise.all(
    optionsList.map((options) => setQuantityData(options))
  );
}, []);
```

<br />

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

<br />

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
