<template>
  <div>
    <h1>Biscuitt.ai Dashboard</h1>
  </div>
  <div style="background-color:#f0feff; padding: 5%; margin: 10px auto; display: inline-block;">
    <h2>User Login Info</h2>
    <UserLogins :users="users" />
    <LoginChart :users="users" />
  </div>
  <div style="background-color:#fff0f6; padding: 5%; margin: 10px auto; display: inline-block;">
    <h2>Transcript Uploads</h2>
    <UploadsChart />
  </div>
  <div>
    <div style="background-color:#fefff0; padding: 2%; margin: 10px auto;">
      <h2>Feature Flags</h2>
      <FeatureFlags />
    </div>
  </div>
</template>

<script>
import UserLogins from './UserLogins.vue';
import LoginChart from './LoginChart.vue';
import UploadsChart from './UploadsChart.vue';
import FeatureFlags from './FeatureFlags.vue';

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
  name: 'HomePage',
  components: {
    UserLogins,
    LoginChart,
    UploadsChart,
    FeatureFlags,
  },

  data() {
    return {
      // Initialize users with empty array, will be populated in mounted
      users: [],
    };
  },

  async mounted() {
    // Call your asynchronous function here and update users
    await this.helloworld();
  },

  methods: {
    async helloworld() {
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
        lastLogin: this.formatTimestamp(data.time), 
      };
      users.push(user);
    });

    // Sort the users array based on the most recent timestamp
    users.sort((a, b) => b.lastLogin.localeCompare(a.lastLogin));

    // Update the users with the result
    this.users = users.slice(0, 3);
  },
    formatTimestamp(timestamp) {
    const date = timestamp.toDate();
    return date.toLocaleString(); // Adjust the options as needed
    },
  },
};
</script>