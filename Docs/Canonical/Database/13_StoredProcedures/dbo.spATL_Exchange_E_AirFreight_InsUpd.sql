SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Exchange_E_AirFreight
CREATE procedure [dbo].[spATL_Exchange_E_AirFreight_InsUpd]
(
	@ExcId					BigInt,
	@Num_Proc_Mea			varchar(14),
	@Num_Proc_Hea			varchar(16),
	@Num_Proc_Mea_Dt_Ins	datetime,
	@Num_Proc_Mea_Dt_Envio	datetime,
	@Num_Proc_Hea_Dt_Envio	datetime,
	@Num_Proc_Hea_Dt_Ins	datetime
)

as

	if exists(select ExcId from Exchange_E_AirFreight where ExcId = @ExcId)
		BEGIN
			Update
				Exchange_E_AirFreight
			Set
				Num_Proc_Mea_Dt_Envio = isnull(@Num_Proc_Mea_Dt_Envio,Num_Proc_Mea_Dt_Envio),
				Num_Proc_Hea_Dt_Envio = isnull(@Num_Proc_Hea_Dt_Envio,Num_Proc_Hea_Dt_Envio)
			where 
				ExcId = @ExcId
		END
	else
		BEGIN
			insert into Exchange_E_AirFreight
			(
				Num_Proc_Mea,Num_Proc_Hea,Num_Proc_Mea_Dt_Ins,Num_Proc_Mea_Dt_Envio,Num_Proc_Hea_Dt_Envio,Num_Proc_Hea_Dt_Ins
			)
			Values
			(
				@Num_Proc_Mea,@Num_Proc_Hea,@Num_Proc_Mea_Dt_Ins,@Num_Proc_Mea_Dt_Envio,@Num_Proc_Hea_Dt_Envio,@Num_Proc_Hea_Dt_Ins
			)
		END
	


GO
