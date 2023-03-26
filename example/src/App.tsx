import React, { useCallback } from 'react';
import { StyleSheet, View, TouchableOpacity } from 'react-native';
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
  QuantitySetData,
} from 'react-native-use-health-kit';
import moment from 'moment';

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

export default function App() {
  const authorize = useCallback(async () => {
    if (TYPES.length === 0) return;

    const isAvailable = await isHealthDataAvailable();
    if (!isAvailable) throw new Error('HealthKit is not available.');

    const isAuthorized = await initHealthKit(TYPES, TYPES);
    if (!isAuthorized) throw new Error('HealthKit is not authorized.');
  }, []);

  const getData = useCallback(async () => {
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
  }, []);

  const handleGetData = useCallback(async () => {
    await authorize();
    const data = await getData();
    console.log(data);
  }, [authorize, getData]);

  const setData = useCallback(async () => {
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
  }, []);

  const handleSetData = useCallback(async () => {
    await authorize();
    await setData();
  }, [authorize, setData]);

  return (
    <View style={styles.container}>
      <TouchableOpacity onPress={handleGetData}>GetData</TouchableOpacity>
      <TouchableOpacity onPress={handleSetData}>SetData</TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
