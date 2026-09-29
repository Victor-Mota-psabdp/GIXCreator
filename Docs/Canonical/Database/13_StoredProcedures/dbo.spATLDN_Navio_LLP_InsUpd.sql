SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Navio_LLP
CREATE procedure [dbo].[spATLDN_Navio_LLP_InsUpd] 
(
	@Id_Navio			Int,
	@Nome_Navio			varchar(50),
	@Cd_Nacionalidade	varchar(2),
	@LLoyd				varchar(8),
	@cd_pais			varchar(2),
	@cd_armador			varchar(3),
	@cd_usuario			varchar(10)
)
   
AS

Begin Transaction 

	Declare @Tipo char(1)	
	if not exists (select Id_Navio from Navio_LLP where Id_Navio = @Id_Navio)
		Begin
			Set @Id_Navio=(select isnull(max(id_navio),0)+1 from NAVIO_LLP)			
			Insert into	Navio_LLP
				(Id_Navio,Nome_Navio,Cd_Nacionalidade,LLoyd,cd_pais,cd_armador)
				--,cd_usuario)
			values
				(@Id_Navio,@Nome_Navio,	@Cd_Nacionalidade,@LLoyd,@cd_pais,@cd_armador)
				--,@cd_usuario)				
			Set @Tipo = 'I'
		End
	Else
	    Begin		
			Update
				Navio_LLP
			Set				        
				Nome_Navio =  @Nome_Navio,
				Cd_Nacionalidade =  @Cd_Nacionalidade,
				LLoyd =  @LLoyd,
				cd_pais =  @cd_pais,
				cd_armador =  @cd_armador
				--,				cd_usuario = @cd_usuario
			Where
				Id_Navio = @Id_Navio
			Set @Tipo = 'A'
		End
		
		--LOG		
		BEGIN							
			insert into [dbo].[Log_Navio_LLP]
				(Dt_Ins,Cd_Usuario,Tp_Oper,Id_Navio,Nome_Navio,Cd_Nacionalidade,LLoyd,cd_pais,cd_armador)
			Values
				(getdate(),@cd_usuario,@Tipo,@Id_Navio,@Nome_Navio,NULL,@LLoyd,@Cd_Pais,@cd_armador)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

Commit Transaction 
GO
