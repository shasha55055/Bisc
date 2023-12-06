<template>
    <div class="feature-flags">
      <!-- <h2>Feature Flags</h2> -->
      <div class="feature-flag">
        <label>
          <input
            type="checkbox"
            v-model="flags.uploadNewTranscript"
            @change="updateFeatureFlag('uploadNewTranscript', flags.uploadNewTranscript)"
          />
          Group A
        </label>
      </div>
      <div class="feature-flag">
        <label>
          <input
            type="checkbox"
            v-model="flags.selectQuestionTypes"
            @change="updateFeatureFlag('selectQuestionTypes', flags.selectQuestionTypes)"
          />
          Group B
        </label>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'FeatureFlags',
    data() {
      return {
        flags: {
          uploadNewTranscript: false,
          selectQuestionTypes: false,
          enableNotifications: false,
        },
      };
    },
    methods: {
      updateFeatureFlag(flag, value) {
        // TODO: make API call to update feature flag
        console.log(`Feature Flag updated: ${flag} set to ${value}`);
        // Example: this.updateFlagOnServer(flag, value);
      },
      // Example method to make an API call
      async updateFlagOnServer(flag, value) {
        try {
            // TODO: make API call to update feature flag
            console.log(`Feature Flag updated: ${flag} set to ${value}`);
            // const response = await axios.post('/api/feature-flags/update', { flag, value });
            // console.log('Flag updated on server:', response.data);
        } catch (error) {
          console.error('Error updating feature flag:', error);
        }
      }
    }
  };
  </script>
  
  <style scoped>
  /* Your existing styles */
  </style>
  