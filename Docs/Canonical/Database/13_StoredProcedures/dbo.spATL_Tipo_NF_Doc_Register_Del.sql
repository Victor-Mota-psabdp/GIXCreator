SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_NF_Doc_Register
CREATE procedure [dbo].[spATL_Tipo_NF_Doc_Register_Del]
(
	@Cd_Site		char(1),
	@Cd_Servico		varchar(10),
	@Item_lei		varchar(50),
	@CNAE			varchar(25)
)
as
	
	
	BEGIN TRANSACTION
		IF EXISTS(SELECT cd_servico FROM Tipo_NF_Doc_Register WHERE cd_servico=@cd_servico)
			update 
				Tipo_NF_Doc_Register 
			set 
				Desativada = 'S'
			WHERE 
				cd_servico=@cd_servico
	

	COMMIT TRANSACTION

GO
