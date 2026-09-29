SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_Pessoa_LLP_InsUpd '12021','','1','Grupo Dow','','','',''
CREATE procedure [dbo].[spATL_Pessoa_LLP_InsUpd] 

	@cd_pes varchar(10),
	@Cd_Planta varchar(20),
	@Cd_Pes_Grupo varchar(10),
	@Pes_Grupo varchar(20),
	@Cd_Vendor varchar(20),
	@Planta_Nome varchar(50),
	@RGLNumber varchar(10),
	@InvoiceGRP varchar(1)
AS

Begin Transaction 
	if @Pes_Grupo <> ''
		Set @Cd_Pes_Grupo = (select Cd_Pes from Pessoa With(nolock) where Apelido = @Pes_Grupo)
	else if @Cd_Pes_Grupo = ''
		Set @Cd_Pes_Grupo = NULL
		
	
		
	IF  not exists(select Cd_Pes from Pessoa_LLP where Cd_Pes = @cd_pes)

	   BEGIN
			Insert 
				pessoa_llp
					(
						Cd_Pes,
						Cd_Planta,
						Cd_Pes_Grupo,
						Cd_Vendor,
						Planta_Nome,
						RGLNumber,
						InvoiceGRP
					)
			Values
					(
						@Cd_Pes,
						@Cd_Planta,
						@Cd_Pes_Grupo,
						@Cd_Vendor,
						@Planta_Nome,
						@RGLNumber,
						@InvoiceGRP
					)
	   END
	ELSE
		Begin
			Update 
					pessoa_LLP
				Set 
						Cd_Planta = @Cd_Planta,
						Cd_Pes_Grupo = @Cd_Pes_Grupo,
						Cd_Vendor = @Cd_Vendor,
						Planta_Nome = @Planta_Nome,
						RGLNumber = @RGLNumber,
						InvoiceGRP = @InvoiceGRP
				Where
					cd_pes=@cd_pes
	   	End
	   	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction 
	
















GO
