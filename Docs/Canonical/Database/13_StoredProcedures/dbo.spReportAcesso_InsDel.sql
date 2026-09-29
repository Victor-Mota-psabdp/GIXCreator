SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spReportAcesso_InsDel]
(
	@Tipo char(1), --	I = Insert ,  D = Delete
	@ID_Report int,
	@Nome_Usuario varchar(50)
)
AS

Begin Transaction

	declare @cd_usuario varchar(20)
	set @cd_usuario = (select top 1 cd_usuario from usuario where nome_usuario = @Nome_Usuario)

	IF @Tipo = 'I' 
		Begin
			if @cd_usuario = 'ATL'
				begin
					DELETE Report_Acesso where ID_Report = @ID_Report
				end

			If NOT exists(select * from report_acesso where ID_Report = @ID_Report and cd_usuario = @cd_usuario)
				Begin
					Insert into Report_Acesso(ID_Report,cd_usuario)
					Values(@ID_Report, @cd_usuario)
				End
		End

	IF @Tipo = 'D'
		Begin
			DELETE Report_Acesso
			where ID_Report = @ID_Report and cd_usuario = @cd_usuario
		End



Commit Transaction


GO
