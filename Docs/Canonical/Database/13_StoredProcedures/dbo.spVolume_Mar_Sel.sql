SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help vwVolume_Mar
create procedure [dbo].[spVolume_Mar_Sel](
	@Num_proc	varChar(16),	
	@Item	varChar(2),
	@Tipo char(1)
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

if @Tipo = 'A'  or @Tipo = 'B'
	Begin
		select 
			Num_Proc,Item,Qtd_Vol,Compr,Largura,Altura,Cd_Tp_Unidade,Vol_Item,Id_NCM,NCM,Peso_Bruto,Cd_Tp_Embal,
			Nome_Tp_Embal,Marca,Contra_Marca,Item_Cont,Num_Cont
		from 
			vwVolume_Mar TT with(nolock)			
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			Num_Proc,Item,Qtd_Vol,Compr,Largura,Altura,Cd_Tp_Unidade,Vol_Item,Id_NCM,NCM,Peso_Bruto,Cd_Tp_Embal,
			Nome_Tp_Embal,Marca,Contra_Marca,Item_Cont,Num_Cont
		from 
			vwVolume_Mar TT with(nolock)			
		where
			num_proc = @Num_proc
	End
	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			Num_Proc,Item,Qtd_Vol,Compr,Largura,Altura,Cd_Tp_Unidade,Vol_Item,Id_NCM,NCM,Peso_Bruto,Cd_Tp_Embal,
			Nome_Tp_Embal,Marca,Contra_Marca,Item_Cont,Num_Cont
		from 
			vwVolume_Mar TT with(nolock)			
		where
			num_proc = @Num_proc AND Item = @Item
	End
	

	

	
GO
