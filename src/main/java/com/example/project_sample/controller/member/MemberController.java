package com.example.project_sample.controller.member;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.project_sample.dao.member.MemberDao;
import com.example.project_sample.vo.member.MemberVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/member")
public class MemberController {


    MemberDao dao;


    @Autowired
    public MemberController(MemberDao dao) {
        this.dao = dao;
    }


    @Autowired
    private PasswordEncoder pwEncoder;


    @Autowired
    HttpServletRequest request;

    @Autowired
    HttpSession session;


    @Autowired
    ServletContext application;

    @RequestMapping("/login")
    public String login(){

        return "member/login";
    }



    @RequestMapping("/join")
    public String test(){

        return "member/join";
    }


    @RequestMapping("/join_ceo")
    public String join_ceo(){

        return "member/join_ceo";
    }




    @RequestMapping("/check_id")
    @ResponseBody
    public Map checkId(String mem_id){

        String id = dao.checkId(mem_id);

        Map map = new HashMap();

        if (id!=null) {
            map.put("result",false);
        }else {
            map.put("result",true);
        }

        return map;
    }



    @RequestMapping("/check_nickname")
    @ResponseBody
    public Map checkNickname(String mem_nickname){

        String nickname = dao.checkNickname(mem_nickname);

        Map map = new HashMap();

        if (nickname!=null) {
            map.put("result",false);
        }else {
            map.put("result",true);
        }

        return map;
    }



    @RequestMapping("/register")
    @PostMapping
    public String register(MemberVo vo, @RequestParam(name="photo") MultipartFile photo, Model model)
                            throws IOException {



        String web_path = "/img/profile-img/";
        String abs_path = application.getRealPath(web_path);

        String mem_photo = "no_file";


        if(mem_photo.isEmpty()==false) {
            mem_photo = photo.getOriginalFilename();
            vo.setMem_photo(mem_photo);
            File f = new File(abs_path, mem_photo);

            if(f.exists()) {
                long tm = System.currentTimeMillis();

                //파일명 -> 시간_파일명
                mem_photo = String.format("%d_%s",tm,mem_photo);
                vo.setMem_photo(mem_photo);
                f = new File(abs_path,mem_photo);

            }

            //임시파일 -> f로 복사
            photo.transferTo(f);
        }

        vo.setMem_addr(vo.getMem_addr().replace(","," "));
        vo.setMem_phone(vo.getMem_phone().replaceAll(",","-"));


        String encodepwd = pwEncoder.encode(vo.getMem_pwd());
        vo.setMem_pwd(encodepwd);


        int res = dao.insert(vo);

        if(res==0) {
            System.out.println("failed");
        }

        return "member/complete_join";
    }



    //로그인
    @RequestMapping("/login.do")
    @PostMapping
    public String login(String mem_id, String mem_pwd, RedirectAttributes ra) {

        MemberVo vo = dao.selectOne(mem_id);

        String encodePwd;

        if (vo == null) {
            ra.addAttribute("reason", "wrong_id");
            return "redirect:login";
        } else {
            encodePwd = vo.getMem_pwd();

            if (pwEncoder.matches(mem_pwd, encodePwd)) {
                vo.setMem_pwd("");
                session.setAttribute("user", "user");
                return "redirect:../main";
            } else {
                ra.addAttribute("reason", "wrong_pwd");
                ra.addAttribute("mem_id", mem_id);
                return "redirect:login";
            }
        }


    }


    //로그아웃
    @RequestMapping("/logout")
    public String logout(){
        session.removeAttribute("user");

        return "redirect:../main";
    }


    //아이디, 비밀번호 찾기 폼
    @RequestMapping("/find_id")
    public String find_Id(){

        return "member/find_id";
    }


}
