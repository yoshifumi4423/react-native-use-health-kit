# react-native-use-health-kit

React Native module which allows app to access Health Kit.

## Getting started

### Installation For Expo

1. 🚨 Expo: This package is not available in the [Expo Go](https://expo.io/client) app. Learn how you can use it with [custom dev clients](/docs/Expo.md).

### Installation - For yarn

`$ yarn add react-native-use-health-kit`

### Installation - For npm

`$ npm install react-native-use-health-kit --save`

## Usage

### Permissions & Types for Write Data

You can access below types for both of Read and Write.

```typescript
  "dietaryWater",
  "bodyMass",
  "bodyFatPercentage",
  "restingHeartRate",
  "activeEnergyBurned",
  "basalEnergyBurned",
  "flightsClimbed",
  "stepCount",
  "distanceWalkingRunning",
  "dietaryEnergyConsumed",
  "bodyMassIndex",
```

### Unit

You can check more unit in [Apple's document](https://developer.apple.com/documentation/healthkit/hkunit/1615733-init).

"cal" for Calories.
“g” for Grams.
“m” for Meters.
“L” or “l” for Liters.
"count" for Count.
"min" for Minute.
"%" for Percentage.

## Example

### Authorization

```typescript
import UseHealthKit from 'react-native-use-health-kit';

// Authorization
const TYPES: HealthType[] = [
  'dietaryWater',
  'bodyMass',
  'bodyFatPercentage',
  'restingHeartRate',
  'activeEnergyBurned',
  'basalEnergyBurned',
  'flightsClimbed',
  'stepCount',
  'distanceWalkingRunning',
  'dietaryEnergyConsumed',
  'bodyMassIndex',
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
const today = moment().startOf('months');
const startDate = moment(today).add(-1, 'months').unix();
const endDate = moment(today).unix();

const functions = [];
functions.push(getActiveEnergyBurned(startDate, endDate));
functions.push(getBasalEnergyBurned(startDate, endDate));
functions.push(getBodyFatPercentage(startDate, endDate));
functions.push(getBodyMass(startDate, endDate));
functions.push(getBodyMassIndex(startDate, endDate));
functions.push(getDietaryEnergyConsumed(startDate, endDate));
functions.push(getDietaryWater(startDate, endDate));
functions.push(getDistanceWalkingRunning(startDate, endDate));
functions.push(getFlightsClimbed(startDate, endDate));
functions.push(getRestingHeartRate(startDate, endDate));
functions.push(getStepCount(startDate, endDate));

return Promise.all(functions);
```

### Write data to Apple-Health

```typescript
// Write data to Apple-Health
const date = moment().startOf('days');
const twoDaysAgo = moment(date).add(-2, 'days').unix();
const yesterday = moment(date).add(-1, 'days').unix();
const today = moment(date).unix();

const dataList: QuantitySetData[] = [
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
      { startDate: twoDaysAgo, endDate: twoDaysAgo, value: 18.0 },
      { startDate: yesterday, endDate: yesterday, value: 18.0 },
      { startDate: today, endDate: today, value: 18.0 },
    ],
  },
];

await Promise.all(dataList.map((data) => setQuantityData(data)));
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
