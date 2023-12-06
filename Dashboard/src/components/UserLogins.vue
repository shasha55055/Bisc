<template>
    <div class="user-logins">
      <!-- <h2>User Login Activity</h2> -->
      <table>
        <thead>
          <tr>
            <!-- <th>User ID</th> -->
            <th>Name</th>
            <th>Last Login</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id">
            <!-- <td>{{ user.id }}</td> -->
            <td>{{ user.name }}</td>
            <td>{{ user.lastLogin }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </template>
  
  <script>

  // import { initializeApp } from "firebase/app";
  // import { getFirestore, doc, getDoc } from 'firebase/firestore';

  // const firebaseConfig = {
  //   apiKey: 'AIzaSyD0-Gcro2-YgPSdeDuoiHmXRq9akRteGKg',
  //   authDomain: 'biscuitt-21b7d.firebaseapp.com',
  //   databaseURL: "https://biscuitt-21b7d.firebaseio.com",
  //   projectId: 'biscuitt-21b7d',
  //   storageBucket: 'biscuitt-21b7d.appspot.com',
  //   messagingSenderId: '138914182592',
  //   appId: '1:138914182592:android:0ad3a72da157ea12534425'
  // };
  // methods: {
  //   async getUser () {

  //   }
  // }


  export default {
    name: 'UserLogins',
    props: {
        users: Array
    },
  };
  </script>
  
  <style scoped>
  .user-logins {
    margin: 20px;
  }
  
  table {
    width: 100%;
    border-collapse: collapse;
  }
  
  table, th, td {
    border: 1px solid #ddd;
    padding: 8px;
  }
  
  th {
    background-color: #f4f4f4;
  }
  </style>
  