<%@page import="test.free.dao.FreeDao"%>
<%@page import="java.util.List"%>
<%@page import="test.free.dto.FreeDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   //로그인 된 아이디 읽어오기 
   String id=(String)session.getAttribute("id");

	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=5;
	//하단 페이지를 몇개씩 표시할 것인지
	final int PAGE_DISPLAY_COUNT=5;
	
	//보여줄 페이지의 번호를 일단 1이라고 초기값 지정
	int pageNum=1;
	//페이지 번호가 파라미터로 전달되는지 읽어와 본다.
	String strPageNum=request.getParameter("pageNum");
	//만일 페이지 번호가 파라미터로 넘어 온다면
	if(strPageNum != null){
		//숫자로 바꿔서 보여줄 페이지 번호로 지정한다.
		pageNum=Integer.parseInt(strPageNum);
	}
	
	//보여줄 페이지의 시작 ROWNUM
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
	//보여줄 페이지의 끝 ROWNUM
	int endRowNum=pageNum*PAGE_ROW_COUNT;
	
	//FreeDto 객체에 startRowNum 과 endRowNum 을 담는다.
	FreeDto dto=new FreeDto();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
	
	//ArrayList 객체의 참조값을 담을 지역변수를 미리 만든다.
	List<FreeDto> list=null;
	//전체 row 의 갯수를 담을 지역변수를 미리 만든다.
	int totalRow=0;

	//키워드가 없을때 호출하는 메소드를 이용해서 파일 목록을 얻어온다. 
	list=FreeDao.getInstance().getList(dto);
	//키워드가 없을때 호출하는 메소드를 이용해서 전제 row 의 갯수를 얻어온다.
	totalRow=FreeDao.getInstance().getCount();
	
	
	//하단 시작 페이지 번호 
	int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
	//하단 끝 페이지 번호
	int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
	
	
	//전체 페이지의 갯수
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	//끝 페이지 번호가 전체 페이지 갯수보다 크다면 잘못된 값이다.
	if(endPageNum > totalPageCount){
		endPageNum=totalPageCount; //보정해 준다.
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index.jsp</title>
<jsp:include page="include/resource.jsp"></jsp:include>
<style>
   .inner{
      max-width:1100px!important;
      margin:0 auto!important;
      box-sizing:border-box!important;
      position:relative!important;
   }
   .main_banner{
   	  position:relative;
   }
   #main_img{
      position:absolute;
      width:1100px;
      height:450px;
   }
   .main_list{
   	  width:1100px;
   	  display:flex;
   	  position:absolute;
   	  margin-top:450px;
   	  justify-content:space-between;
   }
   .main_list>div{
   	  width:350px;
   	  height:400px;
   	  background-color:gray;
   }

   
</style>
</head>
<body>
<jsp:include page="include/navbar.jsp"></jsp:include>
   <div class="inner">
      <div class="main_banner">
         <img id="main_img" src="images/main_img.jpg" alt="메인이미지" />
      </div>
      <!-- main_banner 끝 -->
      
      <div class="main_list">
      	<div class="share_table">
      			<table>
					<thead>
						<tr>
							<th>글번호</th>
							<th>작성자</th>
							<th>제목</th>
							<th>조회수</th>
							<th>등록일</th>
						</tr>
					</thead>
					<tbody>
					<%for(FreeDto tmp:list){%>
						<tr>
							<td><%=tmp.getNum() %></td>
							<td><%=tmp.getWriter() %></td>
							<td>
								<a href="detail.jsp?num=<%=tmp.getNum()%>"><%=tmp.getTitle() %></a>
							</td>
							<td><%=tmp.getViewCount() %></td>
							<td><%=tmp.getRegdate() %></td>
						</tr>
					<%} %>
					</tbody>
				</table>
				<div class="page-ui clearfix">
					<ul>
						<%if(startPageNum != 1){ %>
							<li>
								<a href="list.jsp?pageNum=<%=startPageNum-1 %>">Prev</a>
							</li>	
						<%} %>
						
						<%for(int i=startPageNum; i<=endPageNum ; i++){ %>
							<li>
								<%if(pageNum == i){ %>
									<a class="active" href="list.jsp?pageNum=<%=i %> %>"><%=i %></a>
								<%}else{ %>
									<a href="list.jsp?pageNum=<%=i %>"><%=i %></a>
								<%} %>
							</li>	
						<%} %>
						<%if(endPageNum < totalPageCount){ %>
							<li>
								<a href="list.jsp?pageNum=<%=endPageNum+1 %>">Next</a>
							</li>
						<%} %>
					</ul>
				</div>
				
				
      	</div>
      	<div class="free_table">
      	
      	</div>
      	<div class="resell_table">
      	
      	</div>
      </div>
      <!--main_list 끝 -->
   </div>
</body>
</html>