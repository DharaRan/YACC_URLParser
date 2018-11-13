/*
  Developed: Dhara Rana 
  Due Date: 11/11/18
    
*/

%{
  #include<stdio.h>
  #include<ctype.h>
  int yylex(void);
  void yyerror(char const *);
%}

%union {	/* THIS IS YYSTYPE */
   char c;
   char s[200];
  
}

%token <c> COL
%token <c> FS
%token <c> DOT
%token <s> WORD
%token <s> NUM

%type <s> port 
%type <s> path
%type <s> host
%type <s> scheme
%type <s> url

%%
list: /*empty*/
	|list url '\n'
	 {
	   printf("%s\n",$2);
	 }
;
url: /*empty*/  {strcpy($$, "");}  
    |scheme COL FS FS host port path
		{
			

			  strncpy($$,"scheme = ",sizeof($1));
			  strncat($$,$1,sizeof($1));
			  strncat($$,", ",sizeof($1));
			  
			  /*Host Check*/
			  
			  if(strlen($5) == 0){
				 strncat($$,"host = null,",sizeof($5));
			  
			  }else{			  
				 strncat($$,"host = ",sizeof($5));
				 strncat($$,$5,sizeof($5));
				 strncat($$,", ",sizeof($5));
			  
			  }
			  
			  
			  /*Port Check*/
			  if(strlen($6) == 0){
				 strncat($$,"port = null, ",sizeof($6));
			  
			  }else{			  
				 strncat($$,"port = ",sizeof($6));
				 strncat($$,$6,sizeof($6));
				 strncat($$,", ",sizeof($6));
			  
			  }
			  

			 /*Path Check*/
			 if(strlen($7) == 0){
				 strncat($$,"path = null",sizeof($7));
			  
			  }else{			  
				 strncat($$,"path = ",sizeof($7));
				 strncat($$,$7,sizeof($7));
			  
			  }
			 
			 

		}
	
;


host: /*empty */  {strcpy($$, "");}
    |WORD DOT WORD DOT WORD
    {
    	strncpy($$,$1,sizeof($1));
        strncat($$,".",sizeof($3));
	strncat($$,$3,sizeof($3));
        strncat($$,".",sizeof($3));
	strncat($$,$5,sizeof($5));
	
	/*printf("host: %s\n", $$);*/

    } 
;
port:/*empty */  {strcpy($$, "");}      
     |COL NUM
     {
	strncpy($$, $2, sizeof($2));
	/*printf("port: %s\n", $$);*/
     }
;
path:/*empty */ {strcpy($$, "");}  
    |path FS
	  {
         strncpy($$,$1,sizeof($1));
		 strncat($$,"/",sizeof($1));
	  } 
    |path FS WORD
      {
         strncpy($$,$1,sizeof($1));
         strncat($$,"/",sizeof($3));
	     strncat($$,$3,sizeof($3));
         /*printf("path: %s\n", $$);*/
      
      }
    |path FS WORD NUM
      {
         strncpy($$,$1,sizeof($1));
	 strncat($$,"/",sizeof($3));
	 strncat($$,$3,sizeof($3));
	 strncat($$,$4,sizeof($4));
	 /*printf("path: %s\n", $$);*/

      }	
    |path FS WORD NUM DOT WORD
      {
         strncpy($$,$1,sizeof($1));
         strncat($$,"/",sizeof($3));
         strncat($$,$3,sizeof($3));
         strncat($$,$4,sizeof($4));
         strncat($$,".",sizeof($4));
	     strncat($$,$6,sizeof($6));

         /*printf("path: %s\n", $$);*/
      
      
      }
	|path FS WORD DOT WORD
	  {
	     strncpy($$,$1,sizeof($1));
         strncat($$,"/",sizeof($3));
         strncat($$,$3,sizeof($3));
         strncat($$,".",sizeof($4));
	     strncat($$,$5,sizeof($5));
	  }
;

scheme: /*empty */ {strcpy($$, "");}  
    |WORD
     {
        strncpy($$,$1,sizeof($1));
        /*printf("scheme: %s\n", $$);*/
     }		
;

%%

char *progname;
int  lineno = 1;

int yylex() /* the lexer */
{
  int c, p=0;
  char *tv=yylval.s;
 

  if ((c=getc(stdin)) == EOF) { return 0; }
  switch(c) {
	case ':': yylval.c = c; return COL;
	case '/': yylval.c = c; return FS;
	case '.' : return DOT;
  }

  if (isdigit(c)) {   
            while (isdigit(c)) 
            { 
            tv[p++]=c;
            c=getchar();
            }
            ungetc(c, stdin);
            tv[p]='\0';
            return NUM;
        }


      if ( isalpha(c)) { 
            while (isalpha(c)) 
            {
            tv[p++]=c;
            c=getchar(); 
            }
            ungetc(c, stdin);
            tv[p]='\0';
            return WORD;
        }

 	if(c == '\n') {
		lineno++;
	}
	return c;       



}

void yyerror (char const *s)
{
  printf ("yyerr: error (%s)\n", s);
}

int main(int ac, char **av)
{
  progname = av[0];
	yyparse();
	return 0;
}
