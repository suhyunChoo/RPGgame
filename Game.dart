import 'dart:io';
import 'dart:math';
import 'Character.dart';
import 'Monster.dart';

class Game {

  Character character = Character();
  Monster monster = Monster();
  var random = Random();

  List<Monster> monsterList = [];
  int killedMonster = 0;
  bool isTerminated = false;
  bool gameResult = true;

  int monsterTurn = 0;

  //게임 시작 메서드
  Future<void> startGame() async{

    print('게임을 시작합니다!\n');
    character.showState();

    await battle();
    
  }

  //전투 진행 메서드
  Future<void> battle() async{
    bool characterItem = false;
    int originalPower = character.power;

    Monster randomMonster = await getRandomMonster();

    bonusHp();

    while(!isTerminated){

      //캐릭터가 공격
      characterTurn(randomMonster, characterItem, originalPower);

      //몬스터가 공격
      monsterAttack(randomMonster);
      monsterTurn++;

      //3턴마다 몬스터 방어력 증가
      monsterDefenseUp(randomMonster);

      //아이템 한 번씩만 쓸 수 있게
      character.power = originalPower;

      //결과 판단
      judgeResult(character,randomMonster);

    }
  }

  //이기고 졌는지 판단
  void judgeResult (character,randomMonster){
    //캐릭터가 졌을 경우
    if(character.hp<0 &&randomMonster.mHp>=0){
      gameResult = false;
      print('몬스터에게 졌습니다.');
      askWriteFile();
    }
    //몬스터가 졌을 경우
    if(randomMonster.mHp<0){
      killedMonster ++;
        //입력이 바르게 됐는지 판단위함
        bool inputIncorrect = false;
        
        print("${randomMonster.monName} 를 물리쳤습니다!");

        while(inputIncorrect==false){
          print("다음 몬스터와 싸우시겠습니까? (y/n)");
          String? inputString = stdin.readLineSync();
          try {
            switch (inputString) {
              case 'y':
                monsterList.remove(randomMonster);
                randomMonster = getRandomMonster();
                inputIncorrect = true;
                break;
              case 'n':
                askWriteFile();
                inputIncorrect = true;
                break;
              default:
                print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
            }
          } catch (e) {
            print("오류 발생: $e");
          }
        }
      }
    }

  //캐릭터 공격 메서드
  void characterTurn(randomMonster, characterItem, originalPower){
    bool validInput = false;
    while(validInput==false){
      print("\n${character.name}의 턴");
      print("행동을 선택하세요 1: 공격 2: 방어 3: 아이템 사용");

      String? inputAction = stdin.readLineSync();
      try {
        switch (inputAction) {
          case '1':
            character.attackMonster(randomMonster);
            validInput = true;
          case '2':
            character.defend(randomMonster);
            validInput = true;
          case '3':
            character.checkItem(characterItem,originalPower);
          default:
            print('다시 입력해주세요');
        }
      } catch (e) {
        print("오류 발생: $e");
      }
    }
  }
  
  //몬스터 공격 메서드
  void monsterAttack(Monster randomMonster){
    //몬스터의 공격 차례
      print("\n${randomMonster.monName}의 턴");
      randomMonster.attackCharacter(character);
      print('\n');
      character.showState();
      randomMonster.showState();
      print('\n');
  }

  //랜덤으로 몬스터 불러오는 메서드
  Future<Monster> getRandomMonster() async{
    //몬스터 턴 초기화
    monsterTurn=0;
    //몬스터 불러오기
    if (monsterList.isEmpty) {
      print('몬스터 리스트가 비어있습니다. 게임을 종료합니다');
      if (killedMonster>0){
        askWriteFile();
      }
      isTerminated = true;
      return Monster();
    }
    int randomNumber = random.nextInt(monsterList.length);
    print('\n새로운 몬스터가 나타났습니다.');
    monsterList[randomNumber].showState();
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
        character.defense = defence;
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
    file.writeAsStringSync(content + '\n', mode: FileMode.append);

    print('파일에 내용을 작성했습니다: $path');

  }
  
  //파일 저장할건지 물어보는 메서드
  void askWriteFile(){
    bool askInput = false;
    while(askInput==false){
      print("파일을 저장 하시겠습니까? (y/n)");
      String? inputString = stdin.readLineSync();
      switch (inputString) {
        case 'y':
          if(gameResult==true){
            writeFile('승리');  
          }else{
            writeFile('패배');  
          }
          askInput = true;      
        case 'n':
          askInput = true;
        default:
          print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
        }

    }
    isTerminated=true;
  }

  //캐릭터에게 30%의 확률로 체력을 10 증가시켜주는 메서드
  void bonusHp(){
    int probability = 30;
    int randomValue = random.nextInt(100);
    if (randomValue < probability) {
      character.hp += 10;
      print('\n보너스 체력을 얻었습니다. 현재 체력: ${character.hp}');
    }else{
      print('\n보너스를 얻지 못했습니다.');
    }
  }

  //3턴마다 몬스터의 방어력을 2씩 증가시켜주는 메서드
  void monsterDefenseUp(Monster randomMonster){
    if (monsterTurn%3==0){
      randomMonster.mDefense+=2;
      print('${randomMonster.monName}의 방어력이 증가했습니다. 현재 방어력: ${randomMonster.mDefense}');
    }
  }
}
