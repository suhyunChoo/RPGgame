import 'dart:io';
import 'dart:async';
import 'dart:math';

class Game {

  Character character = Character();
  Monster monster = Monster();
  var random = Random();

  List<Monster> monsterList = [];
  int killedMonster = 0;
  bool isTerminated = false;
  bool gameResult = true;

  //게임 시작 메서드
  Future<void> startGame() async{

    print('게임을 시작합니다!');
    print('\n');
    character.showStatus();

    await battle();
    
  }

  //전투 진행 메서드
  Future<void> battle() async{

    //랜덤으로 몬스터 불러오기
    Monster randomMonster = await getRandomMonster();

    while(!isTerminated){

      //캐릭터의 공격 차례
      print("\n${character.name}의 턴");
      print("행동을 선택하세요 1: 공격 2: 방어");
      String? inputAction = stdin.readLineSync();

      switch (inputAction) {
        case '1':
          character.attackMonster(randomMonster);
        case '2':
          character.defend(randomMonster);
        default:
          print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
      }
 
      //몬스터의 공격 차례
      print("\n${randomMonster.monName}의 턴");
      randomMonster.attackCharacter(character);
      print('\n');
      character.showStatus();
      randomMonster.showStatus();
      print('\n');

      //캐릭터가 패배 했을 경우
      if(character.hp <= 0){

        gameResult = false;

        print('몬스터에게 졌습니다.');
        print("파일을 저장 하시겠습니까? (y/n)");
        askWriteFile();

      }

      //캐릭터가 승리 했을 경우
      if(randomMonster.mHp <= 0){
  
        killedMonster ++;
        
        print("${randomMonster.monName} 를 물리쳤습니다!");
        print("다음 몬스터와 싸우시겠습니까? (y/n)");

        String? inputString = stdin.readLineSync();
        switch (inputString) {
          case 'y':
            monsterList.remove(randomMonster);
            randomMonster =await getRandomMonster();
          case 'n':
            askWriteFile();
            isTerminated=true;
          default:
            print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
            isTerminated=true;
        }
      }
    }
  }

  //랜덤으로 몬스터 불러오는 메서드
  Future<Monster> getRandomMonster() async{
    //try-catch문으로 짜주면 될 듯?
    if (monsterList.isEmpty) {
      print('몬스터 리스트가 비어있습니다. 게임을 종료합니다');
      if (killedMonster>0){
        askWriteFile();
      }
      isTerminated = true;
      return Monster();  // 비어있으면 기본 몬스터를 반환하거나, 예외 처리
    }
    int randomNumber = random.nextInt(monsterList.length);
    print('\n새로운 몬스터가 나타났습니다.');
    monsterList[randomNumber].showStatus();
    return monsterList[randomNumber];
  }

  //캐릭터 파일 불러오기
  Future<void> openCharacterFile() async{

    var file = File('characters.txt');
    
    try {

      List<String> lines = await file.readAsLines();

      //캐릭터에 집어넣기
      for (int i = 1; i < lines.length; i++) {

        var values = lines[i].split(',');
        int hp = int.parse(values[0].trim());
        int power = int.parse(values[1].trim());
        int defence = int.parse(values[2].trim());   

        character.hp=hp;
        character.power = power;
        character.defence = defence;
      }
    }catch (e) {
      print('파일을 읽는 중 에러 발생: $e');
    }
  }

  //몬스터 파일 불러오기
  Future<void> openMonsterFile() async{

    var file = File('monsters.txt');
    try {

      List<String> lines = await file.readAsLines();

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
  
  //파일 저장 메서드
  void writeFile(String result){
    
    String path = 'result.txt';
    // 쓸 내용:캐릭터의 이름, 남은 체력, 게임 결과(승리/패배)
    String content = '${character.name},${character.hp},${result}';

    // File 객체 생성
    File file = File(path);
    file.writeAsStringSync(content);

    print('파일에 내용을 작성했습니다: $path');

  }
  
  //파일 저장할건지 물어보는 메서드
  void askWriteFile(){
    print("파일을 저장 하시겠습니까? (y/n)");
        String? inputString = stdin.readLineSync();
        switch (inputString) {
          case 'y':
            if(gameResult==true){
              writeFile('승리');  
            }else{
              writeFile('패배');  
            }
            isTerminated=true;          
          case 'n':
            isTerminated=true;
          default:
            print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
            isTerminated=true;
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
    print('>>$name - 체력:$hp 공격력:$power 방어력:$defence');
  }

  Character({this.name = 'user1', this.hp = 0, this.power = 0, this.defence = 0});

}

class Monster{
  String monName;
  int mHp;
  int mPower;
  //캐릭터에게 공격 가하기
  void attackCharacter(Character character){
    character.hp-=mPower;
    print('${monName} 가 ${character.name}에게 $mPower 만큼의 데미지를 입혔습니다.');
  }
  //몬스터의 체력, 공격력 출력
  void showStatus(){
    print('>>$monName - 체력:$mHp 공격력:$mPower');
  }

  Monster({this.monName='monster1',this.mHp=0,this.mPower=0});
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
    game.character.name = inputName;
  }else{
    print('한글, 영문 대소문자만 입력해주세요.');
  }

  // 비동기 파일 불러오기 (캐릭터와 몬스터)
  await game.openCharacterFile(); 
  await game.openMonsterFile(); 

  // 파일이 모두 로드된 후에 게임 시작
  await game.startGame();        
  
}