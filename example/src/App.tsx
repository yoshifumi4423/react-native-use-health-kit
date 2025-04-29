/* eslint-disable @typescript-eslint/no-unused-vars */
import React, { useCallback, useState } from 'react';
import {
  StyleSheet,
  View,
  TouchableOpacity,
  Text,
  ScrollView,
  SafeAreaView,
} from 'react-native';
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
  getSleepAnalysis,
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
  'sleepAnalysis',
];

type HealthData = {
  type: HealthType;
  data:
    | number
    | undefined
    | { startDate: Date; endDate: Date; value: number }[];
};

export default function App() {
  const [healthData, setHealthData] = useState<HealthData[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [expandedSections, setExpandedSections] = useState<
    Record<HealthType, boolean>
  >(
    TYPES.reduce(
      (acc, type) => ({ ...acc, [type]: false }),
      {} as Record<HealthType, boolean>
    )
  );

  const authorize = useCallback(async () => {
    try {
      if (TYPES.length === 0) return;

      const isAvailable = await isHealthDataAvailable();
      if (!isAvailable) throw new Error('HealthKit is not available.');

      const isAuthorized = await initHealthKit(TYPES, TYPES);
      if (!isAuthorized) throw new Error('HealthKit is not authorized.');
    } catch (err) {
      setError(
        err instanceof Error ? err.message : 'An unknown error occurred'
      );
      throw err;
    }
  }, []);

  const getData = useCallback(async () => {
    const today = moment().startOf('days');
    const startDate = moment(today).add(-3, 'months').toDate();
    const endDate = moment(today).endOf('days').toDate();
    const options = { startDate, endDate };

    const functions = [
      getActiveEnergyBurned(options),
      getBasalEnergyBurned(options),
      getBodyFatPercentage(options),
      getBodyMass(options),
      getBodyMassIndex(options),
      getDietaryEnergyConsumed(options),
      getDietaryWater(options),
      getDistanceWalkingRunning(options),
      getFlightsClimbed(options),
      getRestingHeartRate(options),
      getStepCount(options),
      getSleepAnalysis(options),
    ];

    const results = await Promise.all(functions);

    return TYPES.map((type, index) => ({
      type,
      data: results[index],
    }));
  }, []);

  const handleGetData = useCallback(async () => {
    try {
      setError(null);
      await authorize();
      const data = await getData();
      setHealthData(data);
    } catch (err) {
      setError(
        err instanceof Error ? err.message : 'An unknown error occurred'
      );
    }
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
      // Sleep Analysis
      {
        type: 'sleepAnalysis',
        unit: 'count',
        data: [
          {
            startDate: moment(yesterday).set({ hour: 22, minute: 0 }).toDate(),
            endDate: moment(yesterday)
              .add(1, 'days')
              .set({ hour: 6, minute: 0 })
              .toDate(),
            value: 1, // 1: Asleep
          },
        ],
      },
    ];

    return await Promise.all(
      optionsList.map((options) => setQuantityData(options))
    );
  }, []);

  const handleSetData = useCallback(async () => {
    try {
      setError(null);
      await authorize();
      await setData();
    } catch (err) {
      setError(
        err instanceof Error ? err.message : 'An unknown error occurred'
      );
    }
  }, [authorize, setData]);

  const deleteData = useCallback(async () => {
    const date = moment().startOf('days');
    const twoDaysAgo = moment(date).add(-2, 'days').toDate();
    const today = moment(date).endOf('days').toDate();

    const optionsList: DeleteOptions[] = TYPES.map((type) => ({
      type,
      startDate: twoDaysAgo,
      endDate: today,
    }));

    return await Promise.all(
      optionsList.map((options) => deleteQuantityData(options))
    );
  }, []);

  const toggleSection = useCallback((type: HealthType) => {
    setExpandedSections((prev) => ({
      ...prev,
      [type]: !prev[type],
    }));
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>HealthKit Demo</Text>
        <TouchableOpacity style={styles.button} onPress={handleGetData}>
          <Text style={styles.buttonText}>Get Data</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.button} onPress={handleSetData}>
          <Text style={styles.buttonText}>Set Data</Text>
        </TouchableOpacity>
      </View>
      {error && <Text style={styles.error}>{error}</Text>}
      <ScrollView style={styles.scrollView}>
        {healthData.map((item) => (
          <View key={item.type} style={styles.section}>
            <TouchableOpacity
              style={styles.sectionHeader}
              onPress={() => toggleSection(item.type)}
            >
              <Text style={styles.sectionTitle}>{item.type}</Text>
              <Text style={styles.toggleText}>
                {expandedSections[item.type] ? '▼' : '▶'}
              </Text>
            </TouchableOpacity>
            {expandedSections[item.type] && (
              <View style={styles.dataContainer}>
                <Text style={styles.dataValue}>
                  {JSON.stringify(item.data, null)}
                </Text>
              </View>
            )}
          </View>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  scrollView: {
    flex: 1,
    padding: 16,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
  },
  button: {
    backgroundColor: '#007AFF',
    padding: 12,
    borderRadius: 8,
    minWidth: 100,
    alignItems: 'center',
  },
  buttonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  error: {
    color: '#FF3B30',
    textAlign: 'center',
    marginBottom: 16,
  },
  section: {
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    overflow: 'hidden',
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
    backgroundColor: '#f5f5f5',
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  toggleText: {
    fontSize: 16,
  },
  dataContainer: {
    backgroundColor: 'white',
    padding: 12,
  },
  dataValue: {
    fontSize: 14,
    color: '#666',
  },
});
