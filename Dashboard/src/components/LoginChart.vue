<template>
    <div class="login-chart">
      <canvas ref="chart"></canvas>
    </div>
  </template>
  
  <script>
  import Chart from 'chart.js/auto';
  import { initializeApp } from "firebase/app";
  import { getFirestore, collection, getDocs } from 'firebase/firestore';

  const firebaseConfig = {
    apiKey: 'AIzaSyD0-Gcro2-YgPSdeDuoiHmXRq9akRteGKg',
    authDomain: 'biscuitt-21b7d.firebaseapp.com',
    databaseURL: "https://biscuitt-21b7d.firebaseio.com",
    projectId: 'biscuitt-21b7d',
    storageBucket: 'biscuitt-21b7d.appspot.com',
    messagingSenderId: '138914182592',
    appId: '1:138914182592:android:0ad3a72da157ea12534425'
  };
  
  export default {
    name: 'LoginChart',
    props: {
      users: Array,
    },
    data() {
      return {
        chart: null,
        fakeData: [
          { name: 'User 1', logins: 7 },
          { name: 'User 2', logins: 5 },
        ],
      };
    },
    mounted() {
      this.load();
    },
    methods: {
      async load() {
        await this.userUpdate();
        await this.initChart();
      },
      async userUpdate() {
      // Simulating an asynchronous operation
      await new Promise(resolve => setTimeout(resolve, 1000));
      const firebaseApp = initializeApp(firebaseConfig);
      const db = getFirestore(firebaseApp);
      const loginsCollection = collection(db, 'logins');

      // Get all documents in the "logins" collection
      const snapshot = await getDocs(loginsCollection);

      // Process each document in the snapshot
      const users = [];
      snapshot.forEach((doc) => {
        const data = doc.data();
        console.log(data.username)
        const user = {
          id: 1,
          name: data.username, 
          lastLogin: "hi", 
        };
        users.push(user);
      });

      // Update the users with the result
      this.fakeData = [
          { name: 'User1', logins: users.length - 2 },
          { name: 'User 2', logins: 5 },
        ]
    },
      
      initChart() {
        const ctx = this.$refs.chart.getContext('2d');
        this.chart = new Chart(ctx, {
          type: 'bar',
          data: {
            labels: this.fakeData.map(user => user.name),
            datasets: [{
              label: 'Number of Logins',
              data: this.fakeData.map(user => user.logins),
              backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
              ],
              borderColor: [
                'rgba(255, 99, 132, 1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
              ],
              borderWidth: 1
            }]
          },
          options: {
            scales: {
              y: {
                beginAtZero: true
              }
            },
            responsive: false,
          }
        });
      }
    }
  };
  </script>
  
  <style scoped>
    canvas {
        width: 100%;
        height: 100%;
        margin: auto;
    }
    .login-chart {
        width: 100%;
        /* max-width: 600px; */
        margin: 20px auto;
    }
  </style>
  