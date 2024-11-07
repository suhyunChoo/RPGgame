import 'Monster.dart';

class Character{
  String name = '';
  //체력
  int hp;
  //공격력
  int power;
  //방어력
  int defense;

  Character({this.name = 'user1', this.hp = 0, this.power = 0, this.defense = 0});

  //공격
  void attackMonster(Monster monster){
    print('>> $name이(가) ${monster.monName}에게 $power의 데미지를 입혔습니다.');
    monster.mHp -= power + monster.mDefense;
  }
  //방어
  void defend(Monster monster) async{
    print('>> $name이(가) 방어태세를 취하여 ${monster.mPower} 만큼의 체력을 얻었습니다.');
    hp+=monster.mPower;
  }
  //상태출력 체력,공격력,방어력 출력
  void showState(){
    print('[$name - 체력:$hp 공격력:$power 방어력:$defense]');
  }

  //아이템 사용 여부를 확인하는 변수와 아이템 사용을 처리하는 함수
  void checkItem(bool characterItem){
    if(characterItem==false){
      //한번도 안 쓴 상태가 false, 한 번이라도 쓰면 true
      print('아이템을 사용하여 한 턴 동안 공격력이 2배가 됩니다.');
      power *= 2;

    }else{
      print('아이템을 이미 사용했습니다. 더 이상 사용할 수 없습니다.');
    }
  }
}