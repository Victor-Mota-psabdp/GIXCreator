SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_MEM_Sel] --'IMGIG200901029'
(
	@Num_Proc_Master	VarChar(14),
	@Tipo		char(1)
)
AS
	Select
		MAS.Num_Proc_MEM						[JOB Master],
		convert(datetime, MAS.Dt_Emis_MEM,103)	[Register Date],
		MAS.MAWB_MEM							[MAWB Number],
		MAS.Qtd_HAWB_MEM						[Qty House],
		Modal.cd_tp_modal						[Modal Code],
		Modal.Nome_Tp_Modal						[Modal Name],
		MAS.Cd_Export_MEM						[Shipper Code],
		Ship.Apelido 							[Shipper Name],
		MAS.Cd_Consig_MEM						[Consignee Code],
		Consig.Apelido 							[Consignee Name],
		LLP.Cd_Notify							[Notify Code],
		NTF.Apelido 							[Notify Name],
		MAS.Cd_Org_MEM							[Loading Code],
		Orig.Nome_Local 						[Loading Name],
		MAS.cd_Dst_MEM							[Discharge Code],
		Destin.Nome_Local 						[Discharge Name],
		MAS.Cd_Armador							[Carrier Code],
		ARM.Nome_Armador						[Carrier Name],
		LLP.Num_Viagem 							[Voyage],
		LLP.Navio								[Vessel],
		LLP.ETD_Master							[ETD],
		LLP.ATD_Master							[ATD],
		LLP.ETA_Master							[ETA],
		LLP.ATA_Master							[ATA],
		LLP.Cd_Tp_Carga							[Cargo Type Code],
		TC.Nome_Tp_Carga						[Cargo Type Name],
		LLP.Peso_Liquido						[Net Weight (KG)],
		MAS.Peso_Bruto_MEM						[Gross Weight (KG)],	
		MAS.Vol_Tot_MEM							[Volume(m3)],
		MAS.Qtd_Tot_Vol_MEM						[Nº of Pieces],
		MAS.Cd_Tp_Moeda							[Currency Code],
		TM.Nome_Tp_Moeda						[Currency Name],	
		MAS.Vlr_Frete_MEM						[Freight Value],
		MAS.Tp_Frete_MEM						[Freight Term Code],
		FreteType.Nome_Tp_Frete					[Freight Term Name],	
		LLP.Original_ETA_Master					[Original ETA],
		MAS.Obs_MEM								[Nature and Quality of Goods],
		LLP.Status								[Type Status Master Code],
		StatusMaster.Nome_Tp_Status_Master		[Type Status Master Name],
		LLP.Tipo								[Type Master Code],
		TipoMaster.Nome_Tp_Master				[Type Master Name],
		NG.Descr								[Description and Goods],	
		LLP.id_status							[Status Code],
		Status.Status_Descricao 				[Status Name],
		LLP.cd_usuario							[Customer Code],
		US.Nome_usuario							[Customer Name],

		LLP.ID_Viagem							[Voyage Code],
		VL.Nr_Viagem							[Voyage Number],
		VL.Id_Navio								[Vessel Code],
		NL.Nome_Navio							[Vessel Name]
	From  
		Master_Exp_Mar  MAS
		Left Join LLP_Master		LLP		with(nolock) on MAS.Num_Proc_MEM	collate Latin1_General_CI_AI = LLP.Num_Proc_Master collate Latin1_General_CI_AI
		Left Join Pessoa			Ship	with(nolock) on Cd_Export_MEM 	= Ship.Cd_Pes
		Left Join Pessoa			Consig	with(nolock) on Cd_Consig_MEM 	= Consig.Cd_Pes
		Left Join Pessoa			NTF		with(nolock) on LLP.Cd_Notify 	collate Latin1_General_CI_AI = NTF.Cd_Pes collate Latin1_General_CI_AI
		Left Join Localidade		Orig	with(nolock) on Cd_Org_MEM 		= Orig.Cd_Local
		Left Join Localidade		Destin	with(nolock) on cd_Dst_MEM = Destin.Cd_Local
		Left Join Armador			ARM		with(nolock) on MAS.Cd_Armador	collate Latin1_General_CI_AI = ARM.Cd_Armador collate Latin1_General_CI_AI
		Left Join Tipo_Moeda		TM		with(nolock) on MAS.Cd_Tp_Moeda 	collate Latin1_General_CI_AI = TM.Cd_Tp_Moeda collate Latin1_General_CI_AI
		Left Join Tipo_Carga		TC		with(nolock) on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga 		
		Left Join Nature_Goods		NG		with(nolock) on NG.Num_Proc collate Latin1_General_CI_AI = MAS.Num_Proc_MEM collate Latin1_General_CI_AI
		Left Join Tipo_Status_Processo Status with(nolock) on STatus.id_status=LLP.id_status
		Left Join Tipo_Frete FreteType with(nolock) on FreteType.cd_tp_frete=MAS.Tp_Frete_MEM
		Left Join Tipo_Modal_Imp_Exp Modal with(nolock) on Modal.cd_tp_modal	= left(MAS.Num_Proc_MEM,2)
		Left Join Tipo_Master TipoMaster with(nolock) on 	LLP.Tipo = TipoMaster.Cd_Tp_Master
		Left Join Tipo_Status_Master StatusMaster with(nolock) on  StatusMaster.Cd_Tp_Status_Master=LLP.Status
		Left Join Usuario			US	with(nolock) on LLP.cd_usuario = US.cd_usuario

		Left Join Viagem_LLP		VL	with(nolock) on LLP.ID_Viagem = VL.Id_viagem
		Left Join Navio_LLP			NL  with(nolock) on VL.Id_Navio = NL.Id_Navio

	Where
		MAS.Num_Proc_MEM = @Num_Proc_Master and (LLP.Status is null or LLP.Status <> 'C') -- Cancelado























GO
