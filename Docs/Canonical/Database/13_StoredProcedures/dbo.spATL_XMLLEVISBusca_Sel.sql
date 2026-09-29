SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_XMLLEVISBusca_Sel]

as

SET NOCOUNT ON;

insert Into exchange_Levis
select excprocesso Job,min(EX.ExcId),NULL from exchange EX with(nolock)
left join exchange_Levis EXC with(nolock) on EX.ExcID= EXC.ExcID
join vwCliente VW with(nolock) on EX.excprocesso = VW.Num_Proc
Join Pessoa_LLP	PLL	With(nolock) on vw.cd_cliente = PLL.Cd_Pes and PLL.Cd_Pes_Grupo in ('P000020728')
where  Exc.ExcId is NULL  
and ExcDataAlt >= getdate()-30
and Data >=getdate() -60 
group by  excprocesso 


select num_proc processo,numero_po_him BuyerReference from Exchange_Levis LV
join PO_HIM PO on LV.Num_Proc = PO.Num_Proc_HIM and PO.ID_DC = 9
where Dt_Envio is NULL 
group by num_proc ,numero_po_him 
union all
select num_proc processo,numero_po_hia BuyerReference from Exchange_Levis LV
join PO_HIA PO on LV.Num_Proc = PO.Num_Proc_HIA and PO.ID_DC = 9
where Dt_Envio is NULL
group by num_proc ,numero_po_hia
union all
select num_proc processo,numero_po_hio BuyerReference from Exchange_Levis LV
join PO_HIO PO on LV.Num_Proc = PO.Num_Proc_HIO and PO.ID_DC = 9
where Dt_Envio is NULL
group by num_proc ,numero_po_hio



GO
