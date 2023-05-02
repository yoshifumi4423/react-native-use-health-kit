import React, { useCallback } from 'react';
import { StyleSheet, View, TouchableOpacity, Text } from 'react-native';
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
import moment from 'moment';

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

export default function App() {
  const authorize = useCallback(async () => {
    if (TYPES.length === 0) return;

    const isAvailable = await isHealthDataAvailable();
    if (!isAvailable) throw new Error('HealthKit is not available.');

    const isAuthorized = await initHealthKit(TYPES, TYPES);
    if (!isAuthorized) throw new Error('HealthKit is not authorized.');
  }, []);

  const getData = useCallback(async () => {
    const today = moment().startOf('days');
    const startDate = moment(today).add(-3, 'months').toDate();
    const endDate = moment(today).endOf('days').toDate();
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

  const handleGetData = useCallback(async () => {
    await authorize();
    await getData();
  }, [authorize, getData]);

  const setData = useCallback(async () => {
    const date = moment().startOf('days');
    const twoDaysAgo = moment(date).add(-2, 'days').toDate();
    const yesterday = moment(date).add(-1, 'days').toDate();
    const today = moment(date).toDate();

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

  const handleSetData = useCallback(async () => {
    await authorize();
    await setData();
  }, [authorize, setData]);

  const deleteData = useCallback(async () => {
    const date = moment().startOf('days');
    const twoDaysAgo = moment(date).add(-2, 'days').toDate();
    const yesterday = moment(date).add(-1, 'days').toDate();
    const today = moment(date).endOf('days').toDate();

    const optionsList: DeleteOptions[] = [
      // Active Energy
      { type: 'activeEnergyBurned', startDate: twoDaysAgo, endDate: today },
      // Basal Energy
      { type: 'basalEnergyBurned', startDate: twoDaysAgo, endDate: today },
      // Walking + Running Distance
      { type: 'distanceWalkingRunning', startDate: twoDaysAgo, endDate: today },
      // Flights Climbed
      { type: 'flightsClimbed', startDate: twoDaysAgo, endDate: today },
      // Steps
      { type: 'stepCount', startDate: twoDaysAgo, endDate: today },
      // Water
      { type: 'dietaryWater', startDate: twoDaysAgo, endDate: today },
      // Resting Heart Rate
      { type: 'restingHeartRate', startDate: twoDaysAgo, endDate: today },
      // Weight
      { type: 'bodyMass', startDate: twoDaysAgo, endDate: today },
      // Body Mass Index
      { type: 'bodyMassIndex', startDate: twoDaysAgo, endDate: today },
      // Body Fat Percentage
      { type: 'bodyFatPercentage', startDate: twoDaysAgo, endDate: today },
    ];

    return await Promise.all(
      optionsList.map((options) => deleteQuantityData(options))
    );
  }, []);

  const handleDeleteData = useCallback(async () => {
    await authorize();
    console.log(await deleteData());
  }, [authorize, deleteData]);

  return (
    <View style={styles.container}>
      <TouchableOpacity style={styles.button} onPress={handleGetData}>
        <Text>GetData</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.button} onPress={handleSetData}>
        <Text>SetData</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.button} onPress={handleDeleteData}>
        <Text>DeleteData</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  button: {
    width: 120,
    height: 60,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'gray',
    marginVertical: 20,
  },
});
