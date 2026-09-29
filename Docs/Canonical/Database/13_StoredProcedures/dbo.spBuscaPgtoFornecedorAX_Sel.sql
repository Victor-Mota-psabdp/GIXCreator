SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spBuscaPgtoFornecedorAX_Sel]
as
--Declare @UltimoID bigint
--set @UltimoID = (Select isnull(MAX(ID),0) ID from Pgto_Fornecedor_AX where Dt_Upd_ATL is not null)
select 		ID,
			'' Num_Proc , 
			'' Cd_Tp_Tx,
			'' DC,
			Invoice,
			AmountCur,
			AmountMST,
			LastSettleDate DueDate,
			'' ExchRate,
			OrigVoucher,
			Voucher,
			Canceled,
			''[Status]
from Pgto_Fornecedor_AX wiht(nolock)
where [Dt_Upd_ATL] is null



GO
