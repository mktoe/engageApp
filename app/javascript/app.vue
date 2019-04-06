<!--
<template>
	<div id="app">	

		{{ message }}
		<button v-on:click="change">change</button>

		{{ count }}

		<button v-on:click="increment">+1</button>
		<button v-on:click="decrement">-1</button>

		<button @click="getUsers()">プロフィール取得</button>
		<div v-for="user in users" :key="user.id">
		ID: {{ user.id }} 名前: {{ user.profile_name }} <br>
		</div>	
	</div>
</template>
->

<script>
/*
import { mapState } from 'vuex';

export default {
	created: function() {
		//this.getPosts(),
		this.getUsers()
	},
	methods:{
		//dispatchでactionsへ渡す
		increment () {
			this.$store.dispatch('increment')
		},
		decrement () {
			this.$store.dispatch('decrement')
		},
		getUsers() {
			this.$store.dispatch('getUsers');
		},

		//commonのmutationsに渡す
		change() {
			//mutasionsに渡す
			this.$store.commit('common/change');
		},
	},
	computed: {
		//gettersからstateを取得
		count () {
			return this.$store.getters.getCount
		},
		users () {
			return this.$store.getters.getUser
		},

		//commonのstate取得
		//複数コンポーネントでstateを使い回すのであればgettersで取得するべし
		...mapState({
			message: function (state) {
				return state.common.message;
			}
		})
	}
};
*/
</script>

<!--
<template>
	<div id="app">	
		<p>{{ fistName }}</p>		<p>{{ lastName }}</p>	
		<input type="text" v-model="newlastName" />
		<button @click="update">更新</button>
		<button @click="repeat">繰り返し</button>		<button @click="getUsers()">プロフィール取得</button>
		<div v-for="user in users" :key="user.id">
		ID: {{ user.id }} 名前: {{ user.profile_name }} <br>
		</div>	
	</div>
</template>



<script>
/*
//mapstateでstateを複数取得
import { mapState, mapActions , mapGetters } from 'vuex'
import * as types from './store/mutation-types';

export default {
  data: function () {
    return {
      newlastName: null,
    }
  },
  methods:{
	getUsers() {
      this.$store.dispatch('test/getUsers');
    },
    update() {
      //mutasionsに渡す
      this.$store.commit(test/types.UPDATE_MESSAGE , this.newlastName);
    },
    repeat() {
      //actions渡す
      this.$store.dispatch('test/repeat')
	}
  },
  computed: {
    //stateを取得
	firstName() { return this.$store.getters['test/firstName']},
	lastName() { return this.$store.getters['test/lastName']},
	...mapGetters({ 
		users: 'users',
	}),
	
	...mapState({
		users: 'users'
	})
	
  }
}
*/
</script>
