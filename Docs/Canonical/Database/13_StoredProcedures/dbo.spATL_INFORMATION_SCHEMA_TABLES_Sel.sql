SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE procedure [dbo].[spATL_INFORMATION_SCHEMA_TABLES_Sel]--vwArmador_HBL_EM'','A'
(	
	@table_name	 VarChar(200),
	@Tipo			char(1)
)
as
		
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos

X /// para ver se tem algum job com este campo preenchido
*/

IF @Tipo = 'A'  or @Tipo = 'B'
	Begin
		SELECT table_name FROM INFORMATION_SCHEMA.TABLES 
		order by table_name
	End	
	
IF @Tipo = 'C' or @Tipo = 'D' OR @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT table_name FROM INFORMATION_SCHEMA.TABLES 
		where table_name = @table_name
		order by table_name
	End













GO
