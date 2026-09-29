SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create  procedure [dbo].[spReportDetalhe_InsUpd]
(
	@ID	int,
	@strSQLDetalhe varchar(max),
	@Parametro	varchar(20)
)

AS

Begin Transaction

	If exists (select * from report_detalhe where id_report = @ID)
		Begin
			update
				Report_Detalhe
			set
				strSQLDetalhe = @strSQLDetalhe, Parametro = @Parametro
			where
				ID_report = @ID
		End
	Else
		Begin
			Insert Report_detalhe
				(ID_Report, strSQLDetalhe, Parametro)
			Values
				(@ID, @strSQLDetalhe, @Parametro)
		End

Commit Transaction






GO
