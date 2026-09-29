SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spTipo_taxaXTipo_NF_Doc_Register_InsUpd]--'BRO','I','5250801','33.01','5250801','Comissaria de despacho alíquota iss 3%'

	@cd_tp_tx		varchar(3),
	@cd_site		char(1),
	@cd_servico		int,
	@Item_lei		varchar(50),
	@CNAE			varchar(50),
	@Descricao		varchar(500)

AS

Begin Transaction

--Declare @ID_Tipo_NF  as BigInt
--set @ID_Tipo_NF = (Select ID_Tipo_NF from Tipo_NF_Doc_Register where
--					cd_servico =@cd_servico and Item_lei=@Item_lei and	cd_site = @cd_site and cnae = @CNAE )
	
	IF  exists(Select cd_site from Tipo_taxaXTipo_NF_Doc_Register with(nolock) where cd_tp_tx = @cd_tp_tx and cd_site = @cd_site)
		BEGIN
			UPDATE
				Tipo_taxaXTipo_NF_Doc_Register 
			SET			
				Descricao = @Descricao,
				cd_servico = @cd_servico,
				Item_lei = @Item_lei,
				CNAE = @CNAE			
			WHERE
				cd_tp_tx = @cd_tp_tx and cd_site = @cd_site
		END
	ELSE
		
			INSERT into Tipo_taxaXTipo_NF_Doc_Register
				(cd_tp_tx,Descricao,cd_site,cd_servico,Item_lei,CNAE)
			Values 
				(@cd_tp_tx, @Descricao,@cd_site,@cd_servico,@Item_lei,@CNAE)
		 

Commit Transaction


GO
