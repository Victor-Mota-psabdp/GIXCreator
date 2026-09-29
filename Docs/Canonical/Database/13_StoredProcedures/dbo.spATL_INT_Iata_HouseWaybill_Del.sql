SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_INT_Iata_HouseWaybill_Del]
(		
	@Num_Proc 	VarChar(16)
)	
AS

Begin Transaction

IF exists(select Num_Proc from ATL_INT.dbo.Iata_HouseWaybill_IncludedCustomsNote where Num_Proc = @Num_Proc)
	BEGIN
		Delete
			[ATL_INT].[dbo].Iata_HouseWaybill_IncludedCustomsNote
		where
			Num_Proc = @Num_Proc		
	END

IF exists(select Num_Proc from ATL_INT.dbo.Iata_HouseWaybill where Num_Proc = @Num_Proc)
	BEGIN	
		Delete
			ATL_INT.dbo.Iata_HouseWaybill
		where
			Num_Proc = @Num_Proc
	END

Commit Transaction

GO
