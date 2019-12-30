# react-native-use-health-kit

## Getting started

### Installation - For yarn

`$ yarn add react-native-use-health-kit`

### Installation - For npm

`$ npm install react-native-use-health-kit --save`

### AutoLinking - For ReactNative >= 0.60.0

[ReactNative AutoLinking](https://github.com/react-native-community/cli/blob/master/docs/autolinking.md)

1. `cd ios && pod install`

### Mostly automatic installation - For ReactNative < 0.60.0

1. `$ react-native link react-native-use-health-kit`

### Manual installation - For ReactNative < 0.60.0

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-use-health-kit` and add `UseHealthKit.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libUseHealthKit.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

## Usage

### Permissions & Types for Write Data
You can access below types for both of Read and Write.

```javascript
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

### Configuration
```javascript
import UseHealthKit from "react-native-use-health-kit";

// Init
if (!(await UseHealthKit.isHealthDataAvailable())) {
  throw "Health Kit is not available.";
}
const permissions = [
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
];
const readPermissions = permissions;
const writePermissions = permissions;
await UseHealthKit.initHealthKit(writePermissions, readPermissions);
```

### Read data from Apple-Health
```javascript
// Read data from Apple-Health
const startDate = moment()
  .add("months", -6)
  .unix();
const endDate = moment().unix();
return Promise.all([
  UseHealthKit.getDietaryWater(startDate, endDate),
  UseHealthKit.getBodyMass(startDate, endDate),
  UseHealthKit.getBodyFatPercentage(startDate, endDate),
  UseHealthKit.getRestingHeartRate(startDate, endDate),
  UseHealthKit.getActiveEnergyBurned(startDate, endDate),
  UseHealthKit.getBasalEnergyBurned(startDate, endDate),
  UseHealthKit.getFlightsClimbed(startDate, endDate),
  UseHealthKit.getStepCount(startDate, endDate),
  UseHealthKit.getDistanceWalkingRunning(startDate, endDate),
  UseHealthKit.getDietaryEnergyConsumed(startDate, endDate),
  UseHealthKit.getBodyMassIndex(startDate, endDate),
]);
```

### Write data to Apple-Health
```javascript
// Write data to Apple-Health
const today = moment().unix();
dataList = [
  // Active Energy
  {
    type: "activeEnergyBurned",
    unit: "kcal",
    data: [
      { startDate: today, endDate: today, value: 1000 },
      { startDate: today, endDate: today, value: 1200 },
    ],
  },
  // Basal Energy
  {
    type: "basalEnergyBurned",
    unit: "kcal",
    data: [
      { startDate: today, endDate: today, value: 1000 },
      { startDate: today, endDate: today, value: 1200 },
    ],
  },
  // Walking + Running Distance
  {
    type: "distance",
    unit: "m",
    data: [
      { startDate: today, endDate: today, value: 1000 },
      { startDate: today, endDate: today, value: 1200 },
    ],
  },
  // Flights Climbed
  {
    type: "flightsClimbed",
    unit: "count",
    data: [
      { startDate: today, endDate: today, value: 100 },
      { startDate: today, endDate: today, value: 200 },
    ],
  },
  // Steps
  {
    type: "stepCount",
    unit: "count",
    data: [
      { startDate: today, endDate: today, value: 3000 },
      { startDate: today, endDate: today, value: 2200 },
    ],
  },
  // Water
  {
    type: "dietaryWater",
    unit: "ml",
    data: [
      { startDate: today, endDate: today, value: 1000 },
      { startDate: today, endDate: today, value: 1200 },
    ],
  },
  // Resting Heart Rate
  {
    type: "restingHeartRate",
    unit: "count/min",
    data: [
      { startDate: today, endDate: today, value: 68 },
      { startDate: today, endDate: today, value: 69 },
    ],
  },
  // Weight
  {
    type: "bodyMass",
    unit: "kg",
    data: [
      { startDate: today, endDate: today, value: 70 },
      { startDate: today, endDate: today, value: 72 },
    ],
  },
  // Body Mass Index
  {
    type: "bodyMassIndex",
    unit: "count",
    data: [
      { startDate: today, endDate: today, value: 10.0 },
      { startDate: today, endDate: today, value: 12.0 },
    ],
  },
  // Body Fat Percentage
  {
    type: "bodyFatPercentage",
    unit: "%",
    data: [
      { startDate: today, endDate: today, value: 10.0 },
      { startDate: today, endDate: today, value: 12.0 },
    ],
  },
];



await Promise.all(
  dataList.map(data => UseHealthKit.setQuantityData(data)),
);
```

## Author

yoshifumi4423, ykpublicjp@gmail.com

## License

react-native-use-health-kit is available under the MIT license. See the LICENSE file for more info.
