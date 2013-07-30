#include "token.hpp"


/**
  * デストラクタ
  */
TokenSet::~TokenSet(){
	for(int i=0; i<Tokens.size(); i++){
		SAFE_DELETE(Tokens[i]);
	}
	Tokens.clear();
}


/**
  * トークン取得
  * @return CureIndex番目のToken
  */
Token TokenSet::getToken(){
	return *Tokens[CurIndex];
}


/**
  * インデックスを一つ増やして次のトークンに進める
  * @return 成功時：true　失敗時：false
  */
bool TokenSet::getNextToken(){
	int size=Tokens.size();
	if(--size==CurIndex){
		return false;
	}else if( CurIndex < size ){
		CurIndex++;
		return true;	
	}else{
		return false;
	}
}


/**
  * インデックスをtimes回戻す
  */
bool TokenSet::ungetToken(int times){
	for(int i=0; i<times;i++){
		if(CurIndex == 0)
			return false;
		else
			CurIndex--;
	}
	return true;
}


/**
  * 格納されたトークン一覧を表示する
  */
bool TokenSet::printTokens(){
	std::vector<Token*>::iterator titer = Tokens.begin();
	while( titer != Tokens.end() ){
		fprintf(stdout,"%d:", (*titer)->getTokenType());
		if((*titer)->getTokenType()!=TOK_EOF)
			fprintf(stdout,"%s\n", (*titer)->getTokenString().c_str());
		++titer;
	}
	return true;
}


