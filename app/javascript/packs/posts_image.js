import Vue from 'vue/dist/vue.esm.js'

let inputTemplate = {
    
    template: '<div v-on:click="add" class="view_box"><input v-on:click="add"multiple="multiple" class="file" type="file" name="post[post_image][]" id="post_post_image"></div>',
    data: function () {
        return {
          inputarea: '<div v-on:click="add" class="view_box"><input v-on:click="add"multiple="multiple" class="file" type="file" name="post[post_image][]" id="post_post_image"></div>',
        }
      },
    methods : {
        add : function(){
            var view_box = getElementByClassName('view_box')
            view_box.after(inputarea)
        }
    }
}


var app = new Vue({
    el : '#app',
    components: { 
        'posts-input-component': inputTemplate
    }
})