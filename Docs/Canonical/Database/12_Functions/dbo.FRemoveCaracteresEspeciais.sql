SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FRemoveCaracteresEspeciais] (@txt varchar(max)) RETURNS varchar(max) 
AS
BEGIN
 IF @txt IS NULL BEGIN 
     RETURN NULL
 END
 DECLARE @txt0 varchar(max) 
 --caixa baixa
    SET @txt0 = replace(@txt COLLATE Latin1_General_BIN, char(64),'')  --SELECT '@',ASCII('@')); --64
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(35),'')  --SELECT '#',ASCII('#'); --35  
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(36),'')  --SELECT '$',ASCII('$'); --36 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(37),'')  --SELECT '$',ASCII('$'); --37
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(168),'')  --SELECT '¨',ASCII('¨'); --168 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(38),'')  --SELECT '&',ASCII('&'); --38
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(42),'')  --SELECT '*',ASCII('*'); --42
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(40),'')  --SELECT '(',ASCII('('); --40
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(41),'')  --SELECT ')',ASCII(')'); --41
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(123),'')  --SELECT '{',ASCII('{'); --123 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(125),'')  --SELECT '}',ASCII('}'); --125
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(91),'')  --SELECT '[',ASCII('['); --91
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(93),'')  --SELECT ']',ASCII(']'); --93
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(94),'')  --SELECT '^',ASCII('^'); --94
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(126),'')  --SELECT '~',ASCII('~'); --126
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(60),'')  --SELECT '<',ASCII('<'); --60
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(62),'')  --SELECT '>',ASCII('>'); --62 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(63),'')  --SELECT '?',ASCII('?'); --63 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(59),'')  --SELECT ';',ASCII(';'); --59
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(47),'')  --SELECT '/',ASCII('/'); --47
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(176),'')  --SELECT '°',ASCII('°'); --176  
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(92),'')  --SELECT '\',ASCII('\'); --92
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(124),'')  --SELECT '|',ASCII('|'); --124
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(170),'')  --SELECT 'ª',ASCII('ª'); --170
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(33),'')  --SELECT '!',ASCII('!'); --33

    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(39),'')  --SELECT '''',ASCII(''''); --39

    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(34),'')  --SELECT '"',ASCII('"'); --34
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(185),'')  --SELECT '¹',ASCII('¹'); --185
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(178),'')  --SELECT '²',ASCII('²'); --178
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(179),'')  --SELECT '³',ASCII('³'); --179
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(163),'')  --SELECT '£',ASCII('£'); --163
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(162),'')  --SELECT '¢',ASCII('¢'); --162
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(172),'')  --SELECT '¬',ASCII('¬'); --172
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(45),'')  --SELECT '-',ASCII('-'); --45
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(95),'')  --SELECT '_',ASCII('_'); --95
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(61),'')  --SELECT '=',ASCII('='); --61 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(43),'')  --SELECT '+',ASCII('+'); -43
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(167),'')  --SELECT '§',ASCII('§'); --167

	SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(13)+ char(10),'')  --enter

	SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(9),'') --caracter especial q vem com o AX
	SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(10),'')
	SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(150),'') --caracter especial SF
	SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(160),'')
	
 RETURN (@txt0)
END

GO
