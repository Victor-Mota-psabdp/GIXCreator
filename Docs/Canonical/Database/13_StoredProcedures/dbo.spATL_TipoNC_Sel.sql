SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TipoNC_Sel]
(
	@Cd_NC varchar(40),
	@Descricao_NC as Varchar(150),
	@Tipo as char
)
as
if @Tipo = 'A'
	Begin
		if @Cd_NC = '' or @Cd_NC is null
		Begin
			select Cd_NC, Descricao_NC from Tipo_NC_Cliente
			where Descricao_NC = @Descricao_NC
		End
		else
		Begin			
			select Cd_NC, Descricao_NC from Tipo_NC_Cliente
			where  Cd_NC = @Cd_NC
		End
	End
if @Tipo = 'B'
	Begin
		if @Cd_NC = '' or @Cd_NC is null
		Begin
			select Cd_NC, Descricao_NC from Tipo_NC_Cliente
			where Descricao_NC = @Descricao_NC and Ativo = 'S'
		End
		else
		Begin			
			select Cd_NC, Descricao_NC from Tipo_NC_Cliente
			where  Cd_NC = @Cd_NC and Ativo = 'S'
		End
	End
GO
