SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure spAtualizaRentJob_Temp
as

Declare @Num_Proc	Varchar(16)
Declare cTemp cursor for

--Select distinct num_proc_hia from vwcta_cte cc
--Left Join vwcliente c on cc.num_proc_hia=c.num_proc
--where data between '04-01-2012' and '04-30-2012'
select Num_Proc from vwcliente with(nolock)
---and num_proc_mem ='JOB' and substring(num_proc_hem,3,3) <> 'JOB'

open cTemp

			Fetch Next From cTemp Into @Num_Proc
			While @@FETCH_STATUS = 0
				Begin 
					print @Num_Proc
					--exec spATLSimulaRent_Sel @Num_Proc
					exec	spInseriResultadoJob_Temp @Num_Proc
					Fetch Next From cTemp Into @Num_Proc
				End

GO
