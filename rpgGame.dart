class Game extends Character{
  //캐릭터
  Character();3
  //몬스터리스트
  List<Monster> monsterList = [];
  //처치된 몬스터 개수
  int killedMonster = 0;
  //게임 시작 메서드
  void startGame(){}
  //전투 진행 메서드
  void battle(){}
  //랜덤으로 몬스터 불러오는 메서드
  void getRandomMonster(){}

}

class Character{
  String name = '';
  //체력
  int hp = 0;
  //공격력
  int power = 0;
  //방어력
  int defence = 0;

  //공격
  void attackMonster(Monster monster){}
  //방어
  void defend(){}
  //상태출력 체력,공력력,방어력 출력
  void showStatus(){}

}

class Monster{
  String monName = '';
  int mHp = 0;
  //몬스터의 공격력 랜덤값으로.
  int mPower = 0;
  int mDefence = 0;

  void attackCharacter(Character character){}

  void showStatus(){}
}

void main() {
  
}