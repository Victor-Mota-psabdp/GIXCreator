SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_Aduanas_ARG_InsUpd]
(
	@CodAduana char(3),
	@Nome_Aduana varchar(30)
)

AS

Begin Transaction

	If  exists (select CodAduana from Aduanas_ARG where CodAduana=@CodAduana)
		Begin
			Update
				Aduanas_ARG
			Set
				Nome_Aduana=@Nome_Aduana
			Where
				CodAduana=@CodAduana
		End
	Else
		Insert
			Aduanas_ARG(CodAduana,Nome_Aduana)
		Values
			(@CodAduana,@Nome_Aduana)
	

Commit Transaction





GO
