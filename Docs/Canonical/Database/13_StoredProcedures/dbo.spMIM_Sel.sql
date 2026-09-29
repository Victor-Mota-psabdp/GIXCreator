SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMIM_Sel] --'IMGIG200901029'
(
@Num_Proc	VarChar(14)
)
AS
	Select
		MAS.Dt_Emis_MIM,
		MAS.MAWB_MIM,
		MAS.Qtd_HAWB_MIM		Qtd_HOUs,
		Ship.Apelido 			Shipper,
		Consig.Apelido 			Consignee,
		NTF.Apelido 			Notify,
		Orig.Nome_Local 		Origem,
		Destin.Nome_Local 		Destino,
		ARM.Nome_Armador		Carrier,
		MAS.Viagem_MIM 			Viagem,
		MAS.Navio_MIM 			Navio,
		LLP.ETD_Master			ETD,
		LLP.ATD_Master			ATD,
		LLP.ETA_Master			ETA,
		LLP.ATA_Master			ATA,
		TC.Nome_Tp_Carga		Tipo_Carga,
		LLP.Peso_Liquido		PesoLiquido,
		MAS.Peso_Bruto_MIM		PesoBruto,
		MAS.Vol_Tot_MIM			Volume,
		MAS.Qtd_Tot_Vol_MIM		Qtd,
		TM.Nome_Tp_Moeda		Moeda,
		MAS.Vlr_Frete_MIM		Frete,
		MAS.Tp_Frete_MIM		TipoFrete,
		LLP.Original_ETA_Master	Original_ETA,
		MAS.Obs_MIM				OBS,
		LLP.Tipo,
		NG.Descr				Descr_Goods,
		--Incluso 31-08-2012 - Status do Processo
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status,
		LLP.ID_Viagem	ID_Viagem
	From  
		Master_Imp_Mar  MAS
		Left Join LLP_Master		LLP		on MAS.Num_Proc_MIM	collate Latin1_General_CI_AI = LLP.Num_Proc_Master collate Latin1_General_CI_AI
		Left Join Pessoa			Ship	on Cd_Export_MIM 	= Ship.Cd_Pes
		Left Join Pessoa			Consig	on Cd_Consig_MIM 	= Consig.Cd_Pes
		Left Join Pessoa			NTF		on LLP.Cd_Notify 	collate Latin1_General_CI_AI = NTF.Cd_Pes collate Latin1_General_CI_AI
		Left Join Localidade		Orig	on Cd_Org_MIM 		= Orig.Cd_Local
		Left Join Localidade		Destin	on cd_Dst_mim = Destin.Cd_Local
		Left Join Armador			ARM		on MAS.Cd_Armador	collate Latin1_General_CI_AI = ARM.Cd_Armador collate Latin1_General_CI_AI
		Left Join Tipo_Moeda		TM		on MAS.Cd_Tp_Moeda 	collate Latin1_General_CI_AI = TM.Cd_Tp_Moeda collate Latin1_General_CI_AI
		Left Join Tipo_Carga		TC		on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga 		Left Join Nature_Goods		NG		on NG.Num_Proc collate Latin1_General_CI_AI = MAS.Num_Proc_MIM collate Latin1_General_CI_AI
		Left Outer Join Tipo_Status_Processo Status on STatus.id_status=LLP.id_status
	Where
		MAS.Num_Proc_MIM = @Num_Proc and (LLP.Status is null or LLP.Status <> 'C') -- Cancelado























GO
