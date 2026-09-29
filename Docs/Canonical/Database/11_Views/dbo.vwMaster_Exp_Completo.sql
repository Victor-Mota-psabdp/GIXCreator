SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwMaster_Exp_Completo]

AS
	select		
		M.Num_Proc_MEA		[Num_Proc_Master],
		M.Dt_Emis_MEA		[Dt_Emis_Master],
		'Air Export'		[Modal_Master], 
		M.Obs_MEA			[Notas_Master],
		M.MAWB_MEA			[MAWB_Master],
		LLP.ATA_Master		[ATA_Master],
		LLP.ATD_Master		[ATD_Master],
		LLP.ETA_Master		[ETA_Master],
		LLP.ETD_Master		[ETD_Master],
		(CASE WHEN M.Tp_Frete_MEA = 'P' THEN 'Prepaid' ELSE 'Collect' END) [Tipo_Frete_Master], 
		M.Cd_Consig_MEA		[Cd_Consig_Master],
		M.Cd_Export_MEA		[Cd_Export_Master],
		M.Cd_Org_MEA		[Cd_Org_Master],
		M.Cd_Dst_MEA		[Cd_Dst_Master],
		M.Qtd_Tot_Vol_MEA	[Qtd_Tot_Vol_Master],
		M.Peso_Bruto_MEA	[Peso_Bruto_Master],
		M.Tp_Frete_MEA		[Tp_Frete_Master],
		M.Cd_Tp_Moeda		[Cd_Tp_Moeda_Master],
		M.Vlr_Frete_MEA		[Vlr_Frete_Master],
		M.Qtd_HAWB_MEA		[Qtd_HAWB_Master],
		M.Refer_Cons_MEA	[Ref_Int_Master],
		M.Nivel_DL			[Nivel_DL_Master]
		,LLP.ID_Status		[ID_Status_Master]
	from Master_Exp_Aer M with(nolock)
		join LLP_Master LLP WITH (nolock) ON LLP.num_proc_master =M.Num_Proc_MEA

Union all

	select 
		M.Num_Proc_MEM		[Num_Proc_Master],
		M.Dt_Emis_MEM		[Dt_Emis_Master],
		'Ocean Export'		[Modal_Master], 
		M.Obs_MEM			[Notas_Master],
		M.MAWB_MEM			[MAWB_Master],
		LLP.ATA_Master		[ATA_Master],
		LLP.ATD_Master		[ATD_Master],
		LLP.ETA_Master		[ETA_Master],
		LLP.ETD_Master		[ETD_Master],
		(CASE WHEN M.Tp_Frete_MEM = 'P' THEN 'Prepaid' ELSE 'Collect' END) [Tipo_Frete_Master], 
		Cd_Consig_MEM		[Cd_Consig_MAS],
		Cd_Export_MEM		[Cd_Export_MAS],
		Cd_Org_MEM			[Cd_Org_MAS],
		Cd_Dst_MEM			[Cd_Dst_MAS],
		Qtd_Tot_Vol_MEM		[Qtd_Tot_Vol_MAS],
		Peso_Bruto_MEM		[Peso_Bruto_MAS],
		Tp_Frete_MEM		[Tp_Frete_MAS],
		Cd_Tp_Moeda			[Cd_Tp_Moeda_MAS],
		Vlr_Frete_MEM		[Vlr_Frete_MAS],
		Qtd_HAWB_MEM		[Qtd_HAWB_MAS],
		NULL				[Ref_Int_MAS],
		Nivel_DL			[Nivel_DL_MAS]
		,LLP.ID_Status		[ID_Status_Master]
	from Master_Exp_Mar M with(nolock)
		join LLP_Master LLP WITH (nolock) ON LLP.num_proc_master =M.Num_Proc_MEM

GO
