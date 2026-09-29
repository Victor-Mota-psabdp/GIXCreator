SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spRelaDow_Mesquita_imp] 
as
select 
	hou.Num_Proc_HIM										Processo,
	hou.MAWB_HIM											MAWB,
	HAWB_HIM												HAWB,
	ETA_LIM													ETA,
	ATA_LIM													ATA,
	ETD_LIM													ETD,
	ATD_LIM													ATD, 
	Nome_Armador											Armador,
	Navio_HIM												Navio, 
	Org.Nome_Local											Origem,
	Dst.Nome_Local											Destino,
	dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico,
	TERM.Nome_Terminal,
	dbo.fBusca_Containers(hou.num_proc_him)					Containers,
	dbo.Qty_Container(hou.num_proc_him)						Qtde
from
	house_imp_mar HOU
	Join LLp_imp_mar					LLP on LLP.num_proc_LIM=hou.num_proc_HIM and LLP.Eta_lim > getdate() - 10
	left Join Job_imp_mar				JOB on JOB.num_proc_him=hou.num_proc_him
	left Join Armador					ARM on ARM.cd_armador=job.cd_armador	
	left Join Localidade				Org on hou.cd_org_HIM=Org.cd_local
	left Join Localidade				Dst on cd_dst_HIM =DSt.cd_local
	Left Join Terminal					TERM on LLP.Cd_Terminal = TERM.Cd_Terminal	
	Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo='1'

where
	hou.MAWB_HIM is not null and
	HAWB_HIM is not null and
	Dst.Nome_Local = 'Santos'	
	
group by
	hou.Num_Proc_HIM,
	hou.MAWB_HIM,
	HAWB_HIM,
	ETA_LIM,
	ATA_LIM,
	ETD_LIM,
	ATD_LIM,
	Nome_Armador,
	Navio_HIM,	
	Org.Nome_Local,
	Dst.Nome_Local,		
	TERM.Nome_Terminal

order by 
	ETA

GO
