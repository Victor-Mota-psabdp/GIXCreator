SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[spReport_Raquel_Sel] --'ALL'

	@DtInicial		Datetime,
	@DtFinal		Datetime

AS 

select Modal,
	HOUI.Num_Proc [Job],
	HOUI.Master [Consol],
	HOUI.HAWB [HAWB/HBL],
	MAS.MAWB_MIM [MAWB/MBL],
	OrgC.Nome_Pais  [Country of Origin],
	Org.Nome_Local [Origin],
	Orgcd.Nome_Pais [Country of Destination],
	dst.Nome_Local [Destination],
	HOUI.Tipo_Frete [House Freight Term], 
	HOUI.Moeda_Frete [Moeda Frete],
	HOUI.Frete_BL [House Freight Value], 
	case when MAS.Tp_Frete_MIM='C' then 'Collect' else 'Prepaid' End [Master Freight Term],
	mas.Cd_tp_moeda [Master - Moeda Frete], mas.Vlr_Frete_MIM [Master Freight Value]
						
from vwHouse_Imp HOUI with(nolock)
Join Master_Imp_Mar MAS with(nolock) on MAS.Num_Proc_MIM = HOUI.Master
Join Localidade Org		with(nolock) on ORg.Cd_Local = HOUI.Cd_Org 
Join Pais OrgC			with(nolock) on OrgC.Cd_Pais = ORG.Cd_Pais 
Join Localidade DST		with(nolock) on DST.Cd_Local = HOUI.Cd_Dst 
Join Pais OrgCD			with(nolock) on DST.Cd_Pais = ORGCD.Cd_Pais 

where HOUI.Master <> 'Job' and 
HOUI.Master <> '' 
--and HOUI.ATD > ='01-01-2010'
and HOUI.ATA between @DtInicial and @DtFinal

Union all

select Modal,
	HOUE.Num_Proc [Job],
	HOUE.Master [Consol],
	HOUE.HAWB [HAWB/HBL],
	MAS.MAWB_MEM [MAWB/MBL],
	OrgC.Nome_Pais  [Country of Origin],
	Org.Nome_Local [Origin],
	Orgcd.Nome_Pais [Country of Destination],
	dst.Nome_Local [Destination],
	HOUE.Tipo_Frete [House Freight Term], 
	HOUE.Moeda_Frete [Moeda Frete],
	HOUE.Frete_BL [House Freight Value], 
	case when MAS.Tp_Frete_MEM='C' then 'Collect' else 'Prepaid' End [Master Freight Term],
	mas.Cd_tp_moeda [Master - Moeda Frete], mas.Vlr_Frete_MEM [Master Freight Value]
								
from vwHouse_Exp HOUE with(nolock)
Join Master_Exp_Mar MAS with(nolock) on MAS.Num_Proc_MEM = HOUE.Master
Join Localidade Org		with(nolock) on ORg.Cd_Local = HOUE.Cd_Org 
Join Pais OrgC			with(nolock) on OrgC.Cd_Pais = ORG.Cd_Pais 
Join Localidade DST		with(nolock) on DST.Cd_Local = HOUE.Cd_Dst 
Join Pais OrgCD			with(nolock) on DST.Cd_Pais = ORGCD.Cd_Pais 


where HOUE.Master <> 'Job' and 
HOUE.Master <> ''
-- and HOUE.ATD > ='01-01-2010'
and HOUE.ATD between @DtInicial and @DtFinal


Union all


select Modal,
	HOUI.Num_Proc [Job],
	HOUI.Master [Consol],
	HOUI.HAWB [HAWB/HBL],
	MAS.MAWB_MIa [MAWB/MBL],
	OrgC.Nome_Pais  [Country of Origin],
	Org.Nome_Local [Origin],
	Orgcd.Nome_Pais [Country of Destination],
	dst.Nome_Local [Destination],
	HOUI.Tipo_Frete [House Freight Term], 
	HOUI.Moeda_Frete [Moeda Frete],
	HOUI.Frete_BL [House Freight Value], 
	case when MAS.Tp_Frete_MIA='C' then 'Collect' else 'Prepaid' End [Master Freight Term],
	mas.Cd_tp_moeda [Master - Moeda Frete], mas.Vlr_Frete_MIa [Master Freight Value]
						
from vwHouse_Imp HOUI with(nolock)
Join Master_Imp_aer MAS with(nolock) on MAS.Num_Proc_MIA = HOUI.Master
Join Localidade Org		with(nolock) on ORg.Cd_Local = HOUI.Cd_Org 
Join Pais OrgC			with(nolock) on OrgC.Cd_Pais = ORG.Cd_Pais 
Join Localidade DST		with(nolock) on DST.Cd_Local = HOUI.Cd_Dst 
Join Pais OrgCD			with(nolock) on DST.Cd_Pais = ORGCD.Cd_Pais 

where HOUI.Master <> 'Job' and 
HOUI.Master <> '' 
--and HOUI.ATD > ='01-01-2010'
and HOUI.ATA between @DtInicial and @DtFinal

Union all

select Modal,
	HOUE.Num_Proc [Job],
	HOUE.Master [Consol],
	HOUE.HAWB [HAWB/HBL],
	MAS.MAWB_MEa [MAWB/MBL],
	OrgC.Nome_Pais  [Country of Origin],
	Org.Nome_Local [Origin],
	Orgcd.Nome_Pais [Country of Destination],
	dst.Nome_Local [Destination],
	HOUE.Tipo_Frete [House Freight Term], 
	HOUE.Moeda_Frete [Moeda Frete],
	HOUE.Frete_BL [House Freight Value], 
	case when MAS.Tp_Frete_MEa='C' then 'Collect' else 'Prepaid' End [Master Freight Term],
	mas.Cd_tp_moeda [Master - Moeda Frete], mas.Vlr_Frete_MEa [Master Freight Value]
								
from vwHouse_Exp HOUE with(nolock)
Join Master_Exp_AER MAS with(nolock) on MAS.Num_Proc_MEA = HOUE.Master
Join Localidade Org		with(nolock) on ORg.Cd_Local = HOUE.Cd_Org 
Join Pais OrgC			with(nolock) on OrgC.Cd_Pais = ORG.Cd_Pais 
Join Localidade DST		with(nolock) on DST.Cd_Local = HOUE.Cd_Dst 
Join Pais OrgCD			with(nolock) on DST.Cd_Pais = ORGCD.Cd_Pais 


where HOUE.Master <> 'Job' and 
HOUE.Master <> '' 
--and HOUE.ATD > ='01-01-2010'
and HOUE.ATD between @DtInicial and @DtFinal
GO
