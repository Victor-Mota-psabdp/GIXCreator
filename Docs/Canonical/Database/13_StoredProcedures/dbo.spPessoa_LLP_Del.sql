SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_HELP Pessoa_LLP
CREATE procedure [dbo].[spPessoa_LLP_Del] 
(
	@Cd_Pes			varchar(10)
	
)
AS

Begin Transaction 	
		
	IF exists(select Cd_Pes from Pessoa_LLP where Cd_Pes = @cd_pes)
	   BEGIN
			Delete Pessoa_LLP  where Cd_Pes = @cd_pes				
	   END
	
Commit Transaction 







GO
