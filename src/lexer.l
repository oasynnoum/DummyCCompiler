#include "lexer.hpp"



/**
 * トークン切り出し関数
 * @param 字句解析対象ファイル名
 * @return 切り出したトークンを格納したTokenSet
 */
TokenSet *LexicalAnalysis(std::string input_filename){
	TokenSet *tokens=new TokenSet();
	std::ifstream ifs;
	std::string cur_line;
	std::string token_str;
	int line_num=0;
	bool iscomment=false;

	ifs.open(input_filename.c_str(), std::ios::in);
	if(!ifs)
		return NULL;
	while(ifs && getline(ifs, cur_line)){
		char next_char;
		std::string line;
		Token *next_token;
		int index=0;				
		int length=cur_line.length();
	
		while(index<length){	
			next_char = cur_line.at(index++);

			//コメントアウト読み飛ばし
			if(iscomment){
				if( (length-index) < 2 
					||	(cur_line.at(index) != '*') 
					|| (cur_line.at(index++) != '/') ){
					continue;
				}else{
					iscomment=false;
				}
			}
		
			//EOF
			if(next_char == EOF){
				token_str = EOF;
				next_token = new Token(token_str, TOK_EOF, line_num);
		
			}else if(isspace(next_char)){
				continue;

			//IDENTIFIER
			}else if(isalpha(next_char)){
				token_str += next_char;
				next_char = cur_line.at(index++);
				while(isalnum(next_char)){
					token_str += next_char;
					next_char = cur_line.at(index++);
					if(index==length)
						break;
				}
				index--;
		
				if(token_str == "int"){
					next_token = new Token(token_str, TOK_INT, line_num);
				}else if(token_str == "return"){
					next_token = new Token(token_str, TOK_RETURN, line_num);
				}else{
					next_token = new Token(token_str, TOK_IDENTIFIER, line_num);
				}
		
			//数字
			}else if(isdigit(next_char)){
				if(next_char=='0'){
					token_str += next_char;
					next_token = new Token(token_str, TOK_DIGIT, line_num);
				}else{
					token_str += next_char;
					next_char = cur_line.at(index++);
					while(isdigit(next_char)){
						token_str += next_char;
						next_char = cur_line.at(index++);
					}
					next_token = new Token(token_str, TOK_DIGIT, line_num);
					index--;
				}
		
			//コメント or '/'
			}else if(next_char == '/'){
				token_str += next_char;
				next_char = cur_line.at(index++);

				//コメントの場合
				if(next_char == '/'){
						break;
		
				//コメントの場合
				}else if(next_char == '*'){
					iscomment=true;
					continue;
		
				//DIVIDER('/')
				}else{
					index--;
					next_token = new Token(token_str, TOK_SYMBOL, line_num);
				}
		
			//それ以外(記号)
			}else{
				if(next_char == '*' ||
						next_char == '+' ||
						next_char == '-' ||
						next_char == '=' ||
						next_char == ';' ||
						next_char == ',' ||
						next_char == '(' ||
						next_char == ')' ||
						next_char == '{' ||
						next_char == '}'){
					token_str += next_char;
					next_token = new Token(token_str, TOK_SYMBOL, line_num);

				//解析不能字句
				}else{
					fprintf(stderr, "unclear token : %c", next_char);
					SAFE_DELETE(tokens);
					return NULL;
				}
			}
		
			//Tokensに追加
			tokens->pushToken(next_token);
			token_str.clear();
		}

		token_str.clear();
		line_num++;
	}


	//EOFの確認
	if(ifs.eof()){
		tokens->pushToken(
				new Token(token_str, TOK_EOF, line_num)
				);
	}

	//クローズ
	ifs.close();
	return tokens;
}
	
