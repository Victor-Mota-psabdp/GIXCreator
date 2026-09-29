SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGera_HAWB_HEA]

AS
BEGIN
	
	select 
		convert(bigint, max(hawb_hea)) + 1  hawb_hea
	from 
		House_Exp_Aer
	where 
		len(hawb_hea) =  11 
		and left(hawb_hea,4) = '2201'
	
END




GO
