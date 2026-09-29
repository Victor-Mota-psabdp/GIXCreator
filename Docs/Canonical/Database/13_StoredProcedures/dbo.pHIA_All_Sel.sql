SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pHIA_All_Sel 
(
@Num_Proc 		VarChar(16) 
)
AS
Select 
	Num_Proc_HIA, Num_Proc_MIA, Num_Prop_IA, Dt_Emis_HIA, HIA.Cd_Tp_Etapa, TE.Nome_Tp_Etapa, HAWB_HIA, MAWB_HIA, 
	Cd_Import_HIA, Import.Apelido as Importador, Cd_Consig_HIA, Consig.Apelido as Consignatario, 
	Cd_Export_HIA, Export.Apelido as Shipper, Voo_HIA, Cd_Org_HIA, Origem.Nome_Local as origem, 
	Cd_Dst_HIA, Destino.Nome_local as Destino, ETD_HIA, 
	ETA_HIA, Qtd_Tot_Vol_HIA, Peso_Real_HIA, Tp_Frete_HIA, HIA.Cd_Tp_Moeda, TM.Nome_Tp_Moeda, Vlr_Frete_Efet_HIA, 
	Back_Back_HIA, Cd_Sb_Ag_Int_HIA, SbAgentInt.Apelido as SbAgentInt, Cd_Sb_Ag_Nac_HIA, SbAgentNac.Apelido as SbAgentNac, 
	HIA.Cd_Tp_Prod, TP.Nome_Tp_Prod,  Prod_Perig_HIA, Prod_Perec_HIA, Cd_Dsp_HIA, Despachante.Apelido as Despachante, 
	Cli_Msq_HIA, Dt_Pri_Avs_HIA, Dt_Seg_Avs_HIA, EW_HIA, FOB_FCA_HIA, CIF_HIA, Vol_Tot_HIA, 
	Peso_Bruto_HIA, Tp_Trf_HIA, Trf_Cp_HIA, Trf_Vd_HIA, Vlr_Frete_Negoc_HIA, Dt_Rcb_Doc_HIA, 
	Dt_Etg_Doc_HIA, Obs_HIA, Cd_Tp_Oper, Dead_Line, TTime_d, TTime_h
From 
	House_Imp_Aer as HIA Left Outer Join Tipo_Etapa as TE on HIA.Cd_Tp_Etapa = TE.Cd_Tp_Etapa 
	Left Outer Join Pessoa as Import on HIA.Cd_Import_HIA = Import.Cd_Pes 
	Left Outer Join Pessoa as Consig on HIA.Cd_Consig_HIA = Consig.Cd_Pes 
	Left Outer Join Pessoa as Export on HIA.Cd_Export_HIA = Export.Cd_Pes 
	Left Outer Join Localidade as Origem on Hia.Cd_Org_HIA = Origem.Cd_local 
	Left Outer Join Localidade as Destino on Hia.Cd_Dst_HIA = Destino.Cd_local 
	Left Outer Join Tipo_Moeda as TM on HIA.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
	Left Outer Join Pessoa as SbAgentInt on HIA.Cd_Sb_Ag_Int_HIA = SbAgentInt.Cd_Pes 	
	Left Outer Join Pessoa as SbAgentNac on HIA.Cd_Sb_Ag_Nac_HIA = SbAgentNac.Cd_Pes 	
	Left Outer Join Tipo_Produto as TP on HIA.Cd_Tp_Prod = TP.Cd_Tp_Prod
	Left Outer Join Pessoa as Despachante on HIA.Cd_Dsp_HIA = Despachante.Cd_Pes
Where 
	Num_Proc_MIA = @Num_Proc and 
	Left(Num_Proc_HIA, 3) <> 'JOB'
Order by  
	Num_Proc_HIA

GO
