SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_CambioVencInvoice] --40, 'Grupo Dow'
		(
			@Dias	int,
			@Grupo varchar(50)
		)
as	
		declare @cd_pes_grupo varchar(10)
		Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)


select 
	TF.Num_Proc [PROCESSO],
	Inv.Numero_Po_Him [INVOICE NUMBER],
	INV.data_po_him [INVOICE DATE], 
	PO.Numero_Po_Him [PO],
	SO.Numero_Po_Him [SO], 
	cast(getdate()-Isnull(INV.data_po_him,getdate()-@Dias) as float) [DIAS],
	DST.Nome_Local [LOCAL DE DESTINO] 
from 
	po_him INV With(nolock)
	Join HOUSE_Imp_MAR		HOU With(nolock) on INV.Num_Proc_Him = HOU.Num_Proc_Him
	Join LLP_Imp_MAR		LLP With(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Join Pessoa_LLP			PLL with(nolock)  on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@cd_pes_grupo
	Join Tarefas_processos	TF With(nolock) on	TF.num_proc=INV.num_proc_him and TF.id_task=23
	Left Join PO_HIM		SO With(nolock) on	INV.num_proc_him = SO.num_proc_him and SO.ID_Dc=3
	Left Join PO_HIM		PO With(nolock) on	INV.num_proc_him = PO.num_proc_him and PO.ID_Dc=1
	Join tarefas_processos	CCD With(nolock) on	CCD.num_proc=INV.num_proc_him and CCD.id_task=4
	left join localidade	DST With(nolock) on HOU.cd_dst_him = DST.cd_local
Where 
	INV.id_dc=2 and TF.dt_conclusao is null
	and PO.Numero_Po_Him <> SO.Numero_Po_Him and PO.Numero_Po_Him not like '%FORM%'
	and PO.Numero_Po_Him not like '%SAMP%' and SO.Numero_Po_Him not like '%SAMP%'
	and inv.data_po_him is not null 
	and cast(getdate()-Isnull(INV.data_po_him,getdate()-@Dias) as float) >=@Dias
	and CCD.dt_conclusao is not null 
	and isnull(LLP.ID_Status,0) <> 9

UNION

select 
	TF.Num_Proc [PROCESSO],
	Inv.Numero_Po_HIA [INVOICE NUMBER],
	INV.data_po_HIA [INVOICE DATE], 
	PO.Numero_Po_HIA [PO],
	SO.Numero_Po_HIA [SO], 
	cast(getdate()-Isnull(INV.data_po_hia,getdate()-@Dias) as float) [DIAS],
	DST.Nome_Local [LOCAL DE DESTINO] 
from 
	po_HIA INV With(nolock)
	Join HOUSE_Imp_AER		HOU With(nolock) on INV.Num_Proc_Hia = HOU.Num_Proc_Hia
	Join LLP_Imp_AER		LLP With(nolock) on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
	Join Pessoa_LLP			PLL with(nolock)  on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo=@cd_pes_grupo
	Join Tarefas_processos	TF With(nolock) on	TF.num_proc=INV.num_proc_HIA and id_task=23
	Left Join PO_HIA		SO With(nolock) on	INV.num_proc_HIA = SO.num_proc_HIA and SO.ID_Dc=3
	Left Join PO_HIA		PO With(nolock) on	INV.num_proc_HIA = PO.num_proc_HIA and PO.ID_Dc=1
	Join tarefas_processos	CCD With(nolock) on	CCD.num_proc=INV.num_proc_hia and CCD.id_task=4
	left join localidade	DST With(nolock) on HOU.cd_dst_hia = DST.cd_local

Where 
	INV.id_dc=2 and TF.dt_conclusao is  null
	and PO.Numero_Po_Hia <> SO.Numero_Po_Hia and PO.Numero_Po_Hia not like '%FORM%'
	and PO.Numero_Po_Hia not like '%SAMP%' and SO.Numero_Po_Hia not like '%SAMP%'
	and cast(getdate()-Isnull(INV.data_po_hia,getdate()-@Dias) as float) >=@Dias
	and CCD.Dt_conclusao is not null 
	and isnull(LLP.ID_Status,0) <> 9

UNION

select 
	TF.Num_Proc [PROCESSO],
	Inv.Numero_Po_hio [INVOICE NUMBER],
	INV.data_po_hio [INVOICE DATE], 
	PO.Numero_Po_hio [PO],
	SO.Numero_Po_hio [SO], 
	cast(getdate()-Isnull(INV.data_po_hio,getdate()-@Dias) as float) [DIAS],
	DST.Nome_Local [LOCAL DE DESTINO]  
from 
	po_hio INV With(nolock)
	Join HOUSE_Imp_OUT		HOU With(nolock) on INV.Num_Proc_Hio = HOU.Num_Proc_Hio
	Join LLP_Imp_OUT		LLP With(nolock) on HOU.Num_Proc_HIo = LLP.Num_Proc_LIo
	Join Pessoa_LLP			PLL with(nolock)  on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo=@cd_pes_grupo
	Join Tarefas_processos	TF With(nolock) on	TF.num_proc=INV.num_proc_hio and id_task=23
	Left Join PO_hio		SO With(nolock) on	INV.num_proc_hio = SO.num_proc_hio and SO.ID_Dc=3
	Left Join PO_hio		PO With(nolock) on	INV.num_proc_hio = PO.num_proc_hio and PO.ID_Dc=1
	Join tarefas_processos	CCD With(nolock) on	CCD.num_proc=INV.num_proc_hio and CCD.id_task=4
	left join localidade	DST With(nolock) on HOU.cd_dst_hio = DST.cd_local
Where 
	INV.id_dc=2 and TF.dt_conclusao is  null
	and PO.Numero_Po_Hio <> SO.Numero_Po_Hio and PO.Numero_Po_Hio not like '%FORM%'
	and PO.Numero_Po_Hio not like '%SAMP%' and SO.Numero_Po_Hio not like '%SAMP%'
	and cast(getdate()-Isnull(INV.data_po_hio,getdate()-@Dias) as float) >=@Dias
	and CCD.dt_conclusao is not null 
	and isnull(LLP.ID_Status,0) <> 9

order by Dias desc

OPTION(HASH JOIN)


GO
