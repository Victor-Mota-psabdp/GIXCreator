SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--IM = P000015744	- BDP SAO PAUL - 223C
--IA = P000015744	- BDP SAO PAUL - 223C
--EA = 10017 - BDP (SÃO PAULO)
--EM = P000018660	- BDP SANTOS - 2073C
--select * from Pessoa where cd_pes = 'P000018660'
CREATE PROCEDURE [dbo].[spMasterByJOB_Sel]--'EAATL202010001BR'
(
	@Num_Job	VarChar(16)
)
AS
	Select  
		HOU.Tipo_Frete,
		HOU.MAWB,
		HOU.ETD,
		HOU.ATD,
		HOU.ETA,
		HOU.ATA,
		HOU.Qtd_Vol,
		HOU.Frete_BL,
		HOU.Original_ETA,
		Orig.Nome_Local 		Loading,
		Destin.Nome_Local		Delivery,
		HOU.CarrierName			Carrier_Name,
		HOU.Vessel,
		HOU.Viagem,
		TC.Nome_Tp_Carga		TypeCargo,
		TM.Nome_Tp_Moeda		Currency,
		Consig.Apelido 			Consignee,
		Notify.Apelido 			Notify,
		Shipper.Apelido				Shipper,
		HOU.MASTER				Ref_Consolidada
		
	From  
		vwHouse_Imp  HOU with(nolock)
		Left Outer Join Localidade		Orig	with(nolock)	on HOU.Cd_Org		= Orig.Cd_Local 
		Left Outer Join Localidade		Destin	with(nolock)	on HOU.Cd_Dst		= Destin.Cd_Local 
		Left Outer Join Tipo_Carga		TC		with(nolock)	on HOU.Tp_Carga		= TC.Cd_Tp_Carga
		Left Outer Join Tipo_Moeda		TM		with(nolock)	on HOU.Moeda_Frete	= TM.Cd_Tp_moeda		
		Left Outer Join Campo_Processo	CP208	with(nolock)	on HOU.Num_Proc	= CP208.Num_Proc and CP208.id_campo = 208
		Left Outer Join Pessoa			Consig	with(nolock)	on Consig.Cd_Pes	=  isnull(CP208.campo_dados,'P000015744')
		Left Outer Join Pessoa			Notify	with(nolock)	on Notify.Cd_Pes	=   isnull(CP208.campo_dados,'P000015744')
		Left Outer Join Campo_Processo	CP209	with(nolock)	on HOU.Num_Proc	= CP209.Num_Proc and CP209.id_campo = 209
		Left Outer Join Pessoa			Shipper	with(nolock)	on Shipper.Cd_Pes	= CP209.campo_dados
	Where
		HOU.Num_Proc = @Num_Job

	union all

	Select  
		HOU.Tipo_Frete,
		HOU.MAWB,
		HOU.ETD,
		HOU.ATD,
		HOU.ETA,
		HOU.ATA,
		HOU.Qtd_Vol,
		HOU.Frete_BL,
		HOU.Original_ETA,
		Orig.Nome_Local 		Loading,
		Destin.Nome_Local		Delivery,
--		isnull(ARM.Nome_Armador,Nome_Cia_Aer)	Carrier_Name,
		(Case when left(HOU.Num_Proc,2) = 'EA' then cia.Nome_Cia_Aer	else
		ARM.Nome_Armador end)	Carrier_Name,
		HOU.Vessel,
		HOU.Viagem,
		TC.Nome_Tp_Carga		TypeCargo,
		TM.Nome_Tp_Moeda		Currency,
		Consig.Apelido 			Consignee,
		Notify.Apelido 			Notify,
		(Case when left(HOU.Num_Proc,2) = 'EA' then ShipperEA.Apelido	else
		Shipper.Apelido	end)	Shipper,
		HOU.MASTER				Ref_Consolidada
		
	From  
		vwHouse_Exp  HOU with(nolock)
		Left Outer Join Localidade		Orig	with(nolock)	on HOU.Cd_Org		= Orig.Cd_Local 
		Left Outer Join Localidade		Destin	with(nolock)	on HOU.Cd_Dst		= Destin.Cd_Local 
		Left Outer Join Tipo_Carga		TC		with(nolock)	on HOU.Cd_Tp_Carga		= TC.Cd_Tp_Carga
		Left Outer Join Tipo_Moeda		TM		with(nolock)	on HOU.Moeda_Frete	= TM.Cd_Tp_moeda
		Left Outer Join Armador			ARM		with(nolock)	on HOU.CD_Armador	= ARM.CD_Armador
		Left Outer Join Cia_Aerea		CIA		with(nolock)	on HOU.CD_Armador	= CIA.Cd_Cia_Aer
		Left Outer Join Campo_Processo	CP208	with(nolock)	on HOU.Num_Proc	= CP208.Num_Proc and CP208.id_campo = 208
		Left Outer Join Pessoa			Consig	with(nolock)	on Consig.Cd_Pes	=  CP208.campo_dados
		Left Outer Join Pessoa			Notify	with(nolock)	on Notify.Cd_Pes	=  CP208.campo_dados
		Left Outer Join Campo_Processo	CP209	with(nolock)	on HOU.Num_Proc	= CP209.Num_Proc and CP209.id_campo = 209
		Left Outer Join Pessoa			Shipper	with(nolock)	on Shipper.Cd_Pes	=  isnull(CP209.campo_dados,'P000018660')
		Left Outer Join Pessoa		ShipperEA	with(nolock)	on ShipperEA.Cd_Pes	=  isnull(CP209.campo_dados,'10017')
	Where
		HOU.Num_Proc = @Num_Job
GO
