SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu: para não enviar coloquei id_miro  = 0
--select * from fmc_miro where Dt_Envio > GETDATE() -8
-- miro F - Complementar eh criada no ATL_Web,dbo.Miro  e enviada pelo segundo select do Miro 
--para reenviar retira o dt_envio
 --'    BDP    10055103        -   88151304
 --           'Agora passou a ser o Código despachante BDP = 88132764
CREATE Procedure [dbo].[spBuscaProcessoMiro]

as

select distinct id_miro,fm.id_evento,num_proc_him Job,PC.tipo,cd_vendor ,
--10055103 BDP,
--88151304 BDP,
88132764 BDP,
convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
from fmc_miro FM
Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
Join House_Imp_MAr HOU on HOU.num_proc_him=cc.num_proc and cc.num_proc=FM.fatura_pc
Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_him
Where 
status='C'
and FM.id_evento <> 'F'
--and id_miro  = 0
union

select distinct id_miro,fm.id_evento,num_proc_hia Job,PC.tipo,cd_vendor ,
--10055103 BDP,
--88151304 BDP,
88132764 BDP,
convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
from fmc_miro FM
Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
Join House_Imp_aer HOU on HOU.num_proc_hia=cc.num_proc and cc.num_proc=FM.fatura_pc
Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_hia
Where 
status='C'
and FM.id_evento <> 'F'
--and id_miro  = 0

union 

select distinct id_miro,fm.id_evento,num_proc_hio Job,PC.tipo,cd_vendor ,
--10055103 BDP,
--88151304 BDP,
88132764 BDP,
convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
from fmc_miro FM
Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
Join House_Imp_out HOU on HOU.num_proc_hio=cc.num_proc and cc.num_proc=FM.fatura_pc
Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_hio
Where 
status='C'
and FM.id_evento <> 'F'
--and id_miro  = 0

order by 1
















GO
