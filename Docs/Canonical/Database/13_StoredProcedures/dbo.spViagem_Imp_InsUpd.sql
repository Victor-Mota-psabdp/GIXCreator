SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spViagem_Imp_InsUpd]

	@Num_Proc			VarChar(16),
	@Item	 			int,	
	@Origem				varchar(50),
	@Destino			varchar(50),
	@Navio_LLP			varchar(50),
	@Viagem				VarChar(10),
	@ETA				Datetime,
	@ETD				Datetime,
	@ATA				Datetime,
	@ATD				Datetime,
	@cd_Usuario			varchar(10)

 AS

Begin Transaction

		Declare @Cd_Org 		Varchar(10)
		Declare @cd_dst 		VarChar(10)
		Declare @Cd_Navio_LLP	varchar(3)

		Set @cd_org=(select top 1 cd_local from localidade where Nome_Local=@Origem)
		Set @cd_dst=(select top 1 cd_local from localidade where Nome_Local=@Destino)
		Set @Cd_Navio_LLP=(Select cd_armador from navio_llp where Nome_Navio = @Navio_LLP)	


	IF exists (select Item from Viagem_Imp where Item = @Item and Num_Proc = @Num_Proc)
		Begin
			Update
				Viagem_Imp
			Set
				Cd_Org		= @Cd_Org,
				Cd_Dst		= @Cd_Dst,				
				ETA 		= @ETA,
				ETD			= @ETD,
				ATA			= @ATA,
				ATD			= @ATD,
				Cd_Armador	= @Cd_Navio_LLP,
				Viagem		= @Viagem,
				cd_usuario  = @cd_Usuario				
			Where
				Num_Proc = @Num_Proc and Item=@Item
		End
	ELSE
		Begin 
			Insert Into Viagem_Imp
				(Num_Proc,Item,Cd_Org,Cd_Dst,ETA,ETD,ATA,ATD,Cd_Armador,Viagem,cd_usuario)
			Values
				(@Num_Proc,@Item,@Cd_Org,@Cd_Dst,@ETA,@ETD,@ATA,@ATD,@Cd_Navio_LLP,@Viagem,@cd_usuario)
		End

		

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION	RETURN -1
			END

Commit Transaction 


GO
