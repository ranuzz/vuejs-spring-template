<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <br />
    <h3>Create an Item</h3>
    <input type="text" v-model="itemvalue" />
    <button v-on:click="addCounter">Create Item</button>
    <br />
    <h3>Items</h3>
    <ul id="array-rendering">
      <li v-for="item in items" v-bind:key="item.id">
        {{ item.itemValue }}
      </li>
    </ul>
  </div>
</template>

<script>

import axios from 'axios';

export default {
  name: 'HelloWorld',
  props: {
    msg: String,
  },
  data() {
    return {
      itemvalue: "",
      items: []
    }
  },
  methods: {
    addCounter() {
      axios.post('/api/item/create/'+ this.itemvalue).then(response => this.items.push(response.data));
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
