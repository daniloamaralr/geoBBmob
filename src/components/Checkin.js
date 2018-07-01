/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  FlatList,
  Image,
  TouchableOpacity
} from 'react-native';



export default class App extends Component {  c
  
    constructor(props){
        super(props)
        this.state = {
            foto : this.props.agencia,
            valorComentario :''
            //foto : {...this.props.foto , likers: [{}]}
        }   
    }

  fazCheckin() {
    if (this.state.agencias.latitude === this.state.latitude && this.state.agencias.longitude === this.state.longitude){
      console.log('entrou true')
      this.setState({ checkin: 'checkin'});
      atualizaCheckin();
    }
    else {
      console.log('entrou false')
      this.setState({ checkin: 'no checkin'});
    }
    console.log(this.state.agencias.latitude)
    console.log(this.state.latitude)
  }

  atualizaCheckin(){
    const uri= "http://192.168.1.138:8080/checkin/"
    
    const requestInfo = {
        method: 'POST',
        body: {
          idfuncionario: this.state.usuario,
          senha: this.state.senha,  
        }
    }

  }

  render() {
    const {agencia} = this.state //Object destructuring
    return (

        
              <View>
                    {/* <View style = {{ margin:10,flexDirection:'row', alignItems:'center'}}>
                        <Text> {agencia.id} </Text>
                        <Text> {agencia.nome} </Text>
                        <Text> {agencia.latitude} </Text>
                        <Text> {agencia.longitude} </Text>
                    </View> */}
                    {/* <View>
                    <Text>{this.state.latitude}</Text>
                    <Text>{this.state.longitude}</Text>
                    </View> */}

                {/* <View>
                    <TouchableOpacity onPress={this.fazCheckin.bind(this)}>
                            <Image style={styles.icone} source={ require('./resources/checkin.png') } />
                    </TouchableOpacity>
                </View>

                <View>
                    <Text>{this.state.checkin}</Text>
                </View> */}


              </View>

    );
  }
}

const styles = StyleSheet.create({
    container: {
      marginTop:20
    },
    icone: {
      width: 30,
      height: 30
    }
});
