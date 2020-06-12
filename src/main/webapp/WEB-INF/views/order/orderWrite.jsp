 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="/stu/css/bootstrap.min.css">

<!-- 부가적인 테마 -->
<link rel="stylesheet" href="/stu/css/bootstrap-theme.min.css">



<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script src="/stu/js/bootstrap.min.js"></script>
<script src="/stu/js/jquery-3.0.0.min.js"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="/stu/js/common.js" charset="utf-8"></script>

<script type="text/javascript">

//기본 주문금액 계산
function fn_allPrice(){
	
	var array1 = document.getElementsByName("goods_sell_price");
	var array2 = document.getElementsByName("basket_goods_amount");
	var array3 = document.getElementsByName("ORDER_DETAIL_PRICE");
	
	var len = array2.length;
	var hap = 0;
	for (var i=0; i<len; i++){
		var sell = array1[i].value;
		var amt = array2[i].value;
		var pri = Number(sell)*Number(amt); //각 상품별 주문금액
		hap = Number(hap)+Number(pri); //주문금액 총합 구하기
		array3[i].value = pri;	
	}
	var fee = document.getElementById("ORDER_FEE").value;
	pay = Number(hap)+Number(fee);
	
	document.getElementById("ORDER_TOTAL_ORDER_PRICE").value = hap; //총주문금액
	document.getElementById("ORDER_TOTAL_PAY_PRICE").value = pay; //(최초,할인들어가기전)최종결제금액
	document.getElementById("pay_price1").value = pay; //결제예정금액(바꿔야됨)
	
	var array7 = document.getElementsByName("member_grade");
	var grade = array7[0].value;
	var val = 0;
	if("nomal" == grade){
		val=0.03;
	}else if("gold" == grade){
		val=0.05;
	}else{
		val=0.1;
	}
	var point = Number(hap)*Number(val); //등급별 적립율
	document.getElementById("ORDER_SAVE_POINT").value = point; //할인과 상관없이 주문금액별 적립
}

//주문자정보와 동일
function fn_chkinfo(){
	var chk = document.getElementById("chkinfo").checked;
	if(chk==true){
		document.getElementById("ORDER_NAME").value = "${map.MEMBER_NAME}";
		document.getElementById("ORDER_PHONE").value = "${map.MEMBER_PHONE}";
		document.getElementById("ORDER_ZIPCODE").value = "${map.MEMBER_ZIPCODE}";
		document.getElementById("ORDER_ADDR1").value = "${map.MEMBER_ADDR1}";
		document.getElementById("ORDER_ADDR2").value = "${map.MEMBER_ADDR2}";
	}else if(chk==false){
		document.getElementById("ORDER_NAME").value = "";
		document.getElementById("ORDER_PHONE").value = "";
		document.getElementById("ORDER_ZIPCODE").value = "";
		document.getElementById("ORDER_ADDR1").value = "";
		document.getElementById("ORDER_ADDR2").value = "";
	}
}

//쿠폰, 포인트 사용
function fn_price(){

	var f = document.orderWrite;
	var hap_buy = Number(f.ORDER_TOTAL_ORDER_PRICE.value);  //총 주문금액
	var u_p = ${map.POINT_TOTAL}; //보유포인트
	var o_point = Number(f.ORDER_USE_POINT.value); //사용할포인트
	var a = f.COUPON_VALUE.value; // 할인쿠폰 값

	var sum_point = u_p - o_point;  // 남은 포인트(보유포인트-사용할포인트)
	var hap_discount= hap_buy*(a/100); // 쿠폰할인값
	var cp_buy = (hap_buy-hap_discount); // 쿠폰할인만 한 가격
	var sum_buy = (hap_buy-hap_discount)-o_point; // 주문금액-쿠폰할인-포인트사용(최종결제금액)

	var array = document.getElementsByName("ORDER_DETAIL_PRICE");
	var array2 = document.getElementsByName("COUPON_DISCOUNT");
	var array3 = document.getElementsByName("ORDER_DISCOUNT_APPLY");
	var len = array.length;
	for (var i=0; i<len; i++){
		var COUPON_DISCOUNT = array[i].value*(a/100);
		array2[i].value = COUPON_DISCOUNT;
		array3[i].value = Number(array[i].value)-Number(array2[i].value);
	}
	
	if(u_p < o_point ){
			alert("사용가능 마일리지를 확인해주세요!");
			return false;
	}
	if(o_point > cp_buy){
			alert("결제금액 보다 큽니다!");
			location.reload(true);
			return false;
	}
	f.discount.value = hap_discount+o_point;
	f.pay_price1.value = sum_buy+3000;
	f.ORDER_TOTAL_PAY_PRICE.value = sum_buy+3000;
	f.POINT_TOTAL.value = sum_point;

	var index = ($("#COUPON_VALUE option").index("#COUPON_VALUE option:selected"))*(-1)-1;
	var array9 = document.getElementsByName("COUPON_STATUS_NO");
	var array11 = document.getElementsByName("COUPON_NO");
	f.COUPON_STATUS_NO_1.value = array9[index].value;
	f.COUPON_NO_1.value = array11[index].value;
}

//주문완료
function fn_order_pay(){
	
		var f = document.orderWrite;
		
 		if( f.ORDER_NAME.value=="" ){
 			alert("주문자 이름을 입력해주세요.");
 			f.ORDER_NAME.focus();
 			return false;
 		}
 		if( f.ORDER_PHONE.value==""){
 			alert("전화번호를 입력해주세요.");
 			f.ORDER_PHONE.focus(); //커서자동클릭
 			return false;
 		}
 		if( f.ORDER_ZIPCODE.value=="" || f.ORDER_ADDR1.value=="" || f.ORDER_ADDR2.value==""){
 			alert("주소를 입력해주세요.");
 			return false;
 		}
 		if( document.getElementById("OPTION1").checked==false && document.getElementById("OPTION2").checked==false){
 			alert("결제방법을 선택해주세요.");
 			return false;
 		}
 		if( f.ORDER_PAY_BANK.value=="" ){
 			alert("결제은행을 입력해주세요.");
 			f.ORDER_PAY_BANK.focus();
 			return false;
 		}
 		if( f.ORDER_PAY_NAME.value==""){
 			alert("결제자명을 입력해주세요.");
 			f.ORDER_PAY_NAME.focus(); //커서자동클릭
 			return false;
 		}
 		if( document.getElementById("orderChk").checked==false){
 			alert("서비스 약관에 동의해주세요.");
 			return false;
 		}
		
		f.submit();
}
</script>


</head>

<body onload="fn_allPrice()">
    <div class="container">

      <div style="width:1140px; height:50px; margin:10px; padding:12px; border:1px solid #dcdcdc">
      	<table>
      		<tr>
      			<td style="text-align:left; font-size:17px; font-weight:bold;">주문작성/결제</td>
      		</tr>
      	</table>
      </div>

      <!-- tables -->
      <form id="commonForm" name="commonForm"></form>
      <form name="orderWrite" id="orderWrite" method="post" action="/stu/order/orderPay.do">
      	<%-- <!-- goods정보 -->
      	<input type="hidden" name="list" value="${list }">
      	<!-- coupon정보 -->
      	<input type="hidden" name="list2" value="${list2 }">
      	<!-- member정보 -->
      	<input type="hidden" name="map" value="${map }"> --%>
          <div class="table-responsive">
          	<p><b>주문작성/결제</b></p>
            <table class="table table-striped">
            <colgroup>
				<col width="20" />
				<col width="*" />
				<col width="10%" />
				<col width="13%" />
				<col width="13%" />
			</colgroup>
              <thead>
                <tr>
                  <th colspan="2" style="text-align:center">상품명/옵션</th>
                  <th style="text-align:center">수량</th>
                  <th style="text-align:center">상품가</th>
                  <th style="text-align:center">주문금액</th>
                </tr>
              </thead>
              <tbody>
              
					<c:forEach items="${list }" var="row" varStatus="status">
						<input type="hidden" name="member_grade" value="${row.MEMBER_GRADE }">
						<input type="hidden" name="goods_no" value="${row.GOODS_NO }">
						<input type="hidden" name="goods_att_no" value="${row.GOODS_ATT_NO }">
						<input type="hidden" name="goods_att_color" value="${row.GOODS_ATT_COLOR }">
						<input type="hidden" name="goods_att_size" value="${row.GOODS_ATT_SIZE }">
						<input type="hidden" name="basket_no" value="${row.BASKET_NO }">
						<tr>
                  			<td>
                  				<img src="${row.UPLOAD_SAVE_NAME }" width="50" height="50">
                  			</td>
							<td>
				  				<a href="#">${row.GOODS_NAME }</a> <br>
				  				색상: ${row.GOODS_ATT_COLOR } <br> 
				  				사이즈:${row.GOODS_ATT_SIZE } <br>
				  			</td>
				  			<td style="text-align:center">
                  				<input type="number" name="basket_goods_amount" value="${row.BASKET_GOODS_AMOUNT }" style="width:50px; text-align:right" readonly>
                  			</td>
							<td style="text-align:center">
								<c:set var="price" value="${row.GOODS_SALE_PRICE }" />
								<c:choose>
    								<c:when test="${price eq null}">
        								<input type="text" name="goods_sell_price" value="${row.GOODS_SELL_PRICE }"style="width:60px; text-align:right; border:none;" readonly>원
   					 				</c:when>
   					 				<c:when test="${price ne null}">
        								<input type="text" name="goods_sell_price" value="${row.GOODS_SALE_PRICE }"style="width:60px; text-align:right; border:none;" readonly>원
   					 				</c:when>
								</c:choose>
							</td>
							<td style="text-align:center">
								<input type="text" name="ORDER_DETAIL_PRICE" value="" style="width:60px; text-align:right; border:none;" readonly>원
								<input type="hidden" name="COUPON_DISCOUNT" value="" >
								<input type="hidden" name="ORDER_DISCOUNT_APPLY" value="" >
							</td>
						</tr>
					</c:forEach>
              </tbody>
            </table>
          </div>
          <br><br>
          
          <div class="table-responsive">
          	<table class="table table-striped" style="width:1140px" >
          	<colgroup>
				<col width="11%" />
				<col width="22%" />
				<col width="11%" />
				<col width="22%" />
				<col width="12%" />
				<col width="22%" />
			</colgroup>
          		<tr>
          			<td>주문금액</td>
          			<td style="text-align:right">
          				<input type="text" name="ORDER_TOTAL_ORDER_PRICE" id="ORDER_TOTAL_ORDER_PRICE" style="width:100px; text-align:right; border:none;" readonly>원
          			</td>
          			<td>- 할인금액</td>
          			<td style="text-align:right">
          				<input type="text" name="discount" id="discount" style="width:100px; text-align:right; border:none;" readonly>원
          			</td>
          			<td> = 결제예정금액</td>
          			<td style="text-align:right">
          				<input type="text" name="pay_price1" id="pay_price1" value="" style="width:100px; text-align:right; border:none;" readonly>원
          			</td>
          		</tr>
          		<tr rowspan="3">
          			<td >
          				쿠폰할인
          			</td>
          			<td colspan="3" >
          				<select name="COUPON_VALUE" id="COUPON_VALUE" onchange="fn_price()">
						<option value="0">-------- 사용안함 -------</option>
							<c:forEach items="${list2 }" var="row2" varStatus="status2">
								<option value="${row2.COUPON_VALUE }">${row2.COUPON_ID } 할인</option>
								<input type="hidden" name="COUPON_NO" value="${row2.COUPON_NO }">
								<input type="hidden" name="COUPON_STATUS_NO" value="${row2.COUPON_STATUS_NO }">
							</c:forEach>
						</select>
						<input type="hidden" name="COUPON_STATUS_NO_1" value="">
						<input type="hidden" name="COUPON_NO_1" value="">
          			</td>
          			<td>
          				적립혜택
          			</td>
          			<td>
          			</td>
          		</tr>
          		<tr rowspan="3">
          			<td>
          				포인트
          			</td>
          			<td colspan="3" >
          				<input type="text" name="ORDER_USE_POINT" id="ORDER_USE_POINT" value="0" style="width:100px; text-align:right"> P &nbsp;&nbsp;&nbsp;&nbsp;
          				<input type="button" value="사용" onclick="fn_price()">
          				(포인트 <input type="text" name="POINT_TOTAL" id="POINT_TOTAL" value="${map.POINT_TOTAL }" style="width:50px; text-align:right; border:none;" readonly> P)
          			</td>
          			<td>
          				포인트적립
          			</td>
          			<td>
          				<input type="text" name="ORDER_SAVE_POINT" id="ORDER_SAVE_POINT" style="width:100px; text-align:right" readonly> P
          			</td>
          		</tr>
          		<tr rowspan="3">
          			<td>
          				선결제배송비
          			</td>
          			<td colspan="3" >
          				<input type="text" id="ORDER_FEE" name="ORDER_FEE" value="3000" style="width:100px; text-align:right; border:none;" readonly>원
          			</td>
          			<td>
          			</td>
          			<td>
          			</td>
          		</tr>
          	</table>
          </div>
         
            <br><br>
            <div class="table-responsive">
          	<p>
          		<b>받으시는분(상품받으실분)</b> &nbsp;
          		<input type="checkbox" name="chkinfo" id="chkinfo" onclick="fn_chkinfo()">
          		주문자 정보와 동일
          	</p>
            <table class="table table-striped">
            <colgroup>
				<col width="15%" />
				<col width="*" />
			</colgroup>
              <tbody>
              	<tr>
              		<td>이름</td>
              		<td style="text-align:left">
                  		<input type="text" name="ORDER_NAME" id="ORDER_NAME" value="" style="width:100px;" >
                  	</td>
				</tr>
				<tr>
              		<td>휴대폰번호</td>
              		<td style="text-align:left">
                  		<input type="text" name="ORDER_PHONE" id="ORDER_PHONE" value="" style="width:120px;" >
                  	</td>
				</tr>
				<tr>
              		<td rowspan="3">주소</td>
              		<td style="text-align:left">
                  		<input type="text" name="ORDER_ZIPCODE" id="ORDER_ZIPCODE" value="" style="width:80px;" >
                  	</td>
				</tr>
				<tr>
              		<td style="text-align:left">
                  		<input type="text" name="ORDER_ADDR1" id="ORDER_ADDR1"value="" style="width:250px;" >
                  	</td>
				</tr>
				<tr>
              		<td style="text-align:left">
                  		<input type="text" name="ORDER_ADDR2" id="ORDER_ADDR2"value="" style="width:250px;" >
                  	</td>
				</tr>
              </tbody>
            </table>
          </div>
          <br><br>
          
          <div class="table-responsive">
          	<p><b>결제선택</b></p>
            <table class="table table-striped">
            <colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>
              <tbody>
              	<tr>
              		<td>총 결제금액</td>
              		<td style="text-align:left">
                  		<input type="text" name="ORDER_TOTAL_PAY_PRICE" id="ORDER_TOTAL_PAY_PRICE" value="" style="width:100px;" readonly>원
                  	</td>
				</tr>
				<tr>
              		<td>결제방법</td>
              		<td style="text-align:left">
                  		<input type="radio" name="ORDER_PAY_OPTION" id="OPTION1" value="1" style="width:30px;">신용카드
                  		&nbsp;&nbsp;
                  		<input type="radio" name="ORDER_PAY_OPTION" id="OPTION2" value="2" style="width:30px;">계좌이체
                  	</td>
				</tr>
				<tr>
              		<td>결제은행</td>
              		<td style="text-align:left">
                  		<input type="text" name="ORDER_PAY_BANK" style="width:150px;">
                  	</td>
				</tr>
				<tr>
              		<td>결제자명</td>
              		<td style="text-align:left">
                  		<input type="text" name="ORDER_PAY_NAME" style="width:100px;">
                  	</td>
				</tr>
              </tbody>
            </table>
            </div>
            <br>
            <div style="text-align:center">
            	<input type="checkbox" name="orderChk" id="orderChk">
          		(필수)결제서비스 약관에 동의하며, 원활한 배송을 위한 개인정보 제공에 동의합니다.
          		<br><br>
          		<input type="button" name="all_order" value="장바구니" onClick="location.href='/stu/basket/basketList.do'">
            	<input type="submit" name="order_pay" value="결제진행" onclick="fn_order_pay(); return false;">
            </div>
      
     </form>

     
  </body>
</html>