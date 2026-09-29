SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FBusca_Prestacao](
			@Num_Proc Varchar(16)
			
			
		)returns Datetime
AS 

BEGIN

	return(
			select 
				MAx(data_pc) 
			from 
				fatura_chb FC
				join fatura F on F.FatCod=Fatura_PC
			where 
				processo_pc=@Num_Proc)

END
GO
