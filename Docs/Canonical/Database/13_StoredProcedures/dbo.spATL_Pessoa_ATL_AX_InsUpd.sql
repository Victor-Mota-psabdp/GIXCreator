SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Pessoa_ATL_AX
CREATE procedure [dbo].[spATL_Pessoa_ATL_AX_InsUpd] 
(
	@cd_pes				 varchar(10),
	@cd_ax				Int,
	@Type				char(1),
	@CNPJ				varchar(20),
	@Sales_Tax_Group	varchar(20)	
)
AS

Begin Transaction 
	
		
	if not exists(select Cd_Pes from Pessoa_ATL_AX where cd_pes=@cd_pes and cd_ax=@cd_ax and Tipo = @Type)
		BEGIN
			Insert Pessoa_ATL_AX
			(
				Cd_Pes,cd_ax,CNPJ,Sales_Tax_Group,Tipo
			)
			Values
			(
				@Cd_Pes,@cd_ax,@CNPJ,@Sales_Tax_Group,@Type
			)
		END
	ELSE
		Begin
			Update 
				Pessoa_ATL_AX
			Set 
				--cd_ax = @cd_ax,
				CNPJ = @CNPJ,
				Sales_Tax_Group = @Sales_Tax_Group
				--Tipo = @Type				
			Where
				cd_pes=@cd_pes and cd_ax=@cd_ax and Tipo = @Type 
		End
	   	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction 
	
















GO
