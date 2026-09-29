SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from fmc_miro 
--'    BDP    10055103        -   88151304
--            'Agora passou a ser o Código despachante BDP = 88132764
CREATE Procedure [dbo].[spBuscaProcessoMiro_TST] -- [dbo].[spBuscaProcessoMiro_TST] 'FMC'
	@Grupo Varchar(3)

as
Declare @ID int

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
FM.ID_Evento not in ('I','F')
and	Fatura_PC in('IMFMC201908013BR')
--	('IMFMC201906017BR',
--'IAFMC201906004BR',
--'IMFMC201906014BR',
--'IMFMC201907010BR',
--'IMFMC201907015BR')
--and id_miro  = 0
--union

--select distinct id_miro,fm.id_evento,num_proc_hia Job,PC.tipo,cd_vendor ,
----10055103 BDP,
----88151304 BDP,
--88132764 BDP,
--convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
--from fmc_miro FM
--Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
--Join House_Imp_aer HOU on HOU.num_proc_hia=cc.num_proc and cc.num_proc=FM.fatura_pc
--Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
--Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_hia
--Where 
----status='C'and 
--FM.ID_Evento not in ('I','F')
--and	Fatura_PC in
--	('IMFMC201906017BR',
--'IAFMC201906004BR',
--'IMFMC201906014BR',
--'IMFMC201907010BR',
--'IMFMC201907015BR')
----and id_miro  = 0









--Set @ID = 13396

--13396
--13397
--13398
--13403

--select distinct id_miro,fm.id_evento,num_proc_him Job,PC.tipo,cd_vendor ,
----10055103 BDP,
----88151304 BDP,
--88132764  BDP,
--convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
--from fmc_miro FM
--Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
--Join House_Imp_MAr HOU on HOU.num_proc_him=cc.num_proc and cc.num_proc=FM.fatura_pc
--Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
--Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_him
--Where 
--	--id_miro =@ID
--	--Fatura_PC in ('IMFMC201907007BR','IMFMC201907004BR')
--	Fatura_PC in
--	('IMFMC201906017BR',
--'IAFMC201906004BR',
--'IMFMC201906014BR',
--'IMFMC201907010BR',
--'IMFMC201907015BR')
--	and fm.ID_Evento not in ('I','F')
--union

--select distinct id_miro,fm.id_evento,num_proc_hia Job,PC.tipo,cd_vendor ,
----10055103 BDP,
--88151304 BDP,
--88132764  BDP,
--convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
--from fmc_miro FM
--Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
--Join House_Imp_aer HOU on HOU.num_proc_hia=cc.num_proc and cc.num_proc=FM.fatura_pc
--Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
--Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_hia
--Where 
--	--id_miro =@ID
--	Fatura_PC in
--	('IMFMC201906017BR',
--	'IAFMC201906004BR',
--	'IMFMC201906014BR',
--	'IMFMC201907010BR',
--	'IMFMC201907015BR')
--		and fm.ID_Evento not in ('I','F')
----union

----select distinct id_miro,fm.id_evento,num_proc_hio Job,PC.tipo,cd_vendor ,
------10055103 BDP,
----88151304 BDP,
----88132764  BDP,
----convert(float,dbo.fBusca_CampoCliente(cc.num_proc,31)) Paridade 
----from fmc_miro FM
----Join Custo_Cliente CC on CC.num_nf_custo=cast(id_miro as varchar(10))
----Join House_Imp_out HOU on HOU.num_proc_hio=cc.num_proc and cc.num_proc=FM.fatura_pc
----Join FMC_Plano_Contas_v2 PC on PC.id_evento=FM.id_evento and cc.cd_tp_tx=PC.cd_tp_Tx
----Left Join Pessoa_LLP PP on PP.cd_pes=cd_export_hio
----Where 
----	--id_miro =@ID
----	Fatura_PC in ('IMFMC201811017BR',' IAFMC201902001BR')  
--order by 1


----select * from FMC_Miro
----where Fatura_PC = 'IMFMC201602021BR'

----select * from FMC_Miro
----where Fatura_PC = 'IMFMC201602022BR'

----select * from FMC_Miro
----where Fatura_PC = 'IMFMC201602023BR'



































































































GO
