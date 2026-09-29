SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Cia_Aerea
CREATE procedure [dbo].[spATL_Cia_Aerea_InsUpd] 
(
	@Cd_Cia_Aer		varchar(3),
	@Nome_Cia_Aer	varchar(30),
	@SCAC			varchar(4),
	@IATA_CODE		varchar(25),
	@Prefix			varchar(10),
	@EfreightDescartes bit
)
   
AS
	
	if not exists (select Cd_Cia_Aer from Cia_Aerea where Cd_Cia_Aer = @Cd_Cia_Aer)
		Begin			
			Insert into	Cia_Aerea
				(Cd_Cia_Aer,Nome_Cia_Aer,SCAC,dt_criacao,IATA_CODE,Prefix,EfreightDescartes)
			values
				(@Cd_Cia_Aer,@Nome_Cia_Aer,	@SCAC,GETDATE(),@IATA_CODE,@Prefix,@EfreightDescartes)
		End
	Else
	    Begin		
			Update
				Cia_Aerea
			Set				        
				Cd_Cia_Aer =  @Cd_Cia_Aer,
				Nome_Cia_Aer =  @Nome_Cia_Aer,
				SCAC =  @SCAC,
				dt_criacao =  GETDATE(),
				IATA_CODE =  @IATA_CODE,
				Prefix = @Prefix,
				EfreightDescartes= @EfreightDescartes
			Where
				Cd_Cia_Aer = @Cd_Cia_Aer
				
		End

GO
