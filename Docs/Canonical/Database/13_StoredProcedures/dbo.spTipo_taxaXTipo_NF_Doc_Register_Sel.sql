SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTipo_taxaXTipo_NF_Doc_Register_Sel]--'BRO' 
	@cd_tp_tx varchar(3)
as	

SELECT 
	cd_tp_tx Codigo, S.Cd_Site + ' - ' + S.Nome_Site Site, T.cd_servico,T.item_lei,T.CNAE, T.Descricao
FROM
	Tipo_taxaXTipo_NF_Doc_Register T 	
	join Site S on S.Cd_Site = T.cd_site 
WHERE 
	T.cd_tp_tx  = @cd_tp_tx

GO
