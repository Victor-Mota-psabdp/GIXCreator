SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Localidade_InsUpd]
( 

		@Cd_Local		varchar(3),
		@Nome_Local		varchar(30),
		@Cidade_Local	varchar(25),
		@Cd_Pais		varchar(2),
		@Pais_Local		varchar(50),
		@Cd_Regiao		varchar(3),
		@Aerop			char(1),
		@Porto			char(1),
		@Gate			char(1),
		@BITRI			varchar(6),
		@IATACODE		varchar(3),
		@SCAC			varchar(6),
		@Desat_loc		char(1)
)	

   
AS
	
	if not exists (select Cd_Local from Localidade where Cd_Local = @Cd_Local)
		Begin			
			Insert into
				Localidade
				(Cd_Local,Nome_Local,Cidade_Local,Pais_Local,Cd_Regiao,Aerop,Porto,Gate,
				BITRI,Cd_Pais,IATACODE,SCAC,Desat_loc,dt_criacao
				 )
			values
				(@Cd_Local,@Nome_Local,@Cidade_Local,@Pais_Local,@Cd_Regiao,@Aerop,@Porto,@Gate,
				@BITRI,@Cd_Pais,@IATACODE,@SCAC,@Desat_loc,getdate()
				)
		End
	Else
	    Begin		
			Update
				Localidade
			Set				        
				Cd_Local =  @Cd_Local,
				Nome_Local =  @Nome_Local,
				Cidade_Local =  @Cidade_Local,
				Pais_Local =  @Pais_Local,
				Cd_Regiao =  @Cd_Regiao,
				Aerop =  @Aerop,
				Porto =  @Porto,
				Gate =  @Gate,
				BITRI =  @BITRI,
				Cd_Pais =  @Cd_Pais,
				IATACODE =  @IATACODE,
				SCAC =  @SCAC,
				Desat_loc =  @Desat_loc,
				dt_criacao =  GETDATE()
			Where
				Cd_Local = @Cd_Local
				
		End

GO
