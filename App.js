import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  FlatList,
  Image,
  TouchableOpacity,
  NativeEventEmitter,
  NativeModules,
  DeviceEventEmitter,
  AlertIOS
} from 'react-native';
import BackgroundTimer from 'react-native-background-timer';

var Location = require('NativeModules').Location;

export default class App extends Component {

  constructor() {
    //super - construtor da classe mae - no caso Component
    super()
    this.state = {
      agencias: [],
      latitude: 'unknown',
      longitude: 'unknown',
      checkin: '',
      error:'',
      status : ''
    }
  }

  componentDidMount() {
    fetch('http:///192.168.0.19:8080/listaagencias')
    .then(resposta => resposta.json())  
    .then(json => {
        //console.log('aqui')
        this.setState({ agencias: json });
        Location.setAgencias(json);
        this.setState({ status: 'Conectou API' })
      })
      .catch(e => {
        console.warn('Não foi possível carregar as agencias: ' + e);
        this.setState({ status: 'Erro API' })
        Location.setPlist();
      });


    // navigator.geolocation.getCurrentPosition(
    //   (position) => {
    //     const latitude = JSON.stringify(position);
    //     this.setState({ latitude: position.coords.latitude });
    //   },
    //   (error) => alert(error.message),
    //   { enableHighAccuracy: true, timeout: 1000, maximumAge: 1000 }
    // );
    // this.watchID = navigator.geolocation.watchPosition((position) => {
    //   const longitude = JSON.stringify(position);
    //   this.setState({ longitude: position.coords.longitude });


    // });

    this.watchId = navigator.geolocation.watchPosition(
      (position) => {
        this.setState({
          latitude: position.coords.latitude,
          longitude: position.coords.longitude,
          error: null,
        });
      },
      (error) => this.setState({ error: error.message }),
      { enableHighAccuracy: true, timeout: 10000, maximumAge: 1000, distanceFilter: 10 },
    );


    //BackgroundTask.schedule()

  }

  fazCheckin() {
    if (this.state.agencias[0].latitude === this.state.latitude && this.state.agencias[0].longitude === this.state.longitude) {
      //console.log('entrou true')
      this.setState({ checkin: 'checkin' });
      //this.testaBackground();
      //this.atualizaCheckin();
      console.log('faz check-in')
    }
    else {
      console.log('entrou false')
      this.setState({ checkin: 'no checkin' });
    }
    //console.log(this.state.agencias[0].latitude)
    //console.log(this.state.latitude)

  }

  atualizaCheckin(){

    BackgroundTimer.runBackgroundTimer(() => { 
      const uri  = "http://localhost:8080/checkin/"
    
      var currentdate = new Date(); 
      var datetime =  currentdate.getFullYear() + "-"
                  + (currentdate.getMonth()+1)  + "-" 
                  + currentdate.getDate() + " "  
                  + currentdate.getHours() + ":"  
                  + currentdate.getMinutes() + ":" 
                  + currentdate.getSeconds();
  
      console.log(datetime)
  
      const requestInfo = {
        method: 'POST',
        body: JSON.stringify({
          idfuncionario: 1,
          idagencia: 1, 
          hora : datetime
        }),
        headers: new Headers({
          'Content-type': 'application/json'
        })
      }
  
        fetch(uri, requestInfo)
        .then(response => {
            if(response.ok)
             return response.text();
  
            console.log(response.text())
            throw new Error("Não foi possível efetuar login")
        })
      }, 
      3000);
      console.log("Teste fora")

    
    
  }

  componentWillMount() {
    //const {NGListener} = NativeModules;
   var checkIn = DeviceEventEmitter.addListener (
     'CheckInEnter',
     (info) => { AlertIOS.alert('Incoming!')}
)};

  componentWillUnmount = () => {
    navigator.geolocation.clearWatch(this.watchID);
  }

  render() {
    return (
      <View>
        <FlatList style={styles.container}
          keyExtractor={item => String(item.id)}
          data={this.state.agencias}
          renderItem={({ item }) =>
            <View>
              <View style={{ margin: 10, flexDirection: 'row', alignItems: 'center' }}>
                <Text> {item.id} </Text>
                <Text> {item.nome} </Text>
                <Text> {item.latitude} </Text>
                <Text> {item.longitude} </Text>
              </View>
              {/* <View>
                <Text>{this.state.latitude}</Text>
                <Text>{this.state.longitude}</Text>
              </View> */}
            </View>
          }
        />
        <View>
          <View>
                <Text>{this.state.latitude}</Text>
                <Text>{this.state.longitude}</Text>
                {this.state.error ? <Text>Error: {this.state.error}</Text> : null}
                <Text>{this.state.status}</Text>
          </View>
          <TouchableOpacity onPress={() => { this.fazCheckin() }}>
            <Image style={styles.icone} source={require('./resources/checkin.png')} />
          </TouchableOpacity>
        </View>
        <View>
          <Text>{this.state.checkin}</Text>
        </View>
        <View>
          <Text style={styles.welcome}>
            {Location.greeting}
          </Text>
        </View>  
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    marginTop: 20
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 20,
  },
  icone: {
    width: 30,
    height: 30
  }
});
