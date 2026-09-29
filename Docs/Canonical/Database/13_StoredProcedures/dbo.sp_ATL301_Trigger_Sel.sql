SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Campo_ORdem C
--	JOIn Pedido_Ship P on P.cd_pedido = C.Cd_Pedido
--	join Pedido P with(nolock) on P.Cd_pedido = PS.cd_pedido
--where 
--	id_campo=3 
--	and Campo_Dados  like  '%304' 
--	and Dt_Ins_Upd > GETDATE() -30

--[sp_ATL301_Trigger_Sel]'EMCSR201701002BR'
CREATE Procedure [dbo].[sp_ATL301_Trigger_Sel]--'EMCSR201612048BR'
(
	@Num_Proc varchar(16)
)
as

Select 
	isnull(PS.Num_Proc,'Not Informed')						[Processo],
	isnull(P.Num_Pedido,'Not Informed')						[Numero Pedido],
	isnull(CO.Campo_Dados,'Not Informed')					[304],
	isnull(Convert(varchar(25),TP.Dt_Conclusao),'Not Informed')	[Recebimento de Booking],
	isnull(JOB.Booking_Number,'Not Informed')				[Numero do Booking],
	isnull(ARM.SAP_CODE,'Not Informed')						[SAP_CODE],
	(Case when 
		PL.Cd_Vendor = '' OR PL.Cd_Vendor IS null 
	then
		  'Not Informed'
	else 
		PL.Cd_Vendor 
	End)					[Vendor],
	--isnull(PL.Cd_Vendor	,'Not Informed')					[Vendor],
	
	isnull(PS.Item,'Not Informed')							[Item],
	isnull(PS.Lote,'Not Informed')							[Lote],
	isnull(PC.cd_Proc_Cliente,'Not Informed')				[Codigo do Produto],
	isnull(PC.Produto_Descr,'Not Informed')					[Descrição do Produto]
from 
	Pedido_ship PS with(nolock)
	join Pedido P with(nolock) on P.Cd_pedido = PS.cd_pedido
	join Produto_Cliente PC on PC.cd_prod = PS.cd_produto	
	left Join Campo_ORdem CO with(nolock) on CO.cd_pedido=PS.cd_pedido and id_campo=3
	left Join Tarefas_PRocessos TP with(nolock) on TP.id_task=5 and ps.num_proc=tp.num_proc --and TP.Dt_Conclusao is not null
	left Join vwHouse_Exp JOB with(nolock) on JOB.num_proc=ps.num_proc --and Booking_Number is not null
	left Join Armador ARM with(nolock) on ARM.cd_armador=JOB.cd_armador --and SAP_CODE is not null
	left Join Pessoa_LLP PL with(nolock) on JOB.Cd_Transportadora = PL.Cd_Pes --and PL.Cd_Vendor is not NULL
	
	--left Join EDI301 EDI with(nolock) on EDI.num_proc=PS.num_proc
where
	CO.Campo_Dados  like  '%304' 
	and PS.Num_Proc = @Num_Proc
	and left(ps.num_proc,2)='EM' 
	--and EDI.num_proc is null





--insert EDI301
--select distinct PS.num_proc Processo,NULL from Pedido_ship PS with(nolock)
--left Join EDI301 EDI with(nolock) on EDI.num_proc=PS.num_proc
--Join Campo_ORdem CO with(nolock) on CO.cd_pedido=PS.cd_pedido and id_campo=3
--Join Tarefas_PRocessos TP with(nolock) on TP.id_task=5 and ps.num_proc=tp.num_proc and TP.Dt_Conclusao is not null
--Join vwHouse_Exp JOB with(nolock) on JOB.num_proc=ps.num_proc and Booking_Number is not null
--Join Armador ARM with(nolock) on ARM.cd_armador=JOB.cd_armador and SAP_CODE is not null
--Join Pessoa_LLP PL with(nolock) on JOB.Cd_Transportadora = PL.Cd_Pes and PL.Cd_Vendor is not NULL
--where
--	CO.Campo_Dados  like  '%304' and EDI.num_proc is null
--	and left(ps.num_proc,2)='EM' 
	

	
--select num_proc processo,numero_po_hEm BuyerReference from EDI301 LV
--join PO_HEM PO on LV.Num_Proc = PO.Num_Proc_HeM and PO.ID_DC = 8
--where Dt_Envio is NULL 
--group by num_proc ,numero_po_hem 
--union all
--select num_proc processo,numero_po_hea BuyerReference from EDI301 LV
--join PO_HEA PO on LV.Num_Proc = PO.Num_Proc_HeA and PO.ID_DC = 8
--where Dt_Envio is NULL
--group by num_proc ,numero_po_hea
--union all
--select num_proc processo,numero_po_heo BuyerReference from EDI301 LV
--join PO_HEO PO on LV.Num_Proc = PO.Num_Proc_HeO and PO.ID_DC = 8
--where Dt_Envio is NULL
--group by num_proc ,numero_po_heo
GO
