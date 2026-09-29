SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spExchange_E_AirFreight_Sel] 'ZFWB_Waybill'
--[spExchange_E_AirFreight_Sel] 'XFZB_HouseWaybill'

CREATE PROCEDURE [dbo].[spExchange_E_AirFreight_Sel]
(
	@Type varchar(50)
)
	
AS

if @Type = 'ZFWB_Waybill'
	BEGIN
		select
			MEA.Num_Proc_MEA,
			HOU.MAWB_HEA,
			E.ExcId
	from
		Exchange_E_AirFreight e
		left Join house_exp_Aer HOU on E.Num_Proc_Hea = HOU.Num_Proc_HEA
		left Join Master_Exp_Aer MEA on E.Num_Proc_Mea = MEA.Num_Proc_MEA
	where	
		E.Num_Proc_MEA_DT_Envio is null 		
		and Num_Proc_Mea_Dt_Ins > getdate() -31
	END

if @type = 'XFZB_HouseWaybill'
	BEGIN
		select
			HOU.Num_Proc_HEA,
			HOU.HAWB_HEA,
			E.ExcId
		from
			Exchange_E_AirFreight e
			left Join house_exp_Aer HOU on E.Num_Proc_Hea = HOU.Num_Proc_HEA
			left Join Master_Exp_Aer MEA on E.Num_Proc_Mea = MEA.Num_Proc_MEA
		where
			E.Num_Proc_HEA_DT_Envio is null 
			and Num_Proc_Hea_Dt_Ins  > getdate() -31
			and len(HOU.HAWB_HEA) > 8
	END








GO
