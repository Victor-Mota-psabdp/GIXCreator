SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Pessoa_ATL_AX
CREATE procedure [dbo].[spATL_Pessoa_ATL_AX_Del] 
(
	@cd_pes				 varchar(10),
	@cd_ax				Int,
	@Type				char(1)	
)
AS

Begin Transaction 
	
		
	if not exists(select Cd_Pes from Pessoa_ATL_AX where cd_pes=@cd_pes and cd_ax=@cd_ax and Tipo = @Type)
		BEGIN
			DELETE	Pessoa_ATL_AX	Where
				cd_pes=@cd_pes and cd_ax=@cd_ax and Tipo = @Type 
		End   	

Commit Transaction 
	
















GO
