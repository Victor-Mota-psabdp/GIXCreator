SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Range_CP
CREATE PROCEDURE [dbo].[spATL_Tipo_Range_CP_InsUpd]
(
	@Cd_Range		char(1),
	@Range_Descricao	varchar(100),
	@Modal			char(1)
)
				

AS

Begin Transaction

	If  exists (select Cd_Range from Tipo_Range_CP where Cd_Range=@Cd_Range)
		Begin
			Update
				Tipo_Range_CP
			Set
				Range_Descricao=@Range_Descricao,
				Modal = @Modal
			Where
				Cd_Range=@Cd_Range
		End
	Else
		Begin
			Insert Tipo_Range_CP
				(Cd_Range,Range_Descricao,Modal)
			Values
				(@Cd_Range,@Range_Descricao,@Modal)
		End

Commit Transaction

GO
