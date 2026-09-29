SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FRemoveSpecial_chars]  
(
	@stexto varchar(max)
)
RETURNS varchar(max)
AS 
BEGIN
 IF @stexto IS NULL BEGIN  
     RETURN NULL 
 END 
 -- Tabela ASCII
 -- Caracteres não imprimiveis, 33 ao total, menos o NUL fica 32 
 --  hex d abr ctl descricao  
 --  00  0 NUL ^@ Null - Nulo desativado, pois o nulo no postgres funciona em forma de cascata      
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(1),''))  --  01  1 SOH ^A Start of Header - Início do cabeçalho
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(2),''))  --  02  2 STX ^B Start of Text - Início do texto
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(3),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(4),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(5),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(6),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(7),''))  --  07  7 BEL ^G Bell - Campainha
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(8),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(9),''))  --  09  9 HT  ^I  Horizontal Tabulation - Tabulação horizontal
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(10),'')) --  0A 10 LF  ^J Line-Feed - Alimenta linha
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(11),'')) --  0B 11 VT  ^K  Vertical Tabulation - Tabulação vertical
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(12),'')) --  0C 12 FF  ^L Form-Feed - Alimenta formulário
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(13),'')) --  13 19 DC3 ^S Device-Control 3
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(14),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(15),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(16),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(17),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(18),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(19),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(20),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(21),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(22),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(23),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(24),'')) -- 18 24 CAN ^X Cancel
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(25),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(26),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(27),'')) -- 1B 27 ESC ^[ Escape
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(28),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(29),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(30),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(31),''))
 SET @stexto = (SELECT REPLACE(@stexto, CHAR(127),'')) -- 7F127 DEL ^?  Delete     

 RETURN @stexto     
END





GO
