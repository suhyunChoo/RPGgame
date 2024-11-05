import 'dart:io';
import 'dart:async';
import 'dart:math';

class Game {

  Character character = Character();
  Monster monster = Monster();
  List<Monster> monsterList = [];
  int killedMonster = 0;
  var random = Random();

  //게임 시작 메서드
  Future<void> startGame() async{
    print('게임을 시작합니다!');
    character.showStatus();
    if (monsterList.isEmpty) {
      print("몬스터 리스트가 비어있습니다. 게임을 종료합니다.");
      return;
    }
    //게임 돌리기 - 몬스터가 죽을경우, 내 캐릭터가 죽을 경우, 전투
    await battle();
    
  }
  //전투 진행 메서드
  Future<void> battle() async{
    Monster randomMonster =await getRandomMonster();
    bool isTerminated = false;
    while(!isTerminated){
      print("${character.name}의 턴");
      print("행동을 선택하세요");
      String? inputAction = stdin.readLineSync();
      switch (inputAction) {
        case '1':
          character.attackMonster(randomMonster);
        case '2':
          character.defend(randomMonster);
        default:
          print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
      }
        print("${randomMonster.monName}의 턴");
        monster.attackCharacter(character);
        character.showStatus();
        monster.showStatus();
      if(monster.mHp==0){
        print("${randomMonster.monName} 몬스터를 물리쳤습니다!");
        print('\n');
        print("다음 몬스터와 싸우시겠습니까? (y/n)");
        String? inputString = stdin.readLineSync();
        switch (inputString) {
          case 'y':
            monsterList.remove(randomMonster);
            randomMonster =await getRandomMonster();
            
          case 'n':
            isTerminated=true;
          default:
            print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
        }
      }
      // if(character.hp==0){

      // }
    }
  }



  

  //랜덤으로 몬스터 불러오는 메서드
  Future<Monster> getRandomMonster() async{
    if (monsterList.isEmpty) {
      print('몬스터 리스트가 비어있습니다.');
      return Monster();  // 비어있으면 기본 몬스터를 반환하거나, 예외 처리
    }
    int randomNumber = random.nextInt(monsterList.length);
    print('새로운 몬스터가 나타났습니다.');
    monsterList[randomNumber].showStatus();
    return monsterList[randomNumber];
  }

  //캐릭터 파일 불러오기
  Future<void> openCharacterFile() async{

    var file = File('characters.txt');
    try {
      List<String> lines = await file.readAsLines(); // 파일을 라인 단위로 읽기
      //캐릭터에 집어넣기
      for (int i = 1; i < lines.length; i++) {
        // 각 행을 쉼표로 나누어 값 추출
        var values = lines[i].split(',');
        // 각 값을 정수로 변환
        int hp = int.parse(values[0].trim());
        int power = int.parse(values[1].trim());
        int defence = int.parse(values[2].trim());   
        character.hp=hp;
        character.power = power;
        character.defence = defence;
        print('name: ${character.name}, hp: ${character.hp}, power: ${character.power}, defence: ${character.defence}');
      }
    }catch (e) {
      print('파일을 읽는 중 에러 발생: $e');
    }
  }

  Future<void> openMonsterFile() async{

    var file = File('monsters.txt');
    try {
      List<String> lines = await file.readAsLines(); // 파일을 라인 단위로 읽기
      //캐릭터에 집어넣기
      for (int i = 1; i < lines.length; i++) {
        // 각 행을 쉼표로 나누어 값 추출
        var values = lines[i].split(',');
        // 각 값을 정수로 변환
        String name = values[0].trim();
        int hp = int.parse(values[1].trim());
        int power = int.parse(values[2].trim());
        int randomPower = random.nextInt(power);
        Monster monster =Monster(monName: name, mHp: hp, mPower: randomPower);
        monsterList.add(monster);
      }
    }catch (e) {
      print('파일을 읽는 중 에러 발생: $e');
    }
  }
}

class Character{
  String name = '';
  //체력
  int hp;
  //공격력
  int power;
  //방어력
  int defence;

  //공격
  void attackMonster(Monster monster){
    print('$name이(가) ${monster.monName}에게 $power의 데미지를 입혔습니다.');
    monster.mHp -= power;
  }
  //방어
  void defend(Monster monster) async{
    print('$name이(가) 방어태세를 취하여 ${monster.mPower} 만큼의 체력을 얻었습니다.');
    hp+=monster.mPower;
  }
  //상태출력 체력,공력력,방어력 출력
  void showStatus(){
    print('$name - 체력:$hp 공격력:$power 방어력:$defence');
  }

  Character({this.name = 'user1', this.hp = 0, this.power = 0, this.defence = 0});

}

class Monster{
  String monName = '';
  int mHp = 0;
  int mPower = 0;
  //캐릭터에게 공격 가하기
  void attackCharacter(Character character){
    character.hp-=mPower;
    print('$monName 가 ${character.name}에게 $mPower 만큼의 데미지를 입혔습니다.');
  }
  //몬스터의 체력, 공격력 출력
  void showStatus(){
    print('$monName - 체력:$mHp 공격력:$mPower');
  }

  Monster({this.monName='monster1',this.mHp=0,this.mPower=0});
}

  
    //파일로 결과 저장
  void writeFile(){
    String path = 'result.txt';
  
    // 쓸 내용:캐릭터의 이름, 남은 체력, 게임 결과(승리/패배)
    String content = '';

    // File 객체 생성
    File file = File(path);

    // 파일에 문자열을 동기적으로 씁니다.
    file.writeAsStringSync(content);

    print('파일에 내용을 작성했습니다: $path');
  }


void main() async {

  //객체
  Game game = Game();

  //캐릭터 이름 입력 받기
  print('캐릭터의 이름을 입력하세요: ');
  String? inputName = stdin.readLineSync();

  //한글,영문 대소문자만 받기
  RegExp exp = RegExp(r'^[가-힣a-zA-Z]+$');
  if(exp.hasMatch(inputName!)){
    //이름 입력해주기
    game.character.name = inputName;
  }else{
    print('한글, 영문 대소문자만 입력해주세요.');
  }
  //파일에서 불러오기
  // 비동기 파일 불러오기 (캐릭터와 몬스터)
  await game.openCharacterFile();  // 캐릭터 파일 불러오기
  await game.openMonsterFile();    // 몬스터 파일 불러오기

  // 파일이 모두 로드된 후에 게임 시작
  await game.startGame();          // 게임 시작
  
}