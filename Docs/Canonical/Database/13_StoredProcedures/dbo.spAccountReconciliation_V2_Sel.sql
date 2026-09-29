SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spAccountReconciliation_V2_Sel]

as

select LLP.num_proc_lia JOB from llp_imp_aer LLP
	left join PO_HIA PO on PO.num_proc_hia = LLP.num_proc_lia and PO.id_dc = 5
	where substring(num_proc_lia,3,3) = 'CSR'	
	and (LLP.ATA_LIA > getdate()-31 or PO.data_po_hia > getdate()-31)
UNION ALL
select LLP.num_proc_lim JOB from llp_imp_mar LLP
	left join PO_HIM PO on PO.num_proc_him = LLP.num_proc_lim and PO.id_dc = 5
	where substring(num_proc_lim,3,3) = 'CSR'	
	and (LLP.ATA_LIM > getdate()-31 or PO.data_po_him > getdate()-31)
UNION ALL
select LLP.num_proc_lio JOB from llp_imp_out LLP
	left join PO_HIO PO on PO.num_proc_hio = LLP.num_proc_lio and PO.id_dc = 5
	where substring(num_proc_lio,3,3) = 'CSR'	
	and (LLP.ATA_LIO > getdate()-31 or PO.data_po_hio > getdate()-31)
order by JOB

/*Alterado acima pra trazer todos os jobs do mês com ATA ou DI.Data do mês)

select num_proc_lia JOB from llp_imp_aer where substring(num_proc_lia,3,3) = 'CSR' and ATA_LIA > getdate()-31
union all
select num_proc_lim JOB from llp_imp_mar where substring(num_proc_lim,3,3) = 'CSR' and ATA_LIM > getdate()-31
union all
select num_proc_lio JOB from llp_imp_out where substring(num_proc_lio,3,3) = 'CSR' and ATA_LIO > getdate()-31
*/

/*
Solicitação da Marcia em 23/09/2011 selecionar os JOBs a partir do ATA

	select 
		Num_Proc_HIA  job from PO_HIA 
	where 
		id_dc=5
		and right(left(Num_Proc_HIA,5),3) = 'CSR' 
		and Data_PO_HIA > getdate() - 360 and year(Data_PO_HIA) >= 2010
--		and year(Data_PO_HIA)=2008 
		and Numero_PO_HIA not like 'Courier%' 

	UNION 
	select 
		Num_Proc_HIM JOB from PO_HIM 
	where 
		id_dc=5 
		and right(left(Num_Proc_HIM,5),3) = 'CSR'
		and Data_PO_HIM > getdate() - 360 and year(Data_PO_HIM) >= 2010
--		and year(Data_PO_HIM)=2008 

	UNION

	select 
		Num_Proc_HIO JOB from PO_HIO 
	where 
		id_dc=5 
		and right(left(Num_Proc_HIO,5),3) = 'CSR' 
		and Data_PO_HIO > getdate() - 360 and year(Data_PO_HIO) >= 2010
--		and year(Data_PO_HIO)=2008 

	Union
	
	Select
		Num_Proc Job
	From	
		Tarefas_Processos
	Where
		dt_Conclusao >=getdate()-360
		and ID_Task = '25'
		and right(left(Num_Proc,5),3) = 'CSR'

order by
	1
*/





GO
