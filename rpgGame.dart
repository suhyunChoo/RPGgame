import 'dart:io';
import 'game.dart';


void main() async {

  bool inputCorrect = false;

  //객체
  Game game = Game();

  while(inputCorrect==false){
    print('캐릭터의 이름을 입력하세요: ');
    String? inputName = stdin.readLineSync();
    RegExp exp = RegExp(r'^[가-힣a-zA-Z]+$');
    if(exp.hasMatch(inputName!)){
      game.character.name = inputName;
      inputCorrect=true;
    }else{
      print('한글, 영문 대소문자만 입력해주세요.');
    }
  }

  // 비동기 파일 불러오기 (캐릭터와 몬스터)
  await game.openCharacterFile(); 
  await game.openMonsterFile(); 

  // 파일이 모두 로드된 후에 게임 시작
  await game.startGame();        
  
}