package main.web;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import main.service.BoardService;
import main.service.BoardVO;

//실질적인 프로그래밍
@Controller
public class BoardController {
	
	@Resource(name = "boardService")
	private BoardService boardService;
	
	@RequestMapping("/boardWrite.do")
	public String boardWrite() {
		return "board/boardWrite";
	}
	
	@RequestMapping("/boardWriteSave.do") //  [ 입력 저장처리 ]
	@ResponseBody //비동기 전송방식으로  화면에 데이터 전송 
	public String insertNBoard(BoardVO vo) throws Exception{
		// result = null 정상실행시 null
		String result = boardService.insertNBoard(vo);
		System.out.println(result);
		String msg = "";
		if(result == null) msg = "ok";
		else msg = "fail";
		
		return msg; //값 전달
	}
	
	@RequestMapping("/boardList.do") //  [ 페이징 처리 ]
	public String selectNBoardList(BoardVO vo,ModelMap model) throws Exception{
		
		int unit = 5;
		
		// 총 데이터 갯수 
		int total = boardService.selectNBoardTotal(vo);
		
		//정수/정수 = 정수값 이어서 double로 변환해서 실수타입의 결과(1.2)를 얻기 위함
		// (double)12/10 -> ceil(1.2):올림 -> Integer(2.0) -> 2페이지
		int totalPage = (int) Math.ceil((double)total/unit);
		
		//사용자가 보려는 페이지
		int viewPage = vo.getViewPage(); 
		if(viewPage> totalPage || viewPage < 1) {
			viewPage = 1;
		}
		//1-> 1,10  //2-> 11,20  //3-> 21,30
		//startIndex : (1-1)*10 + 1 -> 1
		//startIndex : (2-1)*10 + 1 -> 11
		int startIndex = (viewPage- 1)*unit+1;
		int endIndex = startIndex + (unit - 1);
		vo.setStartIndex(startIndex);
		vo.setEndIndex(endIndex);
		
		//행 번호 total -> 34 (4 Page)
		// 1(p)-> 34~25 , 2(p) -> 24~15 , 3(p) -> 14~5, 4(p) -> 4~1
		/* int p1 = total - 0;
		int p2 = total - 10;
		int p3 = total - 20;
		int p4 = total - 30; */
		int startRowNo = total - (viewPage - 1)*unit;  
		
		System.out.println(totalPage);
		
		List<?> list = boardService.selectNBoardList(vo);
		System.out.println("list: " + list);
		
		model.addAttribute("rowNumber",startRowNo);
		model.addAttribute("total",total);
		model.addAttribute("totalPage",totalPage);
		model.addAttribute("resultList",list);
		
		return"board/boardList";//<-화면 깜빡거림이 있기 때문에 <동기방식>
	}
	
	@RequestMapping("/boardDetail.do") // [ 상세보기 ]
	public String selectNBoardDetail(BoardVO vo, ModelMap model) throws Exception{
		/*
		 * 조회수 증가
		 */
		boardService.updateNBoardHits(vo.getUnq());
		BoardVO boardVO = boardService.selectNBoardDetail(vo.getUnq());
		String content = boardVO.getContent(); // \n
		boardVO.setContent(content.replace("\n", "<br>") ); //줄바꿈
		model.addAttribute("boardVO",boardVO);
		return "board/boardDetail";
	}
	
	@RequestMapping("/boardModifyWrite.do")//   [ 수정하기 ]
	public String selectNBoardModfiyWrite(BoardVO vo, ModelMap model) throws Exception{
		BoardVO boardVO = boardService.selectNBoardDetail(vo.getUnq());//상세보기
		model.addAttribute("vo",boardVO);
		return "board/boardModifyWrite";
	}
	
	@RequestMapping("/boardModifySave.do")//  [수정완료 저장버튼]
	@ResponseBody //비동기 전송방식으로  화면에 데이터 전송 
	//↑↑↑ 깜빡거림이 없기 때문에 비동기 방식
	public String updateNBoard(BoardVO vo) throws Exception{
		
		int result = 0;
		int count = boardService.selectNBoardPass(vo); //int count = 1; 암호확인
		if(count == 1) { //if문 안에 선언문은 들어갈 수 없다
			result = boardService.updateNBoard(vo); // int result = 1; 수정처리
		}else{
			result = -1;
		}
		return result+"";
	}
	
	@RequestMapping("/passWrite.do")
	public String passWrite(int unq,ModelMap model) {
		model.addAttribute("unq",unq);
		return "board/passWrite";
	}
	
	@RequestMapping("/boardDelete.do")
	@ResponseBody
	public String deleteBoard(BoardVO vo) throws Exception{
		int result = 0;
		/*
		 * 암호 일치 검사
		 */
		int count = boardService.selectNBoardPass(vo); //int count = 1; 암호확인
		if(count == 1) {
			result = boardService.deleteNBoard(vo);
		}else if(count == 0) {
			result = -1;
		}
		return result+"";
	}
}
