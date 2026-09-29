SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spARG_AirlineStock_Sel]
(
	@Type as int = null,
	@CdCia as varchar(20) = null
)
AS 
	BEGIN
	/* Type
		1=Avilable
		2=Used
		3=All*/
		Select
			als.IdAirlineStock
			,als.Cd_Cia_Aer
			,als.Number
			,als.Proc_num
			,als.CreaeDate
		From
			AirlineStock Als With(nolock)
		Where 
			(@CdCia IS NULL or als.Cd_Cia_Aer = @CdCia)
			AND 
			(
				@Type=3 or 
					(
						@Type=1 and (als.Proc_num is null or als.Proc_num ='')
					) 
					OR 
					(
						@Type=2 and (als.Proc_num is not null or als.Proc_Num<>'')
					)
			)

	END
GO
