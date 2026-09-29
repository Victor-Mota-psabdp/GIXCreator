SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spATLDNNCM_Sel](
	--@Id_NCM int,
	@NCM varchar(20),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes - Order
D, /// Busca pelo Codigo - Ativos - Order
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select Id_NCM [Code],NCM,Descricao_NCM[NCM Description] from NCM with(nolock)
	End

--if @Tipo = 'C' or @Tipo = 'D'
--	Begin
--		select Id_NCM [Code],NCM,Descricao_NCM[NCM Description] from NCM with(nolock)
--		where Id_NCM = @Id_NCM
--	End	
	
--if @Tipo = 'N' or @Tipo = 'O'
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Id_NCM [Code],NCM,Descricao_NCM[NCM Description] from NCM with(nolock)
		where NCM = @NCM
	End

GO
