SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pMEA_Sel 
(
@Num_Proc 		VarChar(14) 
)
AS
	Select 
		Num_Proc_MEA, Dt_Emis_MEA, MAWB_MEA, Voo_MEA, Dt_Saida_MEA, Cd_Consig_MEA, 
		Consig.Apelido as Consignatario, Cd_Export_MEA, Export.Apelido as Shipper, 
		Cd_Org_MEA, Origem.Nome_Local as Origem, Cd_Dst_MEA, Destino.Nome_Local as Destino, 
		MEA.Cd_Cia_Aer, Cia.Nome_Cia_Aer as CIA, Trf_Net_MEA, Qtd_Tot_Vol_MEA, Peso_Bruto_MEA, Tp_Frete_MEA, 
		MEA.Cd_Tp_Moeda, TM.Nome_Tp_Moeda, Vlr_Frete_MEA, Qtd_HAWB_MEA, 
		MEA.Nivel_DL,  Perc_DL, Obs_MEA, Cd_Gat_MEA, Gateway.Nome_Local as GateWay,
		MEA.Tx_Refer_MEA, MEA.Peso_Tax_MEA, Refer_Cons_MEA, Dt_Impres_MEA, Consig_Acc_MEA, ETD_MEA, ETA_MEA
	From 
		Master_Exp_Aer as MEA Left Outer Join Pessoa as Consig on MEA.Cd_Consig_MEA = Consig.Cd_Pes 
		Left Outer Join Pessoa as Export on MEA.Cd_Export_MEA = Export.Cd_Pes 
		Left Outer Join Localidade as Origem on MEA.Cd_Org_MEA = Origem.Cd_Local 
		Left Outer Join Localidade as Destino on MEA.Cd_Dst_MEA = Destino.Cd_Local 
		Left Outer Join Localidade as GateWay on MEA.Cd_Gat_MEA = GateWay.Cd_Local 

		Left Outer Join Cia_Aerea as Cia on MEA.Cd_Cia_Aer = Cia.Cd_Cia_Aer
		Left Outer Join Tipo_Moeda as TM on MEA.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Left Outer Join Div_Lucro as DL on MEA.Nivel_DL = DL.Nivel_DL
	Where
		Num_Proc_MEA = @Num_Proc

GO
