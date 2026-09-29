SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spInt301_Sel]

As
SET NOCOUNT ON;
insert EDI301
select distinct PS.num_proc Processo,NULL from Pedido_ship PS with(nolock)
left Join EDI301 EDI with(nolock) on EDI.num_proc=PS.num_proc
Join Campo_ORdem CO with(nolock) on CO.cd_pedido=PS.cd_pedido and id_campo=3
Join Tarefas_PRocessos TP with(nolock) on TP.id_task=5 and ps.num_proc=tp.num_proc and TP.Dt_Conclusao is not null
Join vwHouse_Exp JOB with(nolock) on JOB.num_proc=ps.num_proc and Booking_Number is not null
Join Armador ARM with(nolock) on ARM.cd_armador=JOB.cd_armador and SAP_CODE is not null
Join Pessoa_LLP PL with(nolock) on JOB.Cd_Transportadora = PL.Cd_Pes and (PL.Cd_Vendor is not NULL or rtrim(ltrim(PL.Cd_Vendor)) <> '')
where
	CO.Campo_Dados  like  '%304' and EDI.num_proc is null
	and left(ps.num_proc,2)='EM' and TP.Dt_Conclusao  >=getdate()-90
	--and JOB.Cut_Date is not null


option (hash join)

	
select num_proc processo,numero_po_hEm BuyerReference from EDI301 LV with(nolock)
join PO_HEM PO  with(nolock) on LV.Num_Proc = PO.Num_Proc_HeM and PO.ID_DC = 8
where Dt_Envio is NULL 
group by num_proc ,numero_po_hem 
union all
select num_proc processo,numero_po_hea BuyerReference from EDI301 LV with(nolock)
join PO_HEA PO  with(nolock) on LV.Num_Proc = PO.Num_Proc_HeA and PO.ID_DC = 8
where Dt_Envio is NULL
group by num_proc ,numero_po_hea
union all
select num_proc processo,numero_po_heo BuyerReference from EDI301 LV with(nolock)
join PO_HEO PO  with(nolock) on LV.Num_Proc = PO.Num_Proc_HeO and PO.ID_DC = 8
where Dt_Envio is NULL
group by num_proc ,numero_po_heo

option (hash join)
GO
