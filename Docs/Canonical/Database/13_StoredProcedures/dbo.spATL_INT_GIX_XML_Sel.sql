SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spATL_INT_GIX_XML_Sel]
(
	@ID_Smart		bigint,
	@ID_Req			bigint,
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
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select ID_Smart,ID_Req,Num_Proc,XML_DOC,Nome_Arquivo,Dt_Ins from ATL_INT.DBO.GIX_XML with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select ID_Smart,ID_Req,Num_Proc,XML_DOC,Nome_Arquivo,Dt_Ins from ATL_INT.DBO.GIX_XML with(nolock)
		where ID_Smart = @ID_Smart
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select ID_Smart,ID_Req,Num_Proc,XML_DOC,Nome_Arquivo,Dt_Ins from ATL_INT.DBO.GIX_XML with(nolock)
		where ID_Req = @ID_Req
	End
	

	
GO
