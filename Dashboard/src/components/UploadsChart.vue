<template>
  <div class="uploads-chart">
    <canvas ref="uploadsChartCanvas"></canvas>
  </div>
</template>

<script>
import Chart from 'chart.js/auto';
import { initializeApp } from "firebase/app";
import { getFirestore, doc, getDoc } from 'firebase/firestore';

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
  name: 'UploadsChart',
  data() {
    return {
      chart: null,
      data: null,
      countValue: null, // Initialize countValue in the component's data
    };
  },
  async mounted() {
    // Fetch count from Firestore and set countValue
    await this.fetchCount();
    // Fetch data for the chart
    this.fetch();
  },
  watch: {
    data: 'createChart',
  },
  methods: {
    async fetchCount() {
      const firebaseApp = initializeApp(firebaseConfig);
      const db = getFirestore(firebaseApp);
      const docRef = doc(db, "file_tracking", "pick_file_counter");
      const docSnap = await getDoc(docRef);

      if (docSnap.exists()) {
        this.countValue = docSnap.data().count;
        console.log("Count Value:", this.countValue);
      } else {
        console.log("No such document!");
      }

      console.log('Firestore Database:', db);
    },
    async fetch() {
      this.data = await this.func();
    },
    async func() {
      return [3, 6, 4, 8, 0, this.countValue - 3];
    },
    createChart() {
      if (this.data) {
        const ctx = this.$refs.uploadsChartCanvas.getContext('2d');
        this.chart = new Chart(ctx, {
          type: 'line',
          data: {
            labels: ['2023-11-29', '2023-11-30', '2023-12-01', '2023-12-02', '2023-12-03', '2023-12-04'],
            datasets: [{
              label: 'Number of Uploads',
              data: this.data,
              backgroundColor: 'rgba(54, 162, 235, 0.5)',
              borderColor: 'rgba(54, 162, 235, 1)',
              fill: false,
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
    },
  }
};
</script>

<style scoped>
  canvas {
    width: 100%;
    height: 100%;
    margin: auto;
  }
  .uploads-chart {
    width: 100%;
    margin: 20px auto;
  }
</style>
