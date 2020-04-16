import Vue from 'vue/dist/vue.esm'
import Turbolinks from 'turbolinks'
import ActionCableVue from 'actioncable-vue';
import TurbolinksAdapter from 'vue-turbolinks'

import consumer from 'channels/consumer'

console.log('HN Stories');

Turbolinks.start()
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const env = document.body.dataset.environment || 'production'

  const appConfig = {
    development: {
      actionCable: {
        debug: true,
        debugLevel: 'error',
        connectImmediately: true,
        connectionUrl: `ws://${window.location.host}/cable`,
      }
    },
    production: {
      actionCable: {
        connectImmediately: true,
        connectionUrl: `wss://${window.location.host}/cable`,
      }
    }
  }[env]

  Vue.use(ActionCableVue, appConfig.actionCable);

  Vue.component('hn-search-results', {
    props: {
      id: String
    },
    data() {
      return {
        stories: []
      }
    },
    channels: {
      StoriesSearchChannel: {
        received(data) {
          console.log(`[hn-search-results][${this.id}:`, data)
            const json = JSON.parse(data)
            this.addStory(json)
        },
      }
    },
    methods: {
      addStory: function(story) {
        this.stories.push(story)
      }
    },
    created() {
      console.log(`[hn-search-results] subscribed ${this.id}`);

      this.$cable.subscribe({
        channel: 'StoriesSearchChannel',
        id: this.id
      });
    }
  })

  const app = new Vue({
    el: '[data-behavior=vue]',
  })
})
