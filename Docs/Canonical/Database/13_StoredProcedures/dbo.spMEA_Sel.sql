SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spMEA_Sel] --'IMGIG200901029'
(
@Num_Proc	VarChar(14)
)
AS
	Select
		MAS.Dt_Emis_MEA,
		MAS.MAWB_MEA,
		MAS.Qtd_HAWB_MEA		Qtd_HOUs,
		Ship.Apelido 			Shipper,
		Consig.Apelido 			Consignee,
		NTF.Apelido 			Notify,
		Orig.Nome_Local 		Origem,
		Destin.Nome_Local 		Destino,
		CAR.Nome_Cia_Aer		Carrier,
		MAS.Voo_MEA 			Viagem,
		LLP.ETD_Master			ETD,
		LLP.ATD_Master			ATD,
		LLP.ETA_Master			ETA,
		LLP.ATA_Master			ATA,
		TC.Nome_Tp_Carga		Tipo_Carga,
		LLP.Peso_Liquido		PesoLiquido,
		MAS.Peso_Bruto_MEA		PesoBruto,
		LLP.Peso_Cubado			PesoCubado,
		MAS.Vol_Tot_MEA			Volume,
		MAS.Qtd_Tot_Vol_MEA		Qtd,
		TM.Nome_Tp_Moeda		Moeda,
		MAS.Vlr_Frete_MEA		Frete,
		MAS.Tp_Frete_MEA		TipoFrete,
		LLP.Original_ETA_Master	Original_ETA,
		MAS.Obs_MEA				OBS,
		LLP.Tipo,
		NG.Descr				Descr_Goods,
		--Incluso 31-08-2012 - Status do Processo
		Status_Descricao Status_Job,
		LLP.ID_Status	ID_Status
	From
		Master_Exp_Aer  MAS
		Left Join LLP_Master		LLP		on MAS.Num_Proc_MEA	= LLP.Num_Proc_Master
		Left Join Pessoa			Ship	on Cd_Export_MEA 	= Ship.Cd_Pes
		Left Join Pessoa			Consig	on Cd_Consig_MEA 	= Consig.Cd_Pes
		Left Join Pessoa			NTF		on LLP.Cd_Notify 	= NTF.Cd_Pes
		Left Join Localidade		Orig	on Cd_Org_MEA 		= Orig.Cd_Local
		Left Join Localidade		Destin	on Cd_Dst_MEA 		= Destin.Cd_Local
		Left Join Cia_Aerea			CAR		on MAS.Cd_Cia_Aer	= CAR.Cd_Cia_Aer
		Left Join Tipo_Moeda		TM		on MAS.Cd_Tp_Moeda 	= TM.Cd_Tp_Moeda
		Left Join Tipo_Carga		TC		on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
		Left Join Nature_Goods		NG		on NG.Num_Proc		= MAS.Num_Proc_MEA
		Left Outer Join Tipo_Status_Processo Status on STatus.id_status=LLP.id_status
	Where
		MAS.Num_Proc_MEA = @Num_Proc and (LLP.Status is null or LLP.Status <> 'C') -- Cancelado




GO
