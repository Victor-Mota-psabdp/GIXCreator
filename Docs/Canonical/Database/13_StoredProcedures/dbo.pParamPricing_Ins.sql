SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pParamPricing_Ins  
(
@PprPercLucMin		Float, 
@PprPercLuxMax		Float, 
@PprPercPrej			Float
) 
AS
	if not exists(Select * From Param_Pricing)
		Insert Into Param_Pricing (PprPercLucMin, PprPercLuxMax, PprPercPrej) Values (@PprPercLucMin, @PprPercLuxMax, @PprPercPrej) 
	Else
		Update 
			Param_Pricing
		Set 
			PprPercLucMin = @PprPercLucMin, 
			PprPercLuxMax = @PprPercLuxMax, 
			PprPercPrej = @PprPercPrej

GO
