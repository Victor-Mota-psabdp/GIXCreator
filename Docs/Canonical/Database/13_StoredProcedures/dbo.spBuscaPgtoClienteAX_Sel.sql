SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spBuscaPgtoClienteAX_Sel]

as
Declare @UltimoID bigint

--set @UltimoID = (Select isnull(MAX(ID),0) ID from Pgto_Cliente_AX where Dt_Upd_ATL is not null)




select 
			ID,
			'' Num_Proc , 
			'' Cd_Tp_Tx,
			'' DC,
			Invoice,
			AmountCur,
			AmountMST,
			LastSettleDate DueDate,
			--cast(abs(convert(decimal(18,2),replace(AmountMST,',','.'))) / abs(convert(decimal(18,2),replace(AmountCur,',','.'))) as decimal(18,2)) ExchRate,
			''ExchRate,
			RecId OrigVoucher,
			Voucher,
			Canceled,
			''[Status]
from Pgto_Cliente_AX with(nolock)
where  [Dt_Upd_ATL] is null
		--LastSettleDate is not null and
		--and abs(convert(decimal(18,2),replace(AmountMST,',','.'))) > 0 
		--and abs(convert(decimal(18,2),replace(AmountCur,',','.')))> 0 
		--and Invoice like '%.%' and Invoice not like '%-%' 
		
/*
select * from  Pgto_Cliente_AX
where id = '344351'
where Dt_Upd_ATL is NULL
where isnumeric(AmountMST) = true
*/
GO
