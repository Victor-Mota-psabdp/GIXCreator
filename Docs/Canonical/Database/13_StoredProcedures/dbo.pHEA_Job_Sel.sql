SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pHEA_Job_Sel
(
@Num_Proc 	VarChar(16)=''
)
As
If @Num_Proc = ''
	Select 
		HEA.Num_Proc_HEA, Num_Proc_MEA, Num_Prop_EA, Dt_Emis_HEA, HAWB_HEA, 
		Cd_Consig_HEA, Consig.Apelido as Consignatario, Cd_Export_HEA, 
		Export.Apelido as Shipper, Cd_Notify_HEA, Notify.Apelido as Notify, Voo_HEA, 
		Cd_Org_HEA, Origem.Nome_Local as Origem, Cd_Dst_HEA, Destino.Nome_Local as Destino, 
		ETD_HEA, ETA_HEA, Qtd_Tot_Vol_HEA, Peso_Real_HEA, Trf_Vd_HEA, Tp_Frete_HEA, 
		HEA.Cd_Tp_Moeda, TM.Nome_Tp_Moeda, Vlr_Frete_Tot_HEA, 
		HEA.Cd_Tp_Prod, TP.Nome_Tp_Prod, RE_DSE_HEA, SD_HEA, Prod_Perig_HEA, Prod_Perec_HEA, 
		HEA.Cd_Cia_Aer, CA.Nome_Cia_Aer, Cd_Sb_Ag_Nac_HEA,SbAgent.Apelido as SbAgent,  Cd_Dsp_HEA, 
		Despachante.Apelido as Despachante, EW_HEA, FOB_FCA_HEA, CIF_HEA, 
		Cli_Msq_HEA, Transp_HEA, Vol_Tot_HEA, Peso_Bruto_HEA, Dt_Rcb_Doc_HEA, 
		Dt_Etg_Doc_HEA, Obs_HEA, Cd_Tp_Oper, US.Nome_Usuario as Consultor, 
		Agente.Apelido as Agente, JEA.MAWB_HEA, TE.Nome_Tp_Embal, JEA.Inv_HEA ,
		Vend.Nome_Usuario as Vendedor, Dead_Line, TTime_d, TTime_h
	From 
		House_Exp_Aer as HEA Left Outer Join Pessoa as Consig on HEA.Cd_Consig_HEA = Consig.Cd_Pes 
		Left Outer Join Pessoa as Export on HEA.Cd_Export_HEA = Export.Cd_Pes 
		Left Outer Join Pessoa as Notify on HEA.Cd_Notify_HEA = Notify.Cd_Pes 
		Left Outer Join Localidade as Origem on HEA.Cd_Org_HEA = Origem.Cd_Local
		Left Outer Join Localidade as Destino on HEA.Cd_Dst_HEA = Destino.Cd_Local
		Left Outer Join Tipo_Moeda as TM on HEA.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
		Left Outer Join Tipo_Produto as TP on HEA.Cd_Tp_prod = TP.Cd_Tp_Prod 	
		Left Outer Join Cia_Aerea as CA on HEA.Cd_Cia_Aer = CA.Cd_Cia_Aer
		Left Outer Join Pessoa as SbAgent on HEA.Cd_Sb_Ag_Nac_HEA = SbAgent.Cd_Pes 
		Left Outer Join Pessoa as Despachante on HEA.Cd_Dsp_HEA = Despachante.Cd_Pes 
		Left Outer Join Job_Exp_Aer as JEA on JEA.Num_Proc_HEA = HEA.Num_Proc_HEA 
		Left Outer Join Usuario as US on US.Cd_Usuario = JEA.Cd_Usuario  
		Left Outer Join Pessoa as Agente on Agente.Cd_Pes = JEA.Cd_Agente 
		Left Outer Join Tipo_Embalagem as TE on TE.Cd_Tp_Embal = JEA.Cd_Tp_Embal  
		Left Outer Join Usuario as Vend on Vend.Cd_Usuario = JEA.Cd_Vendedor
	Where
		HEA.Num_Proc_MEA = 'JOB'
	Order by 
		HEA.Num_Proc_HEA
Else
	Select 
		HEA.Num_Proc_HEA, Num_Proc_MEA, Num_Prop_EA, Dt_Emis_HEA, HAWB_HEA, 
		Cd_Consig_HEA, Consig.Apelido as Consignatario, Cd_Export_HEA, 
		Export.Apelido as Shipper, Cd_Notify_HEA, Notify.Apelido as Notify, Voo_HEA, 
		Cd_Org_HEA, Origem.Nome_Local as Origem, Cd_Dst_HEA, Destino.Nome_Local as Destino, 
		ETD_HEA, ETA_HEA, Qtd_Tot_Vol_HEA, Peso_Real_HEA, Trf_Vd_HEA, Tp_Frete_HEA, 
		HEA.Cd_Tp_Moeda, TM.Nome_Tp_Moeda, Vlr_Frete_Tot_HEA, 
		HEA.Cd_Tp_Prod, TP.Nome_Tp_Prod, RE_DSE_HEA, SD_HEA, Prod_Perig_HEA, Prod_Perec_HEA, 
		HEA.Cd_Cia_Aer, CA.Nome_Cia_Aer, Cd_Sb_Ag_Nac_HEA,SbAgent.Apelido as SbAgent,  Cd_Dsp_HEA, 
		Despachante.Apelido as Despachante, EW_HEA, FOB_FCA_HEA, CIF_HEA, 
		Cli_Msq_HEA, Transp_HEA, Vol_Tot_HEA, Peso_Bruto_HEA, Dt_Rcb_Doc_HEA, 
		Dt_Etg_Doc_HEA, Obs_HEA, Cd_Tp_Oper, US.Nome_Usuario as Consultor, TE.Nome_Tp_Embal , JEA.Inv_HEA ,
		Vend.Nome_Usuario as Vendedor, Dead_Line, TTime_d, TTime_h
	From 
		House_Exp_Aer as HEA Left Outer Join Pessoa as Consig on HEA.Cd_Consig_HEA = Consig.Cd_Pes 
		Left Outer Join Pessoa as Export on HEA.Cd_Export_HEA = Export.Cd_Pes 
		Left Outer Join Pessoa as Notify on HEA.Cd_Notify_HEA = Notify.Cd_Pes 
		Left Outer Join Localidade as Origem on HEA.Cd_Org_HEA = Origem.Cd_Local
		Left Outer Join Localidade as Destino on HEA.Cd_Dst_HEA = Destino.Cd_Local
		Left Outer Join Tipo_Moeda as TM on HEA.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
		Left Outer Join Tipo_Produto as TP on HEA.Cd_Tp_prod = TP.Cd_Tp_Prod 	
		Left Outer Join Cia_Aerea as CA on HEA.Cd_Cia_Aer = CA.Cd_Cia_Aer
		Left Outer Join Pessoa as SbAgent on HEA.Cd_Sb_Ag_Nac_HEA = SbAgent.Cd_Pes 
		Left Outer Join Pessoa as Despachante on HEA.Cd_Dsp_HEA = Despachante.Cd_Pes 
		Left Outer Join Job_Exp_Aer as JEA on JEA.Num_Proc_HEA = HEA.Num_Proc_HEA 
		Left Outer Join Usuario as US on US.Cd_Usuario = JEA.Cd_Usuario  
		Left Outer Join Tipo_Embalagem as TE on TE.Cd_Tp_Embal = JEA.Cd_Tp_Embal  
		Left Outer Join Usuario as Vend on Vend.Cd_Usuario = JEA.Cd_Vendedor
	Where
		HEA.Num_Proc_HEA = @Num_Proc and 
		HEA.Num_Proc_MEA = 'JOB'
	Order by 
		HEA.Num_Proc_HEA
GO
