SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






































CREATE Procedure [dbo].[spBuscaProcessoMiro_teste]


as
Declare @ID int
Set @ID=508



select distinct id_miro,fm.id_evento,num_proc_him Job,PC.tipo,cd_vendor ,10055103 BDP,convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
from fmc_miro FM
Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
Join House_Imp_MAr HOU on HOU.num_proc_him=cc.num_proc and cc.num_proc=FM.fatura_pc
Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_him
Where --id_miro =@ID
id_miro in (426,436)

union

select distinct id_miro,fm.id_evento,num_proc_hia Job,PC.tipo,cd_vendor ,10055103 BDP,convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
from fmc_miro FM
Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
Join House_Imp_aer HOU on HOU.num_proc_hia=cc.num_proc and cc.num_proc=FM.fatura_pc
Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_hia
Where --id_miro =@ID
id_miro in (426,436)

union

select distinct id_miro,fm.id_evento,num_proc_hio Job,PC.tipo,cd_vendor ,10055103 BDP,convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
from fmc_miro FM
Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
Join House_Imp_out HOU on HOU.num_proc_hio=cc.num_proc and cc.num_proc=FM.fatura_pc
Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_hio
Where --id_miro =@ID
id_miro in (426,436)


order by 1




























































GO
