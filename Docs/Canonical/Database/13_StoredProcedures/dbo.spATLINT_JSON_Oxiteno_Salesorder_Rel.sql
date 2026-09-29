SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATLINT_JSON_Oxiteno_Salesorder_Rel]''
Create procedure [dbo].[spATLINT_JSON_Oxiteno_Salesorder_Rel]--''
(
	@Tipo				varchar(25)
)
as

select distinct local_origem [Origin],'26' [Type In Out], 'Portos Oxiteno' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_Salesorder where local_origem not in 
(select cd_org from atlantis.dbo.de_para where cd_tipo = 26 and Ativo = 1)
union ALL
select distinct local_destino [Origin],'26' [Type In Out], 'Portos Oxiteno' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_Salesorder where local_destino not in 
(select cd_org from atlantis.dbo.de_para where cd_tipo = 26 and Ativo = 1)
union ALL
select distinct modal [Origin],'24' [Type In Out], 'Modal' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_Salesorder where modal not in 
(select cd_org from atlantis.dbo.de_para where cd_tipo = 24 and Ativo = 1)
union all
select distinct unid_medida [Origin],'25' [Type In Out], 'unid_medida' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_Salesorder_line where unid_medida  not in 
(select Cd_Org from de_para where cd_tipo = 25 and Ativo = 1)
union all
select distinct tipo_carga [Origin],'27' [Type In Out], 'tipo_carga' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_Salesorder where tipo_carga  not in 
(select Cd_Org from de_para where cd_tipo = 27 and Ativo = 1)



GO
