SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Canal_InsUpd]
(
	@Id Int,
	@Canal varchar(10)
)
AS

Begin Transaction

	if not exists (select Id from Canal where Id=@Id)
		Begin
			Set @Id =(Select Isnull(max(Id),0) + 1 from Canal)
			Insert
				Canal(Id,Canal)
			Values
				(@Id,@Canal)
		End
	Else
	    Begin		
			Update
				Canal
			Set
				Canal=@Canal
			Where
				Id=@Id		
			End

	
Commit Transaction





GO
