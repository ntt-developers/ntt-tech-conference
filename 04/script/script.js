// Smooth Scroll
$('a[href^="#"]').click(function() {
	var speed = 400;
	var href= $(this).attr("href");
	var target = $(href == "#" || href == "" ? 'html' : href);
	var position = target.offset().top - 64;
	$('body,html').animate({scrollTop:position}, speed, 'swing');
	return false;
});

// Time Tableの空欄箇所には自動でhiddenを付与
$('.timeTable__item:empty').addClass("hidden");
$('.timeTable__link:empty, .timeTable__txt:empty').parent().addClass("hidden");

// handsonのClassが入っているところには自動で「Hands on」と入るようにしている
$(".handson").prepend("<span>[Hands on]</span>")

// ModalのClick Functionのためのdata-targetのセット
$(".timeTable__link").each(function(i){
	i = i+1;
	$(this).attr("data-target", "modal_"+i);
})

// data-targetに紐づいてModalが立ち上がるように、同じ形式でidセット
$(".modal").each(function(i){
	i = i+1;
	$(this).attr("id", "modal_"+i);
})

// Modalの立ち上げ部分
$(".timeTable__link").each(function(){
	$(this).on("click", function(){
		var target = $(this).data("target");
	var modal = document.getElementById(target);
	$("body").addClass("modal__open");
  $(modal).fadeIn();
  return false;
	})
});

// Modalの×ボタンでのClose
$(".modal__close").on("click", function(){
	$("body").removeClass("modal__open");
	$(".modal").fadeOut();
	return false;
});

// Modalの外側でもClose
$('.modal').on("click", function(){
	$("body").removeClass("modal__open");
	$(this).fadeOut();
	// return false;
});
// Modalのコンテンツ部分ではCloseしないようにする
$(".modal__dialog").on("click", function(e){
	e.stopPropagation();
});

// Smartphone UI用 Tab切り替え
$(".timeTable__tabItem").on("click", function(){
	var ID = $(this).attr("id");
	if(ID == "tab1"){
		if(!$("#tab1").hasClass("selected")){
			$(".timeTable__tabItem").removeClass("selected");
			$("#tab1").addClass("selected");
			$(".venue1, .venue2, .venue3").fadeOut();
			$(".venue1").fadeIn()
		}
		
	} else if(ID == "tab2"){
		if(!$("#tab2").hasClass("selected")){
			$(".timeTable__tabItem").removeClass("selected");
			$("#tab2").addClass("selected");
			$(".venue1, .venue2, .venue3").fadeOut();
			$(".venue2").fadeIn()
		}
	} else {
		if(!$("#tab3").hasClass("selected")){
			$(".timeTable__tabItem").removeClass("selected");
			$("#tab3").addClass("selected");
			$(".venue1, .venue2, .venue3").fadeOut();
			$(".venue3").fadeIn()
		}
	}
});

// Tabの切り替えを行った後に、ブラウザ幅を広げるとStyle display noneが邪魔をするため、ブラウザ幅が広がった時にStyleをRemoveする
var mediaQuery = matchMedia('(min-width: 768px)');

// ページが読み込まれた時に実行
handle(mediaQuery);

// ウィンドウサイズが変更されても実行されるように
mediaQuery.addListener(handle);

function handle(mq) {
  if (mq.matches) {
		$(".venue1, .venue2, .venue3").removeAttr("style")
	};
};