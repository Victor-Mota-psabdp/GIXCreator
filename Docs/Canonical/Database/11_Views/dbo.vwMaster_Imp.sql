SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwMaster_Imp]

AS
	select 
		Num_Proc_MIA	[Num_Proc_MAS],
		Dt_Emis_MIA		[Dt_Emis_MAS], 
		MAWB_MIA		[MAWB_MAS],
		Cd_Consig_MIA	[Cd_Consig_MAS],
		Cd_Export_MIA	[Cd_Export_MAS],
		Cd_Org_MIA		[Cd_Org_MAS],
		Cd_Dst_MIA		[Cd_Dst_MAS],
		Qtd_Tot_Vol_MIA	[Qtd_Tot_Vol_MAS],
		Peso_Bruto_MIA	[Peso_Bruto_MAS],
		Tp_Frete_MIA	[Tp_Frete_MAS],
		Cd_Tp_Moeda		[Cd_Tp_Moeda_MAS],
		Vlr_Frete_MIA	[Vlr_Frete_MAS],
		Qtd_HAWB_MIA	[Qtd_HAWB_MAS],
		Ref_Int_MIA		[Ref_Int_MAS],
		Nivel_DL		[Nivel_DL_MAS],
		Obs_MIA			[Obs_MAS]
	from Master_Imp_Aer with(nolock)

Union all

	select 
		Num_Proc_MIM	[Num_Proc_MAS],
		Dt_Emis_MIM		[Dt_Emis_MAS], 
		MAWB_MIM		[MAWB_MAS],
		Cd_Consig_MIM	[Cd_Consig_MAS],
		Cd_Export_MIM	[Cd_Export_MAS],
		Cd_Org_MIM		[Cd_Org_MAS],
		Cd_Dst_MIM		[Cd_Dst_MAS],
		Qtd_Tot_Vol_MIM	[Qtd_Tot_Vol_MAS],
		Peso_Bruto_MIM	[Peso_Bruto_MAS],
		Tp_Frete_MIM	[Tp_Frete_MAS],
		Cd_Tp_Moeda		[Cd_Tp_Moeda_MAS],
		Vlr_Frete_MIM	[Vlr_Frete_MAS],
		Qtd_HAWB_MIM	[Qtd_HAWB_MAS],
		Ref_Int_MIM		[Ref_Int_MAS],
		Nivel_DL		[Nivel_DL_MAS],
		Obs_MIM			[Obs_MAS]
	from Master_Imp_Mar with(nolock)
GO
