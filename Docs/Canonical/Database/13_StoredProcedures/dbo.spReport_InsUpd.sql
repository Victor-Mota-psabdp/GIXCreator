SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[spReport_InsUpd]
(
	@ID	int,
	@Report_Name varchar(100),
	@Stored	varchar(250),
	@Regra	varchar(250),
	@Tipo	char(1),
	@Ativo	char(1)
)

AS

Begin Transaction

	If @ID <> ''
		Begin
			update
				Report
			set
				Report_Name = @Report_Name,
				Stored = @Stored,
				Ativo = @Ativo,
				Regra = @Regra,
				Tipo = @Tipo
			where
				ID = @ID
		End
	Else
		Begin
			Insert Report
				(Report_Name,Stored,Ativo,Regra,Tipo)
			Values
				(@Report_Name,@Stored,@Ativo,@Regra,@Tipo)
		End

Commit Transaction






GO
