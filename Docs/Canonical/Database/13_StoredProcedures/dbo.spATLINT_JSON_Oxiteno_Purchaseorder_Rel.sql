SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--[spATLINT_JSON_Oxiteno_Purchaseorder_Rel]''
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_Purchaseorder_Rel]--''
(
	@Tipo				varchar(25)
)
as
select distinct local_origem [Origin],'26' [Type In Out], 'Portos Oxiteno' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_Purchaseorder where local_origem not in 
(select cd_org from atlantis.dbo.de_para where cd_tipo = 26 and Ativo = 1)
union ALL
select distinct local_destino [Origin],'26' [Type In Out], 'Portos Oxiteno' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_Purchaseorder where local_destino not in 
(select cd_org from atlantis.dbo.de_para where cd_tipo = 26 and Ativo = 1)
Union ALL
select distinct termo_pagamento [Origin],'30' [Type In Out], 'Termo de Pagamento' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_Purchaseorder where termo_pagamento not in 
(select cd_org from atlantis.dbo.de_para where cd_tipo = 30)
Union ALL
select distinct armazem  [Origin],'20' [Type In Out], 'Terminal Entrada' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB where armazem not in 
(select Cd_Org from de_para where cd_tipo = 20 and Ativo = 1)
Union ALL
select distinct nome   [Origin],'11' [Type In Out], 'Courier/Inland Trucker' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_Entidade where tipo = 'Transportador' and nome not in 
(select Cd_Org from de_para where cd_tipo = 11 and Ativo = 1)
Union ALL
select distinct nome [Origin],'31' [Type In Out], 'Courier/Agent' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_Entidade where tipo = 'Agente de Carga' and nome not in 
(select Cd_Org from de_para where cd_tipo = 31 and Ativo = 1)
Union ALL
select distinct tipo  [Origin],'13' [Type In Out], 'JOB/Container-Type' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_purchaseOrderJOB_Container where tipo not in 
(select Cd_Org from de_para where cd_tipo = 13 and Ativo = 1)
Union ALL
select distinct unidade_medida  [Origin],'25' [Type In Out], 'unid_medida' [Type Description], 'P21128' [Group]
from ATL_INT.dbo.JSON_Oxiteno_Purchaseorder_line where unidade_medida not in 
(select Cd_Org from de_para where cd_tipo = 25 and Ativo = 1)
Union ALL
select 'XXXXXXXXXXXX'  [Origin],'XXXXXXXXXXXX' [Type In Out], 'XXXXXXXXXXXX' [Type Description], 'XXXXXXXXXXXX' [Group]
Union ALL
select 'Usuario Cliente'  [Origin],'' [Type In Out], 'Sem Cadastro' [Type Description], 'P21128' [Group]
Union ALL
select distinct nome_comprador,'', 'Sem Cadastro' [Type Description], 'P21128' [Group] from ATL_INT.dbo.JSON_Oxiteno_Purchaseorder where nome_comprador not in 
(select Nome_Usuario from Usuario_Cliente where Cd_Cliente= 'P21128' )

GO
