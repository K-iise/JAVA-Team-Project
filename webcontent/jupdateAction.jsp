<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="jbbs.jBbsDAO"%>
<%@ page import="jbbs.jBbs"%>
<%
request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset-UTF-8"> 
<link rel="stylesheet" href="css/bootstrap.css">
<title>E-러닝 게시판 웹 사이트</title>
</head>
<body>
	<%
	//현재 세션 상태를 체크한다
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	}
	
	//로그인을 한 사람만 글을 쓸 수 있도록 한다
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요')");
		script.println("location.href='Newlogin.jsp'");
		script.println("</script>");	
	}
	
	int jbbsID = 0;
	if(request.getParameter("jbbsID") != null){
		jbbsID = Integer.parseInt(request.getParameter("jbbsID"));	
	}
	if(jbbsID == 0){
		PrintWriter script = response.getWriter();
		script.println("<scipt>");
		script.println("alert('유효하지 않은 글입니다')");
		script.println("location.href='Javavvs.jsp'");
		script.println("</script>");
	}
	
	//해당 'jbbsID'에 대한 게시글을 가져온 다음 세션을 통하여 작성자 본인이 맞는지 체크한다
	jBbs bbs = new jBbsDAO().getjbbs(jbbsID);
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<scipt>");
			script.println("alert('권한이 없습니다')");
			script.println("location.href='Javavvs.jsp'");
			script.println("</script>");
		} else{
			//입력이 안 된 부분이 있는지 체크한다
			
			if(bbs.getJbbsTitle() == null || bbs.getJbbsContent() == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else {
				//정상적으로 입력이 되었다면 글쓰기 로직을 수행한다.
				jBbsDAO bbsDAO = new jBbsDAO();
				int result = bbsDAO.update(jbbsID, request.getParameter("jbbsTitle"),request.getParameter("jbbsContent"));
				//데이터베이스 오류인 경우
				if(result == -1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
					//글쓰기가 정상적으로 실행되면 알림창을 띄우고 게시판 메인으로 이동
				} else{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기 성공')");
					script.println("location.href='Javavvs.jsp'");
					script.println("</script>");
					}		
			}	
		}
		
	%>
</body>
</html>