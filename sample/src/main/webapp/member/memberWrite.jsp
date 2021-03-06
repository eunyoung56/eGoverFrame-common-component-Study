<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 화면</title>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script>
  $( function() {
    $( "#birth" ).datepicker({
      changeMonth: true,
      changeYear: true
    });
    
    $("#btn_zipcode").click(function(){
    	var w = 500;
    	var h = 100;
    	var url = "post1.do";
    	//팝업창
    	window.open(url,'zipcode','width='+w+ ",height="+h); //넓이나 높이는 임의로 조절할 것
    });
    
    $("#btn_idcheck").click(function(){ 
    	
    	var userid = $.trim($("#userid").val()); //데이터 유효값
    	if(userid == ""){
    		alert("아이디를 입력해주세요");
    		$("#userid").focus();
    		return false;
    	}
    	//idcheck.do로 데이터 전송 - 비동기 전송 방식
    	$.ajax({
    		/* 전송 전 세팅 */
			type:"POST",
			data:"userid="+userid, //json타입으로 데이더 전송
			url:"idcheck.do",
			dataType:"text", //성공 여부에 대해서 data를 text형태로 리턴
			/* 전송 후 세팅 */
			success:function(data){ //controller에서 매개변수로 값이 넘어옴
				if(data == "ok"){
					alert("사용 가능한 아이디 입니다.");
				}else{
					alert("이미 사용 중인 아이디 입니다.")
				}
			},
			error: function(){ // 장애발생(시스템 에러=서버에러)
				alert("오류발생");
			}
    	});
    });
    
    $("#btn_submit").click(function(){//click, val은 jquery 함수이다.
    	var userid = $("#userid").val();
    	var pass = $("#pass").val();
    	var name = $("#name").val();
    	userid = $.trim(userid); //앞,뒤만 공백제거 (일단 중간은 안됨ㅠ)
    	pass = $.trim(pass);
    	name = $.trim(name);
    	if(userid == ""){
    		alert("아이디를 입력해주세요");
    		$("#userid").focus();
    		return false;
    	}
    	if(pass == ""){
    		alert("암호를 입력해주세요");
    		$("#pass").focus();
    		return false;
    	}
    	if(name == ""){
    		alert("이름를 입력해주세요");
    		$("#name").focus();
    		return false;
    	}//↓↓↓ㅁ실제 화면에 대한 데이터의 공백 제거를 해주기(진짜 입력상자의 공백)
		$("#userid").val(userid);
    	$("#pass").val(pass);
    	$("#name").val(name);
    	
    	var formData = $("#frm").serialize();
    	
    	//ajax : 비동기 전송방식의 기능을 가지고 있는 jquery의 함수
		$.ajax({  
			/* 전송 전 세팅 */
			type:"POST",
			data:formData,
			url:"memberWriteSave.do",
			dataType:"text", //성공 여부에 대해서 data를 text형태로 리턴
			/* 전송 후 세팅 */
			success:function(data){ //Controller에서 매개변수로 값이 넘어옴
				if(data == "ok"){
					alert("저장 완료");
					location = "loginWrite.do";
				}else{
					alert("저장 실패")
				}
			},
			error: function(){ // 장애발생(시스템 에러=서버에러)
				alert("오류발생");
			}
		});
    });
  });
  </script>
</head>
<style>
body{
	font-size:9pt;
	font-color:#333333;
	font-font:맑은 고딕;
}
a{
	text-decoration:none;
}
table{
	width:600px;
	border-collapse:collapse;
}
th,td{
	border:1px solid #cccccc;
	padding:3px;
	margin-top:5px;
}
caption{
	font-size:15pt;
	font-weight:bold;
	margin-top:10px;
	padding-bottom:15px;
}
.div_button{
	width:600px;
	text-align:center;
	margin-top:5px;
	/* 줄 사이 간격을 띄는 방법 */
	line-height:2.0;
}
</style>
<body>
<%@include file="../include/topmenu.jsp" %>
<form name = "frm" id = "frm">
<table>
	<caption>회원가입 폼</caption>
	<tr>
		<th><label for = "userid">아이디</label></th>
		<td>	<!-- 초기 출력 시에 입력상자에 표현이 될 수 있도록  placeholder 속성 작성-->
		<input type = "text" name ="userid" id = "userid" placeholder = "아이디입력">
		<button type = "button" id="btn_idcheck">중복체크</button>
		</td>
	</tr>
	<tr>
		<th><label for = "pass">암호</label></th>
		<td>
		<input type = "password" name ="pass" id = "pass">
		</td>
	</tr>
	<tr>
		<th><label for = "name">이름</label></th>
		<td>
		<input type = "text" name ="name" id = "name">
		</td>
	</tr>
	<tr>
		<th><label for = "gender">성별</label></th>
		<td>
		<input type = "radio" name ="gender" id = "gender" value = "M">남
		<input type = "radio" name ="gender" id = "gender" value = "F">여
		</td>
	</tr>
	<tr>
		<th><label for = "birth">생년월일</label></th>
		<td>
		<input type = "text" name ="birth" id = "birth">
		</td>
	</tr>
	<tr>
		<th><label for = "phone">연락처</label></th>
		<td>
		<input type = "text" name ="phone" id = "phone"> (예: 010-1234-1234)
		</td>
	</tr>
	<tr>
		<th><label for = "address">주소</label></th>
		<td>
			<input type = "text" name ="zipcode" id = "zipcode">
			<button type ="button" id = "btn_zipcode">우편번호 찾기</button>
			<br>
			<input type = "text" name= "address" id = "address">
		</td>
	</tr>
</table>
<div class = "div_button">
	<button type = "button" id ="btn_submit">저장</button>
	<button type = "reset">취소</button>
</div>
</form>

</body>
</html>