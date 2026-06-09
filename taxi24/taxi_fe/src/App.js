import React from 'react';
import './App.css';

import Customer from './components/Customer';
import Driver from './components/Driver';

function App() {
  return (
    <div className="App">
      <Customer username="luciano"/>
      <Driver username="frodo"/>
      <Driver username="pipin"/>
      <Driver username="samwise"/>
    </div>
  );
}

export default App;
