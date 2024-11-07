import 'Character.dart';

class Monster{
  String monName;
  int mHp;
  int mPower;
  int mDefence;
  //캐릭터에게 공격 가하기
  void attackCharacter(Character character){
    character.hp -= mPower+character.defence;
    print('>> ${monName} 가 ${character.name}에게 $mPower 만큼의 데미지를 입혔습니다.');
  }
  //몬스터의 체력, 공격력 출력
  void showStatus(){
    print('[$monName - 체력:$mHp 공격력:$mPower]');
  }

  Monster({this.monName='monster1',this.mHp=0,this.mPower=0,this.mDefence=0});
}