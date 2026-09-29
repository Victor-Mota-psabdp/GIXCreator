SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Danilo Ventura
-- Create date: 14/05/2009
-- Description: Seleciona o numero do JOB e PO, pelo numero da DI
-- facilitando a identificação de debitos do account
-- =============================================

CREATE PROCEDURE [dbo].[spAccount_Sel] --'08/0557156-0'
(
@DI				VarChar(12)
)
 AS
	select 
		DI.Num_Proc_HIO	 JOB,
		PO.Numero_PO_HIO	 PO
	from 
		PO_HIO DI
		left join PO_HIO PO on PO.Num_Proc_hio = DI.num_proc_hio and PO.id_dc = '1'
	where 
		DI.numero_po_hio = @DI

UNION

	select 
		DI.Num_Proc_HIA	 JOB,
		PO.Numero_PO_HIA	 PO
	from 
		PO_HIA DI
		left join PO_HIA PO on PO.Num_Proc_hia = DI.num_proc_hia and PO.id_dc = '1'
	where 
		DI.numero_po_hia = @DI

UNION

	select 
		DI.Num_Proc_HIM	 JOB,
		PO.Numero_PO_HIM	 PO
	from 
		PO_HIM DI
		left join PO_HIM PO on PO.Num_Proc_him = DI.num_proc_him and PO.id_dc = '1'
	where 
		DI.numero_po_him = @DI



	
	

GO
