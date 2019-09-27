import React from 'react';
import {
  StyleSheet,
  Text,
  View,
  NativeModules,
  TouchableOpacity,
} from 'react-native';
// import UseHealthKit from 'react-native-use-health-kit';

export default class App extends React.Component {
  constructor() {
    super();
    this.state = {
      isAvailable: false,
    };
  }
  render() {
    console.log(NativeModules);
    console.log(NativeModules.UseHealthKit);
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>☆UseHealthKit example☆</Text>
        <Text style={styles.instructions}>STATUS: loaded</Text>
        <Text style={styles.welcome}>☆☆☆</Text>
        <Text style={styles.welcome}>count : {this.state.count}</Text>
        <TouchableOpacity onPress={this.onPressIsHealthDataAvailable}>
          <Text>isAvailable? {this.state.isAvailable ? 'Yes' : 'No'}</Text>
        </TouchableOpacity>
      </View>
    );
  }

  onPressIsHealthDataAvailable = async () => {
    try {
      const isAvailable = await NativeModules.UseHealthKit.isHealthDataAvailable();
      this.setState({isAvailable});
    } catch (error) {
      console.log(error);
    }
  };
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
