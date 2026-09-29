SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table [dbo].[Tipo_NF_Doc_Register] add [CNAE] [varchar](25) NULL

CREATE Procedure [dbo].[spTipo_NF_Doc_Register_Sel] 
	@cd_site Char(1)
as	

IF @cd_site = ''
	set @cd_site = '%'

SELECT 
	S.Cd_Site + ' - ' + S.Nome_Site Site, cd_servico,item_lei,Descricao,CNAE,Desativada
FROM 
	Tipo_NF_Doc_Register T
	join Site S on S.Cd_Site = T.cd_site 
WHERE 
	T.cd_site like @cd_site
	

GO
