SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--UoM do Pedido
--Select distinct UoM from pedido_det where UoM is not null order by UoM
CREATE procedure [dbo].[spATL_UoM_Sel](
	@UoM			varchar(50),
	@Nome_Tp_UoM	varchar(30),
	@Tipo			char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select distinct UoM from pedido_det where UoM is not null order by UoM
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		--Select distinct UoM from pedido_det 
		--where UoM = @UoM and UoM is not null
		Select UoM from pedido_det
			where UoM = @UoM 
		group by UoM
	End	
	
--if @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		Select ID_Tipo [Code], Nome_Tp_LI [Type of LI] from Tipo_LI
--		where Nome_Tp_LI = @Nome_Tp_LI
--	End
	
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		Select ID_Tipo [Code], Nome_Tp_LI [Type of LI] from Tipo_LI
--		where Nome_Tp_LI = @Nome_Tp_LI and ID_Tipo <> @ID_Tipo
--	End

GO
