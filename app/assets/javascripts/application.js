// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery


$(document).ready(function () {

  // 投稿いいね機能
  $(document).on('click','.like_btn',function(){    
    
    var $likeBtn = $(this);
    var $postId = $likeBtn.attr("post_id");
    var $like = $(this).find('i');
    var $btnClass = $like.attr("class");

    var url = $btnClass == 'far fa-heart unlike' ? '/create' : '/destroy';

    $.ajax({
      url: 'post_likes/'+ $postId + url,
      type:'GET',

    }).done(function(data){
      if($like.hasClass('unlike')){
        //likeクラスを付与
        $like.removeClass('far fa-heart unlike').addClass('fas fa-heart like');
        //いいね数を増やす
        var likeCountNum = parseInt($likeBtn.next(".like_count_num").text());
        likeCountNum = likeCountNum + 1;
        $likeBtn.next(".like_count_num").html(likeCountNum);
      }else{
        $like.removeClass('fas fa-heart like').addClass('far fa-heart unlike');
        //いいね数を減らす
        var likeCountNum = parseInt($likeBtn.next(".like_count_num").text());
        likeCountNum = likeCountNum - 1;
        $likeBtn.next(".like_count_num").html(likeCountNum);
      }
    });
  });




  //inputにファイルがアップロードされたら 投稿複数画像アップロード
  $(document).on("change", ".file", function(){
  
    //関数化したい ====================================================

    //input.fileのプロパティ情報を取得
    var fileprop = $(this).prop('files')[0],
      //親のimgを取得
      find_img = $(this).parent().find('img'),
      //Blob や File オブジェクトが保有するバッファの中身に、読み取りアクセス
      filereader = new FileReader(),
      //プレビュー表示する箱のセレクタ
      view_box = $(this).parent('.view_box');
    
    //img要素があったら　このif分なくても動く？？
    if(find_img.length){
      //imgの次の要素は全部削除
      find_img.nextAll().remove();
      find_img.remove();
    }

    //imgタグ
    var img = '<div class="img_view"><img alt="" class="img" width="100"><p><a href="#" class="img_del">画像を削除する</a></p></div>';
    
    //.view_boxにimgタグを挿入
    view_box.append(img);

    
    filereader.onload = function() {
      //imgのsrcプロパティにファイル情報を返す
      view_box.find('img').attr('src', filereader.result);
      img_del(view_box);
    }
    //fileオブジェクトの読み込み
    filereader.readAsDataURL(fileprop);

    //次の画像のinputボタンを作成
    addInput(view_box);

    //inputボタン削除
    $(this).css("display" , "none");

  });
   

  //画像を選択したらinputボタンをまた表示
  function addInput(target){
    var file_input = '<div class="view_box"><input multiple="multiple" class="file" type="file" name="post[post_image][]" id="post_post_image"></div>';
    target.after(file_input);
    
  }
  
  

  //画像を削除するメソッド
  function img_del(target){
    //画像を削除するボタンをクリックしたら
    target.find("a.img_del").on('click',function(){
      var self = $(this),
          //親要素であるimgを取得
          parentBox = self.parent().parent().parent();
      //確認用メッセージを表示
      if(window.confirm('画像を削除します。\nよろしいですか？')){
        setTimeout(function(){
          //確認メッセージでYESなら
          //inputのファイル情報を削除
          parentBox.find('input[type=file]').val('');
          //プレビュー表示してたimgを削除
          parentBox.find('.img_view').remove();
        } , 0);            
      }
      return false;
    });
  }

     
});

//画像アップロードで即時プレビュー
/*
$( document ).on('turbolinks:load', function() {
  function readURL(input) {
    if (input.files && input.files[0]) {

      console.log(input.files[0]);

      var reader = new FileReader();
 
      reader.onload = function (e) {
        $('#avatar_img_prev').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
 
  $("#post_img").change(function(){
    $('#avatar_img_prev').removeClass('hidden');
    $('.avatar_present_img').remove();
    readURL(this);
  });
});
*/






