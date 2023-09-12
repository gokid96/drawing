<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix='c'    uri='http://java.sun.com/jsp/jstl/core' %>
<%@ taglib prefix='fmt'  uri='http://java.sun.com/jsp/jstl/fmt' %>
<%@ taglib prefix='fn'   uri='http://java.sun.com/jsp/jstl/functions' %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>드로잉썸 | 매니저</title>
<!-- Bootstrap -->
<link href="../../../vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome -->
<link href="../../../vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<!-- NProgress -->
<link href="../../../vendors/nprogress/nprogress.css" rel="stylesheet">
<!-- iCheck -->
<link href="../../../vendors/iCheck/skins/flat/green.css" rel="stylesheet">

<!-- bootstrap-progressbar -->
<link href="../../../vendors/bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css" rel="stylesheet">
<!-- JQVMap -->
<link href="../../../vendors/jqvmap/dist/jqvmap.min.css" rel="stylesheet"/>
<!-- bootstrap-daterangepicker -->
<link href="../../../vendors/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet">

<!-- Custom Theme Style -->
<link href="../../../css/admin/custom.min.css" rel="stylesheet">

<style>


#btn{
    float: right;
    margin-top: 10px;
}

.photo{
    margin-left: 50px;
    font-size: 18px;
    line-height: 26px;
    letter-spacing: -0.02em;
    padding:30px;
}
#c_content,#s_subject,#r_regdate
,#i_ip{
    margin-left: 8px;
    color: #222;
    font-weight: bold;
    font-size: 18px;
    line-height: 21px;
    letter-spacing: -0.03em;
    text-align: right;
}

.panel-primary {
    border-color: #92A8D1;
}

.panel-primary>.panel-heading {
    background-color:#92A8D1;
    border-color:#92A8D1;
}


#c_menu{
    height: 100%;
    width: 100%;
    display: table;

}
#comment_btn{
    margin-top: 30px;
    float: right;
    height: 100px;
    width: 130px;
    display: none;
    
}


#comment_display{
    width: 90%;
    height: 150px;
    display: table;
}
.comment_content{
    width: 100%;
    height: 100%;
    display: table-row;
    word-break:normal;
/*word-break의 기본값으로 단어 단위로 끊어서 줄바꿈*/
word-break:break-all;
/*특수문자를 제외하고 강제로 줄바꿈*/
word-break:break-word;
/*특수문자를 포함하고 강제 줄바꿈*/
}


#comment_content{
    width: 100%;
    height: 150px;
    resize: none;
    padding: 20px;
   
}

#box{
    
    width: 100%;
    margin: auto;
    margin-top: 80px;
    padding: 7px 10px;

}

.photo img{
    width: 50%;
}

h1{
    text-align: center;
    padding-bottom: 50px;
}

#vo_label{
    margin-left: 8px;
}

</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

function    del(q_idx){

    if(confirm("정말 삭제하시겠습니까?")==false)return;

    location.href="man_question_delete?q_idx=" + q_idx +"&page=${ param.page }&search=${param.search}&search_text=${ param.search_text }"; 
   
}

// 댓글작성
let global_comment_page = 1;

function comment_insert(){


    let comment_content = $("#comment_content").val().trim();

    if(comment_content==""){
        alert("댓글내용을 작성하세요!!");
        $("#comment_content").val("");
        $("#comment_content").focus();
        return;
    }

    //댓글쓰기
    $.ajax({

        url   : "man_comment_insert",
        data  : {
                    "q_idx"          : "${ vo.q_idx }",
                    "comment_content": comment_content,
                    "mem_idx"        : "${ user.mem_idx }",
                    "mem_id"         : "${ user.mem_id }",
                    "mem_name"       : "${ user.mem_name }"
                },
        dataType : "json",
        success  : function(res_data){

            //res_data = {"result" : "success" }
            //res_data = {"result" : "fail" }
            if(res_data.result=="success"){
            
            //이전 댓글내용삭제
            $("#comment_content").val("");
            //댓글목록을 재요청
            comment_list(1);
            }

        },
        error    : function(err){
            alert(err.responseText);
        }
    });
}

//댓글조회
function comment_list(comment_page){

    $.ajax({
        url   : "man_comment_list",  // comment_list.do?b_idx=5&page=1
        data  : {
                "q_idx":"${ vo.q_idx }",
                "page" : comment_page
                },
        success: function(res_data){
        
            global_comment_page = comment_page;

            //댓글영역 넣어준다
            $("#comment_display").html(res_data);
  // 댓글이 없을 때만 답변하기 버튼을 표시
   // 댓글이 없을 때만 "답변하기" 버튼을 표시
   if ($("#comment_display .comment_content").length === 0) {
                $("#comment_btn").show();
            } else {
                $("#comment_btn").hide();
            }
        },
        error  : function(err){

            alert(err.responseText);

        }        

    });
}


</script> 


<script>
    
    //현재 html문서배치완료되면 댓글목록 가져와서 출력
    $(document).ready(function(){
        
    comment_list(1);

    });

</script>



</head>
<body class="nav-md">
<div class="container body">
    <div class="main_container">
        <div class="col-md-3 left_col">
            <div class="left_col scroll-view">
                <div class="navbar nav_title" style="border: 0;">
                    <a href="/manager/main" class="site_title"><i class="fa fa-paw"></i> <span>Drawing SSum</span></a>
                </div>

                <div class="clearfix"></div>

                <!-- menu profile quick info -->
                
                    <div class="profile_info">
                        <span>안녕하세요,</span>
                        <h2>고성민</h2>님

                    </div>
               
                <!-- /menu profile quick info -->

                <br />

                <!-- sidebar menu -->
                <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
                    <div class="menu_section">
                        <ul class="nav side-menu">
                            <li><a><i class="fa fa-home"></i> 홈 <span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu" style="display: block;">
                                    <li><a href="/manager/main">매니저 홈</a></li>
                                    <li><a href="/main">드로잉썸 바로가기</a></li>
                                </ul>
                            </li>
                            <li><a><i class="fa fa-edit"></i> 일반회원 관리 <span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu" >

                                    <li><a href="#">일반회원 목록</a></li>
                                    <li><a href="#">메세지 보내기</a></li>
                                    <li><a href="#">메일 발송</a></li>
                                    <li><a href="#">SMS  발송</a></li>

                                </ul>
                            </li>
                            <li><a><i class="fa fa-desktop"></i> 관리자회원 관리 <span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu">
                                    <li><a href="#">관리자회원 목록</a></li>
                                    <li><a href="#">괸리자회원 승인 대기 목록</a></li>
                                    <li><a href="#">메세지 보내기</a></li>
                                    <li><a href="#">메일 발송</a></li>
                                    <li><a href="#">SMS  발송</a></li>

                                </ul>
                            </li>
                            
                            <li><a><i class="fa fa-desktop"></i> 1:1 문의하기 <span class="fa fa-chevron-down"></span></a>
                                <ul class="nav child_menu">

                                    <li><a href="/manager/question_list">문의내역</a></li>

                                </ul>
                            </li>
                            <li><a href="/calendar">캘린더</a></li>
                        </ul>
                    </div>
        

                </div>
                <!-- /sidebar menu -->


            </div>
        </div>

        <!-- top navigation -->
        <div class="top_nav">
            <div class="nav_menu">
                <nav>
                    <div class="nav toggle">
                        <a id="menu_toggle"><i class="fa fa-bars"></i></a>
                    </div>

                    <ul class="nav navbar-nav navbar-right">
                        <li class="">
                            <a href="javascript:;" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                                
                                <img src="../../../manager/images/img.jpg" alt="">John Doe
                                <span class=" fa fa-angle-down"></span>
                            </a>
                            <ul class="dropdown-menu dropdown-usermenu pull-right">
                                <li><a href="javascript:;"> Profile</a></li>
                                <li>
                                    <a href="javascript:;">
                                        <span class="badge bg-red pull-right">50%</span>
                                        <span>Settings</span>
                                    </a>
                                </li>
                                <li><a href="javascript:;">Help</a></li>
                                <li><a href="login.jsp"><i class="fa fa-sign-out pull-right"></i> Log Out</a></li>
                            </ul>
                        </li>

                        <li role="presentation" class="dropdown">
                            <a href="javascript:;" class="dropdown-toggle info-number" data-toggle="dropdown" aria-expanded="false">
                                <i class="fa fa-envelope-o"></i>
                                <span class="badge bg-green">6</span>
                            </a>
                            <ul id="menu1" class="dropdown-menu list-unstyled msg_list" role="menu">
                                <li>
                                    <a>
                                        <span class="image"><img src="images
                                            /img.jpg" alt="Profile Image" /></span>
                                        <span>
                          <span>John Smith</span>
                          <span class="time">3 mins ago</span>
                        </span>
                                        <span class="message">
                          Film festivals used to be do-or-die moments for movie makers. They were where...
                        </span>
                                    </a>
                                </li>
                                <li>
                                    <a>
                                        <span class="image"><img src="images/img.jpg" alt="Profile Image" /></span>
                                        <span>
                          <span>John Smith</span>
                          <span class="time">3 mins ago</span>
                        </span>
                                        <span class="message">
                          Film festivals used to be do-or-die moments for movie makers. They were where...
                        </span>
                                    </a>
                                </li>
                                <li>
                                    <a>
                                        <span class="image"><img src="images/img.jpg" alt="Profile Image" /></span>
                                        <span>
                          <span>John Smith</span>
                          <span class="time">3 mins ago</span>
                        </span>
                                        <span class="message">
                          Film festivals used to be do-or-die moments for movie makers. They were where...
                        </span>
                                    </a>
                                </li>
                                <li>
                                    <a>
                                        <span class="image"><img src="images/img.jpg" alt="Profile Image" /></span>
                                        <span>
                          <span>John Smith</span>
                          <span class="time">3 mins ago</span>
                        </span>
                                        <span class="message">
                          Film festivals used to be do-or-die moments for movie makers. They were where...
                        </span>
                                    </a>
                                </li>
                                <li>
                                    <div class="text-center">
                                        <a>
                                            <strong>See All Alerts</strong>
                                            <i class="fa fa-angle-right"></i>
                                        </a>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
        <!-- /top navigation -->
<!-- page content -->
<div class="right_col" role="main">
            


	<div id="box">
   <div class="panel panel-primary">
            <div class="panel-heading"><h4>${ vo.mem_name }님의 문의내역</h4> <label>${ vo.q_subject }</label></div>
       
                <!-- 내용 -->
                <label id="c_content"></label>
            <div class="mystyle" id="content">
                    <label id="vo_label">${ vo.q_content }</label>
                <br><br>
                    <div class="photo">
                        <img src="../upload/${ vo.q_filename }" >
                    </div>
                
            </div>

                <!-- 작성일자/IP -->
                <br>
                <label id="r_regdate">작성일자</label>
                <div class="mystyle">
                <label id="vo_label">${ fn:substring(vo.q_regdate,0,16) } </label>
                </div>
                <br>
                <label id="i_ip">IP</label>
                <div class="mystyle">
                <label id="vo_label">(${ vo.q_ip})</label>
                </div>

                <!-- 작업버튼 -->
                <div id="btn">
                    <input  class="btn btn-primary" type="button" value="목록보기"
                            onclick="location.href='/manager/man_question_list?page=${ param.page }&search=${ param.search }&search_text=${ param.search_text }'">

                    <input  class="btn btn-danger"  type="button" value="삭제하기"
                            onclick="del('${ vo.q_idx }');">
                </div>
                
            </div>
        
        </div>


        <hr style="clear:both;">    

        
        <input    id="comment_btn" type="button" value="답변하기"
        onclick="comment_insert();">


        <!-- 댓글출력영역 -->
        <div id="comment_display">
   
        </div>
        




	</div>

</div>


                    

<!-- jQuery -->

<script src="../../../vendors/jquery/dist/jquery.min.js"></script>
<!-- Bootstrap -->
<script src="../../../vendors/bootstrap/dist/js/bootstrap.min.js"></script>
<!-- FastClick -->
<script src="../../../vendors/fastclick/lib/fastclick.js"></script>
<!-- NProgress -->
<script src="../../../vendors/nprogress/nprogress.js"></script>
<!-- Chart.js -->
<script src="../../../vendors/Chart.js/dist/Chart.min.js"></script>
<!-- gauge.js -->
<script src="../../../vendors/gauge.js/dist/gauge.min.js"></script>
<!-- bootstrap-progressbar -->
<script src="../../../vendors/bootstrap-progressbar/bootstrap-progressbar.min.js"></script>
<!-- iCheck -->
<script src="../../../vendors/iCheck/icheck.min.js"></script>
<!-- Skycons -->
<script src="../../../vendors/skycons/skycons.js"></script>
<!-- Flot -->
<script src="../../../vendors/Flot/jquery.flot.js"></script>
<script src="../../../vendors/Flot/jquery.flot.pie.js"></script>
<script src="../../../vendors/Flot/jquery.flot.time.js"></script>
<script src="../../../vendors/Flot/jquery.flot.stack.js"></script>
<script src="../../../vendors/Flot/jquery.flot.resize.js"></script>
<!-- Flot plugins -->
<script src="../../../vendors/flot.orderbars/js/jquery.flot.orderBars.js"></script>
<script src="../../../vendors/flot-spline/js/jquery.flot.spline.min.js"></script>
<script src="../../../vendors/flot.curvedlines/curvedLines.js"></script>
<!-- DateJS -->
<script src="../../../vendors/DateJS/build/date.js"></script>
<!-- JQVMap -->
<script src="../../../vendors/jqvmap/dist/jquery.vmap.js"></script>
<script src="../../../vendors/jqvmap/dist/maps/jquery.vmap.world.js"></script>
<script src="../../../vendors/jqvmap/examples/js/jquery.vmap.sampledata.js"></script>
<!-- bootstrap-daterangepicker -->
<script src="../../../vendors/moment/min/moment.min.js"></script>
<script src="../../../vendors/bootstrap-daterangepicker/daterangepicker.js"></script>

<!-- Custom Theme Scripts -->
<script src="../../../js/custom.min.js"></script>

</body>
</html>
