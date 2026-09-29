SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FRemoveAcentuacao] (@txt varchar(max)) RETURNS varchar(max) 
AS
BEGIN
 DECLARE @txt0 varchar(max) 
 --caixa baixa
    SET @txt0 = replace(@txt COLLATE Latin1_General_BIN, char(225),'a')  --SELECT 'á',ASCII('á'); --225
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(224),'a')  --SELECT 'à',ASCII('à'); --224   
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(227),'a')  --SELECT 'ã',ASCII('ã'); --227 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(226),'a')  --SELECT 'â',ASCII('â'); --226
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(233),'e')  --SELECT 'é',ASCII('é'); --233 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(232),'e')  --SELECT 'è',ASCII('è'); --232
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(234),'e')  --SELECT 'ê',ASCII('ê'); --234
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(237),'i')  --SELECT 'í',ASCII('í'); --237 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(236),'i')  --SELECT 'ì',ASCII('ì'); --236
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(238),'i')  --SELECT 'î',ASCII('î'); --238 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(243),'o')  --SELECT 'ó',ASCII('ó'); --243
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(242),'o')  --SELECT 'ò',ASCII('ò'); --242
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(244),'o')  --SELECT 'ô',ASCII('ô'); --244
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(245),'o')  --SELECT 'õ',ASCII('õ'); --245
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(250),'u')  --SELECT 'ú',ASCII('ú'); --250
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(249),'u')  --SELECT 'ù',ASCII('ù'); --249
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(251),'u')  --SELECT 'û',ASCII('û'); --251 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(252),'u')  --SELECT 'ü',ASCII('ü'); --252 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(231),'c')  --SELECT 'ç',ASCII('ç'); --231
 -- caixa alta
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(193),'A')  --SELECT 'Á',ASCII('Á'); --193
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(192),'A')  --SELECT 'À',ASCII('À'); --192  
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(194),'A')  --SELECT 'Â',ASCII('Â'); --194
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(195),'A')  --SELECT 'Ã',ASCII('Ã'); --195
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(201),'E')  --SELECT 'É',ASCII('É'); --201
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(200),'E')  --SELECT 'È',ASCII('È'); --200
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(202),'E')  --SELECT 'Ê',ASCII('Ê'); --202
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(205),'I')  --SELECT 'Í',ASCII('Í'); --205
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(204),'I')  --SELECT 'Ì',ASCII('Ì'); --204
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(206),'I')  --SELECT 'Î',ASCII('Î'); --206
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(211),'O')  --SELECT 'Ó',ASCII('Ó'); --211
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(210),'O')  --SELECT 'Ò',ASCII('Ò'); --210
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(212),'O')  --SELECT 'Ô',ASCII('Ô'); --212
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(213),'O')  --SELECT 'Õ',ASCII('Õ'); --213
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(218),'U')  --SELECT 'Ú',ASCII('Ú'); --218
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(217),'U')  --SELECT 'Ù',ASCII('Ù'); --217
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(219),'U')  --SELECT 'Û',ASCII('Û'); --219 
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(220),'U')  --SELECT 'Ü',ASCII('Ü'); --220
    SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(199),'C')  --SELECT 'Ç',ASCII('Ç'); --199
      
 RETURN (@txt0)
END
GO
