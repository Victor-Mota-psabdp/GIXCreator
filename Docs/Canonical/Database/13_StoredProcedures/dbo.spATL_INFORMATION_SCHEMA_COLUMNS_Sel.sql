SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[spATL_INFORMATION_SCHEMA_COLUMNS_Sel]--'','','B'
(	
	@Table_Name		VarChar(200),
	@Column_Name	VarChar(200),
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

IF @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT Table_Name,Column_name FROM INFORMATION_SCHEMA.COLUMNS 
		where TABLE_NAME = @Table_Name
		order by table_name
	End
	
IF @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT Table_Name,Column_name  FROM INFORMATION_SCHEMA.COLUMNS 
		where TABLE_NAME = @Table_Name and Column_name =@Column_Name
		order by table_name
	End
	














GO
