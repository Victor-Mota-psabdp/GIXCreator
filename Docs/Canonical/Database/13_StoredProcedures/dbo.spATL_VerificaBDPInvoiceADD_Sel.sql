SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_VerificaBDPInvoiceADD_Sel]--'IMATL201801001BRA'
(
	@BDPInvoice varchar(17)
)

as

Select Top 1 F.FatCod from vwFaturasValidas F with(nolock) 
left join Fatura_CHB FC  with(nolock) on F.FatCod = FC.Fatura_PC
left join Fatura_CHB FCB  with(nolock) on F.FatCod = FCB.BDP_Invoice
where 
	F.FatCod = @BDPInvoice and FC.Fatura_PC is null and  (FCB.BDP_Invoice is NULL or FCB.Status_PC = 'C')
	AND F.Num_Proc = LEFT(@BDPInvoice,16) 

--option(hash join)




GO
