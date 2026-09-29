SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_MEA_Sel] --'IMGIG200901029'
(
	@Num_Proc_Master	VarChar(14),
	@Tipo		char(1)
)
AS
	
	Select
		MAS.Num_Proc_MEA						[JOB Master],
		convert(datetime, MAS.Dt_Emis_MEA,103)	[Register Date],
		MAS.MAWB_MEA							[MAWB Number],
		MAS.Qtd_HAWB_MEA						[Qty House],
		Modal.cd_tp_modal						[Modal Code],
		Modal.Nome_Tp_Modal						[Modal Name],	
		MAS.Cd_Export_MEA						[Shipper Code],
		Ship.Apelido 							[Shipper Name],
		MAS.Cd_Consig_MEA						[Consignee Code],
		Consig.Apelido 							[Consignee Name],
		LLP.Cd_Notify							[Notify Code],
		NTF.Apelido 							[Notify Name],
		MAS.Cd_Org_MEA							[Loading Code],
		Orig.Nome_Local 						[Loading Name],
		MAS.cd_Dst_MEA							[Discharge Code],
		Destin.Nome_Local 						[Discharge Name],
		MAS.Cd_Cia_Aer							[Air Company Code],
		ARM.Nome_Cia_Aer						[Air Company Name],
		MAS.Voo_MEA 							[Voyage],
		LLP.ETD_Master							[ETD],
		LLP.ATD_Master							[ATD],
		LLP.ETA_Master							[ETA],
		LLP.ATA_Master							[ATA],
		LLP.Cd_Tp_Carga							[Cargo Type Code],
		TC.Nome_Tp_Carga						[Cargo Type Name],
		LLP.Peso_Liquido						[Net Weight (KG)],
		MAS.Peso_Bruto_MEA						[Gross Weight (KG)],
		LLP.Peso_Cubado							[Charg. Weight (KG)],
		''										[Volume(m3)],
		MAS.Qtd_Tot_Vol_MEA						[Nº of Pieces],
		MAS.Cd_Tp_Moeda							[Currency Code],
		TM.Nome_Tp_Moeda						[Currency Name],	
		MAS.Vlr_Frete_MEA						[Freight Value],
		MAS.Tp_Frete_MEA						[Freight Term Code],
		FreteType.Nome_Tp_Frete					[Freight Term Name],	
		LLP.Original_ETA_Master					[Original ETA],
		MAS.Obs_MEA								[Nature and Quality of Goods],
		LLP.Status								[Type Status Master Code],
		StatusMaster.Nome_Tp_Status_Master		[Type Status Master Name],
		LLP.Tipo								[Type Master Code],
		TipoMaster.Nome_Tp_Master				[Type Master Name],
		NG.Descr								[Description and Goods],	
		LLP.id_status							[Status Code],
		Status.Status_Descricao 				[Status Name],
		LLP.cd_usuario							[Customer Code],
		US.Nome_usuario							[Customer Name]
	From  
		Master_Exp_Aer  MAS
		Left Join LLP_Master		LLP		with(nolock) on MAS.Num_Proc_MEA	collate Latin1_General_CI_AI = LLP.Num_Proc_Master collate Latin1_General_CI_AI
		Left Join Pessoa			Ship	with(nolock) on MAS.Cd_Export_MEA 	= Ship.Cd_Pes
		Left Join Pessoa			Consig	with(nolock) on MAS.Cd_Consig_MEA 	= Consig.Cd_Pes
		Left Join Pessoa			NTF		with(nolock) on LLP.Cd_Notify 	collate Latin1_General_CI_AI = NTF.Cd_Pes collate Latin1_General_CI_AI
		Left Join Localidade		Orig	with(nolock) on MAS.Cd_Org_MEA 	= Orig.Cd_Local
		Left Join Localidade		Destin	with(nolock) on MAS.cd_Dst_MEA = Destin.Cd_Local
		Left Join Cia_Aerea			ARM		with(nolock) on MAS.Cd_Cia_Aer	= ARM.Cd_Cia_Aer
		Left Join Tipo_Moeda		TM		with(nolock) on MAS.Cd_Tp_Moeda 	collate Latin1_General_CI_AI = TM.Cd_Tp_Moeda collate Latin1_General_CI_AI
		Left Join Tipo_Carga		TC		with(nolock) on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga 		
		Left Join Nature_Goods		NG		with(nolock) on MAS.Num_Proc_MEA collate Latin1_General_CI_AI = NG.Num_Proc collate Latin1_General_CI_AI
		Left Outer Join Tipo_Status_Processo Status with(nolock) on  Status.id_status=LLP.id_status
		Left Outer Join Tipo_Frete FreteType with(nolock) on MAS.Tp_Frete_MEA = FreteType.cd_tp_frete
		Left Outer Join Tipo_Modal_Imp_Exp Modal with(nolock)	on Modal.cd_tp_modal	= left(MAS.Num_Proc_MEA,2)
		Left Outer Join Tipo_Master TipoMaster with(nolock) on 	LLP.Tipo = TipoMaster.Cd_Tp_Master
		Left Outer Join Tipo_Status_Master StatusMaster with(nolock) on  StatusMaster.Cd_Tp_Status_Master=LLP.Status
		Left Join Usuario		Us	with(nolock) on LLP.cd_usuario = US.cd_usuario
		
	Where
		MAS.Num_Proc_MEA = @Num_Proc_Master and (LLP.Status is null or LLP.Status <> 'C') -- Cancelado
	


GO
