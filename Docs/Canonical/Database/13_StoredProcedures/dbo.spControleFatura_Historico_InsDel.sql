SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spControleFatura_Historico_InsDel]
(
	@Tipo char(1), --	I = Insert ,  D = Delete
	@cd_controlefatura varchar(12),	
	@disponivel bit,
	@Descricao_NC varchar(50)
)
AS

Begin Transaction

	declare @cd_nc varchar(5)
	set @cd_nc = (select top 1 cd_nc from tipo_nc_cliente where descricao_nc = @Descricao_NC)

	IF @Tipo = 'I' 
		Begin
			if NOT exists(select * from Controle_Fatura_Historico where cd_nc = @cd_nc and cd_controlefatura = @cd_controlefatura)
				Begin
					Insert into Controle_Fatura_Historico
					Values(@cd_controlefatura, @cd_nc,@disponivel)
				End
			else
				Update
					Controle_Fatura_Historico
				Set
					disponivel = @disponivel					
				Where
					cd_nc = @cd_nc  and cd_controlefatura = @cd_controlefatura
		End

	IF @Tipo = 'D'
		Begin
			DELETE Controle_Fatura_Historico
			where cd_nc = @cd_nc  and cd_controlefatura = @cd_controlefatura
		End



Commit Transaction


GO
