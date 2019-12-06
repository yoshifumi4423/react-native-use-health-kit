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

You can access below types for both of Read and Write.

```javascript
  "sleepAnalysis",
  "heartRate",
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

```javascript
import UseHealthKit from "react-native-use-health-kit";

// Init
if (!(await UseHealthKit.isHealthDataAvailable())) {
  throw "Health Kit is not available.";
}
const permissions = [
  "sleepAnalysis",
  "heartRate",
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

// Read data to Apple-Health
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

// Write data from Apple-Health
dates = [
  {
    startDate: moment()
      .add("hours", -2)
      .unix(),
    endDate: moment()
      .add("hours", 0)
      .unix(),
    value: 111,
  },
  {
    startDate: moment()
      .add("hours", -28)
      .unix(),
    endDate: moment()
      .add("hours", -24)
      .unix(),
    value: 112,
  },
];
await UseHealthKit.setDietaryWater(dates);
await UseHealthKit.setBodyMass(dates);
await UseHealthKit.setBodyFatPercentage(dates);
await UseHealthKit.setRestingHeartRate(dates);
await UseHealthKit.setActiveEnergyBurned(dates);
await UseHealthKit.setBasalEnergyBurned(dates);
await UseHealthKit.setFlightsClimbed(dates);
await UseHealthKit.setStepCount(dates);
await UseHealthKit.setDistanceWalkingRunning(dates);
await UseHealthKit.setDietaryEnergyConsumed(dates);
await UseHealthKit.setBodyMassIndex(dates);
```

## Author

yoshifumi4423, ykpublicjp@gmail.com

## License

react-native-use-health-kit is available under the MIT license. See the LICENSE file for more info.
