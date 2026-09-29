SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBuscaProcessoMiroJOB]

as

select distinct num_proc_him JOB,dbo.fBusca_TipoDocCliente('N',num_proc_him,1) Pedido
--select distinct id_miro,fm.id_evento,num_proc_him Job,PC.tipo,cd_vendor ,
----10055103 BDP,
----88151304 BDP,
--88132764 BDP,
--convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
from fmc_miro FM
Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
Join House_Imp_MAr HOU on HOU.num_proc_him=cc.num_proc and cc.num_proc=FM.fatura_pc
Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_him
Where 
--status='C' and 
FM.id_evento <> 'F'

--and id_miro  = 0
and fm.Fatura_PC in --('IMFMC201905023BR','IMFMC201905026BR')
('IAFMC201906003BR',
'IMFMC201905023BR',
'IMFMC201905026BR',
'IMFMC201907007BR',
'IAFMC201906005BR',
'IAFMC201906006BR',
'IAFMC201906007BR',
'IAFMC201906008BR',
'IAFMC201906010BR',
'IAFMC201906011BR',
'IAFMC201906013BR',
'IAFMC201906014BR',
'IMFMC201907004BR',
'IMFMC201905021BR',
'IMFMC201905028BR',
'IMFMC201905029BR',
'IMFMC201906004BR',
'IMFMC201906005BR',
'IMFMC201906006BR',
'IMFMC201906008BR',
'IMFMC201906009BR',
'IMFMC201906010BR',
'IMFMC201906003BR',
'IMFMC201906002BR',
'IMFMC201907008BR',
'IAFMC201906009BR',
'IAFMC201907002BR',
'IMFMC201905033BR',
'IMFMC201907009BR',
'IMFMC201907011BR',
'IAFMC201907001BR',
'IMFMC201905030BR',
'IMFMC201905035BR')
and FM.id_evento <> 'I'
union

select distinct num_proc_hia JOB,dbo.fBusca_TipoDocCliente('N',num_proc_hia,1) Pedido
--select distinct id_miro,fm.id_evento,num_proc_hia Job,PC.tipo,cd_vendor ,
----10055103 BDP,
----88151304 BDP,
--88132764 BDP,
--convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
from fmc_miro FM
Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
Join House_Imp_aer HOU on HOU.num_proc_hia=cc.num_proc and cc.num_proc=FM.fatura_pc
Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_hia
Where 
--status='C' and 
FM.id_evento <> 'F'

--and id_miro  = 0
and fm.Fatura_PC in --= 'IAFMC201906003BR'
('IAFMC201906003BR',
'IMFMC201905023BR',
'IMFMC201905026BR',
'IMFMC201907007BR',
'IAFMC201906005BR',
'IAFMC201906006BR',
'IAFMC201906007BR',
'IAFMC201906008BR',
'IAFMC201906010BR',
'IAFMC201906011BR',
'IAFMC201906013BR',
'IAFMC201906014BR',
'IMFMC201907004BR',
'IMFMC201905021BR',
'IMFMC201905028BR',
'IMFMC201905029BR',
'IMFMC201906004BR',
'IMFMC201906005BR',
'IMFMC201906006BR',
'IMFMC201906008BR',
'IMFMC201906009BR',
'IMFMC201906010BR',
'IMFMC201906003BR',
'IMFMC201906002BR',
'IMFMC201907008BR',
'IAFMC201906009BR',
'IAFMC201907002BR',
'IMFMC201905033BR',
'IMFMC201907009BR',
'IMFMC201907011BR',
'IAFMC201907001BR',
'IMFMC201905030BR',
'IMFMC201905035BR')
and FM.id_evento <> 'I'

union 

select distinct num_proc_hio JOB,dbo.fBusca_TipoDocCliente('N',num_proc_hio,1) Pedido

--select distinct id_miro,fm.id_evento,num_proc_hio Job,PC.tipo,cd_vendor ,
----10055103 BDP,
----88151304 BDP,
--88132764 BDP,
--convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
from fmc_miro FM
Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
Join House_Imp_out HOU on HOU.num_proc_hio=cc.num_proc and cc.num_proc=FM.fatura_pc
Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_hio
Where 
status='C'and 
FM.id_evento <> 'F'
--and id_miro  = 0
and fm.Fatura_PC in --= 'IAFMC201906003BR'
('IAFMC201906003BR',
'IMFMC201905023BR',
'IMFMC201905026BR',
'IMFMC201907007BR',
'IAFMC201906005BR',
'IAFMC201906006BR',
'IAFMC201906007BR',
'IAFMC201906008BR',
'IAFMC201906010BR',
'IAFMC201906011BR',
'IAFMC201906013BR',
'IAFMC201906014BR',
'IMFMC201907004BR',
'IMFMC201905021BR',
'IMFMC201905028BR',
'IMFMC201905029BR',
'IMFMC201906004BR',
'IMFMC201906005BR',
'IMFMC201906006BR',
'IMFMC201906008BR',
'IMFMC201906009BR',
'IMFMC201906010BR',
'IMFMC201906003BR',
'IMFMC201906002BR',
'IMFMC201907008BR',
'IAFMC201906009BR',
'IAFMC201907002BR',
'IMFMC201905033BR',
'IMFMC201907009BR',
'IMFMC201907011BR',
'IAFMC201907001BR',
'IMFMC201905030BR',
'IMFMC201905035BR')
and FM.id_evento <> 'I'
order by 1
















GO
