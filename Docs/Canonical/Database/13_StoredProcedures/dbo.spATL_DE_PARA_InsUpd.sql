SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help DE_PARA
CREATE procedure [dbo].[spATL_DE_PARA_InsUpd] 
(
	@Cd_Cliente		varchar(10),
	@Cd_Tipo		INT,
	@Cd_Org			varchar(2000),
	@Cd_Dst			varchar(2000),
	@Descr_Org		varchar(50),
	@Dt_Ins			varchar(50),
	@Ativo			bit,
	@Cd_Usuario		varchar(10)
)
   
AS
	
	if not exists (select Cd_Cliente from DE_PARA where Cd_Cliente = @Cd_Cliente
		AND Cd_Tipo = @Cd_Tipo AND Cd_Org = @Cd_Org)
		Begin			
			Insert into	DE_PARA
				(Cd_Cliente,Cd_Tipo,Cd_Org,Cd_Dst,Descr_Org,Dt_Ins,Ativo,Cd_Usuario)
			values
				(@Cd_Cliente,@Cd_Tipo,@Cd_Org,@Cd_Dst,@Descr_Org,GETDATE(),@Ativo,@Cd_Usuario)
		End
	Else
	    Begin		
			Update
				DE_PARA
			Set	
				Cd_Dst=@Cd_Dst,
				Descr_Org = @Descr_Org,
				Dt_Ins = GETDATE(),
				Ativo = @Ativo,
				Cd_Usuario = @Cd_Usuario
			Where
				Cd_Cliente = @Cd_Cliente AND Cd_Tipo = @Cd_Tipo AND Cd_Org = @Cd_Org
				
		End

GO
