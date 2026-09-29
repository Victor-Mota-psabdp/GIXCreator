SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Envio_GIX
CREATE procedure [dbo].[spATL_Tipo_Envio_GIX_Sel]
(
	@Cd_Tp_EnvioGix				VARCHAR(1),
	@Nome_Tp_EnvioGix			varchar(50),	
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Statuss
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Statuss
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Statuss
*/

if @Tipo = 'A'   OR @Tipo = 'B'
	Begin
		select 
			Cd_Tp_EnvioGix [Code], Nome_Tp_EnvioGix [Gix Send Type Name]
		from 
			Tipo_Envio_GIX T with(nolock)
	End
	
	
if @Tipo = 'C' OR @Tipo = 'D'
	Begin
		select 
			Cd_Tp_EnvioGix [Code], Nome_Tp_EnvioGix [Gix Send Type Name]
		from 
			Tipo_Envio_GIX T with(nolock)
		where
			Cd_Tp_EnvioGix = @Cd_Tp_EnvioGix
			
	End
	
if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			Cd_Tp_EnvioGix [Code], Nome_Tp_EnvioGix [Gix Send Type Name]
		from 
			Tipo_Envio_GIX T with(nolock)
		where
			Nome_Tp_EnvioGix = @Nome_Tp_EnvioGix
	End	
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_EnvioGix [Code], Nome_Tp_EnvioGix [Gix Send Type Name]
		from 
			Tipo_Envio_GIX T with(nolock)
		where
			Nome_Tp_EnvioGix = @Nome_Tp_EnvioGix
			AND Cd_Tp_EnvioGix <> @Cd_Tp_EnvioGix
	End

GO
