SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Exchange_E_AirFreight
CREATE procedure [dbo].[spATL_Exchange_E_AirFreight_Del]
(
	@ExcId				BigInt,
	@Num_Proc_Mea		varchar(14),
	@Num_Proc_Hea		varchar(16)
)
as

if exists(select ExcId from Exchange_E_AirFreight where ExcId = @ExcId and Num_Proc_Mea = @Num_Proc_Mea and Num_Proc_Hea = @Num_Proc_Hea)
	BEGIN
		delete	
			Exchange_E_AirFreight 
		where	
			ExcId = @ExcId and Num_Proc_Mea = @Num_Proc_Mea and Num_Proc_Hea = @Num_Proc_Hea	
	END			


GO
