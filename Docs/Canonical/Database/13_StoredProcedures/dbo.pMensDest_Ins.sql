SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pMensDest_Ins  
(
@MnsID		int, 
@Usuario		varchar(30)

)
AS
	Declare @Cd_Usuario VarChar(6) 
	Set @Cd_Usuario = (Select Cd_Usuario From Usuario Where Nome_Usuario = @Usuario)

	Insert Into Mens_Dest (MnsID, Cd_Usuario ) Values (@MnsID, @Cd_Usuario )

	Return @@RowCount

GO
