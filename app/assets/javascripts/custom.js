//=require jquery/jquery.min
$(document).ready(function() {
  $(".univ").click(function() {
    $("#to_univ").val(this.id);
  });
  
  $(".by_bus").click(function(e) {
    if($("#to_univ").val() == "도착지 선택"){
      e.preventDefault();
      alert("도착지를 입력하세요");
      $("#to_univ").focus();
      return;
    }
    if($("#from_univ").val() == "출발지 선택"){
      e.preventDefault();
      alert("출발지를 입력하세요");
      $("#from_univ").focus();
      return;
    }
    if($("#from_univ").val() == $("#to_univ").val()) {
      e.preventDefault();
      alert("출발지와 도착지를 다르게 입력하세요");
      $("#from_univ").focus();
      return;
    }
  });
});
