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
//= require jquery
//= require activestorage
// require rails-ujs
// require turbolinks
// require infinite-scroll.pkgd.min
//= require popper
//= require bootstrap-sprockets
//= require_tree .


$(document).ready(function () {
	
	// 投稿いいね機能
	/*
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
	*/


	//inputにファイルがアップロードされたら 投稿複数画像アップロード
	$(document).on("change", ".my-post-file-label", function(){
		//input.fileのプロパティ情報を取得
		var fileprop = $(this).children('.file').prop('files')[0],
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
		var img = '<div class="img_view"><img alt="" class="img" width="100"><p><a href="#" class="img_del"><i class="fas fa-times-circle"></i>削除する</a></p></div>';
		
		//.view_boxにimgタグを挿入
		view_box.append(img);

		filereader.onload = function() {
			//imgのsrcプロパティにファイル情報を返す
			view_box.find('img').attr('src', filereader.result);
			img_del(view_box);
		}
		//fileオブジェクトの読み込み
		filereader.readAsDataURL(fileprop);

		//inputボタン削除
		$(this).css("display" , "none");
		//class付与
		$(this).parent(".view_box").removeClass("view_box_input");
		$(this).parent(".view_box").addClass("view-img-count");

		//.view_boxの数を返す
		var backLength = postViewLength();
		console.log(backLength);
		//.view_boxの画像が4以上だったら
		if(backLength < 5){
			//次の画像のinputボタンを作成
			addInput(view_box);
		}

	});

	//画像を選択したらinputボタンをまた表示
	var count = 1;
	function addInput(target){
		//コメント投稿画像の場合
		$has = $(this).hasClass(".commnet_file");
		if($has = true){

		//投稿画像の場合
		var file_input = '<div class="view_box view_box_input"><label for="file_upload'+count+'" class="my-post-file-label"><i class="fas fa-images"></i> 画像<input multiple="multiple" accept="image/*" id="file_upload'+count+'" class="file my-post-file-input" type="file" name="post[post_image][]"></label></div>';

		}else{
			
		//コメント投稿画像の場合
		var file_input = '<div class="view_box view_box_input"><label for="file_upload'+count+'" class="my-post-file-label"><i class="fas fa-images"></i> 画像<input multiple="multiple" id="file_upload'+count+'" class="file my-post-file-input" type="file" name="post[post_image][]"></label></div>';

		}
		target.after(file_input);

		count = count + 1;

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
			//.view_boxを削除
			parentBox.remove();

			//.view_boxの数を返す
			var backLength = postViewLength();
			console.log(backLength);
			//.view_boxの画像が4以上だったら
			if(backLength == 4){
				//プレビュー表示する箱のセレクタ
				view_box = $("#post-img-view-area .view_box:last");
				//次の画像のinputボタンを作成
				addInput(view_box);
			}

			} , 0);            
		}
		return false;
		});
	}

	//選択した画像の数を返すメソッド
	function postViewLength (){
		var vlength = $("#post-img-view-area .view-img-count").length;
		return vlength;
	}
	


	//inputにファイルがアップロードされたら 投稿複数画像アップロード
	/*
	$(document).on("change", ".file", function(){
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
		
		//コメント投稿画像の場合
		$has = $(this).hasClass(".commnet_file");
		if($has = true){
		//コメント投稿画像の場合
		var file_input = '<div class="view_box"><input multiple="multiple" class="comment_file file" type="file" name="post_comment[comment_image][]" id="post_comment_comment_image"></div>';
		}else{
		//投稿画像の場合
		var file_input = '<div class="view_box"><input multiple="multiple" class="file" type="file" name="post[post_image][]" id="post_post_image"></div>';
		}
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
	*/


	// 投稿フォーム文字に応じて可変 ================================== 
	$("#ta").height(30);//init
	$("#ta").css("lineHeight","20px");//init

	$("#ta").on("input",function(evt){
		if(evt.target.scrollHeight > evt.target.offsetHeight){   
			$(evt.target).height(evt.target.scrollHeight);
		}else{          
			var lineHeight = Number($(evt.target).css("lineHeight").split("px")[0]);
			while (true){
				$(evt.target).height($(evt.target).height() - lineHeight); 
				if(evt.target.scrollHeight > evt.target.offsetHeight){
					$(evt.target).height(evt.target.scrollHeight);
					break;
				}
			}
		}
	});

	

	//httpで始まるテキストを自動でリンク化Code ================================== 
	$(".post-block-text").each(function(){
		$(this).html( $(this).html().replace(/((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g, '<a href="$1">$1</a> ') );
	});


	




}); //end $(document).ready(function)





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







