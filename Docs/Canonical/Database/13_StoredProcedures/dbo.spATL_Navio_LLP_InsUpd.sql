SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Navio_LLP_InsUpd]

	@Codigo			int,
	@Nome_Navio		varchar(25),
	@Nome_Pais		varchar(50),
	@LLoyd			varchar(8),
	@Nome_Armador	varchar(30),
	@cd_usuario		varchar(6),
	@NCodigo		int output
AS

Declare @cod int
Declare @cd_pais as varchar(3)
Declare @cd_armador as varchar(3)

Declare @Tipo char(1)

set @cd_pais = (select cd_pais from Pais where Nome_Pais =@Nome_Pais)
set @cd_armador = (select cd_armador from Armador where Nome_Armador =@Nome_Armador)

set @Codigo = (select id_navio from NAVIO_LLP where Nome_Navio = @Nome_Navio)

Begin Transaction 
	IF @codigo is null 
	   BEGIN	
			Set @cod=(select isnull(max(id_navio),0)+1 from NAVIO_LLP)
			Set @Tipo = 'I'
			Insert 
				NAVIO_LLP (id_navio,nome_navio,Cd_Nacionalidade,LLoyd,Cd_Pais,Cd_armador)
			Values
				(@cod,@Nome_Navio,NULL,@LLoyd,@Cd_Pais,@cd_armador)
				Set @NCodigo = @cod			
	   END
	ELSE
	   BEGIN
		if exists(select id_navio from NAVIO_LLP where id_navio=@codigo)
			Begin
				Update 
					NAVIO_LLP
				Set 
					nome_navio=@Nome_Navio,
					cd_pais=@cd_pais,
					lloyd=@lloyd,
					Cd_armador = @cd_armador
				Where
					id_navio=@codigo
					Set @NCodigo = @codigo
					Set @Tipo = 'A'
	   		End
		END
		
		
		--LOG		
		BEGIN							
			insert into [dbo].[Log_Navio_LLP]
				(Dt_Ins,Cd_Usuario,Tp_Oper,Id_Navio,Nome_Navio,Cd_Nacionalidade,LLoyd,cd_pais,cd_armador)
			Values
				(getdate(),@cd_usuario,@Tipo,@NCodigo,@Nome_Navio,NULL,@LLoyd,@Cd_Pais,@cd_armador)
		END
		
		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 


	








GO
