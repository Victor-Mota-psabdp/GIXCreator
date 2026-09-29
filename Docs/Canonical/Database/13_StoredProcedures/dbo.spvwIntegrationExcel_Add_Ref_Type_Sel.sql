SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from vwIntegrationExcel_Add_Ref_Type_Sel
CREATE procedure [dbo].[spvwIntegrationExcel_Add_Ref_Type_Sel]--'','','B'
(		
	@Tabela_Relacionada		VarChar(30),
	@Type					VarChar(20),
	@Tipo					char(1)
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
		select code, tipo, [Tabela Relacionada] as Tabela_Relacionada from vwIntegrationExcel_Add_Ref_Type_Sel
	End
	
IF @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select code, tipo, [Tabela Relacionada] as Tabela_Relacionada from vwIntegrationExcel_Add_Ref_Type_Sel
		WHERE [Tabela Relacionada] = @Tabela_Relacionada
	End
	
IF @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select code, tipo, [Tabela Relacionada] as Tabela_Relacionada from vwIntegrationExcel_Add_Ref_Type_Sel
		
		WHERE tipo = @Type
	End













GO
