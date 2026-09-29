SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp301_Equipment_Sel 'EMCSR202210003BR'
--Console.WriteLine(String.Format(CultureInfo.InvariantCulture,                     "{0:0.00}", value));
CREATE Procedure [dbo].[spInt301_Teste_Sel]

As
SET NOCOUNT ON;

select num_proc processo,numero_po_hEm BuyerReference from EDI301 LV with(nolock)
join PO_HEM PO  with(nolock) on LV.Num_Proc = PO.Num_Proc_HeM and PO.ID_DC = 8
where 
--Dt_Envio is NULL 
LV.Num_Proc in ('EMCSR202210003BR')
group by num_proc ,numero_po_hem 
option (hash join)
GO
