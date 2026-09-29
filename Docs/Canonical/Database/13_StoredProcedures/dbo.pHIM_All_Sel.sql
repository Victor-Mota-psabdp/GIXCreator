SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pHIM_All_Sel 
(
@Num_Proc 		VarChar(16) 
)
AS
Select  
	Num_Proc_HIM, Num_Prop_IM, Dt_Emis_HIM, HAWB_HIM, MAWB_HIM, Cd_Import_HIM, 
	Import.Apelido as Importador, Cd_Consig_HIM, Consig.Apelido as Consignatario, 
	Cd_Export_HIM, Ship.Apelido as Shipper, Navio_HIM, 
	Viagem_HIM, Band_Bras_HIM, Cd_Org_HIM, Orig.Nome_Local as Origem, Cd_Dst_HIM, 
	Destin.Nome_Local as Destino,Dt_Saida_HIM, Dt_Cheg_HIM, Tp_Frete_HIM, 
	HIM.Cd_Tp_Moeda, TM.Nome_Tp_Moeda, Vlr_Frete_Efet_HIM, Prod_Perig_HIM, 
	Prod_Perec_HIM, Cd_Sb_Ag_Int_HIM, SbAgInt.Apelido as SubAgeInt, Cd_Sb_Ag_Nac_HIM, 
	SbAgNac.Apelido as SubAgeNac, HIM.Cd_Tp_Prod, Nome_Tp_Prod, EW_HIM, 
	FOB_FCA_HIM, CIF_HIM, Cli_Msq_HIM, Cd_Porto_Rcb_HIM, PortoRec.Nome_Local as PortoReceb, 
	HIM.Cd_Tp_Embal, Nome_Tp_Embal, Qtd_Tot_Vol_HIM, Vol_Tot_HIM, 
	Peso_Liquido_HIM, Peso_Bruto_HIM, Tp_Trf_HIM, Trf_Cp_HIM, Trf_Vd_HIM, 
	Vlr_Frete_Negoc_HIM, Dt_Rcb_Doc_HIM, Dt_Etg_Doc_HIM, Obs_HIM, Transito_HIM, 
	Nr_Viagem, Ano_Viagem, Dt_Previs, Dt_Atrac, Vg.ID_Navio, ID_Loc_Atrac, Dt_Oper, Nr_Viagem_Age,
	Nv.Nome_Navio, AA.Descricao_Armador as Emissor, Cd_Tp_Oper, Desp.Apelido as Despachante ,
	Dead_Line, TTime_d, TTime_h
From  
	House_Imp_Mar as HIM Left Outer Join Viagem as Vg on HIM.Id_Viagem = Vg.ID_Viagem
	Left Outer Join Navio as NV on Vg.ID_Navio = NV.ID_Navio
	Left Outer Join  Pessoa as Import on  Cd_Import_HIM = Import.Cd_Pes
	Left Outer Join Pessoa as Consig on Cd_Consig_HIM = Consig.Cd_Pes 
	Left Outer Join Pessoa as  Ship on  Cd_Export_HIM = Ship.Cd_Pes
	Join Localidade as Orig on  	Cd_Org_HIM = Orig.Cd_Local 
	Join Localidade as Destin on Cd_Dst_HIM = Destin.Cd_Local 
	Join Tipo_Moeda as TM on HIM.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
	Left Outer Join Pessoa as  SbAgInt on Cd_Sb_Ag_Int_HIM = SbAgInt.Cd_Pes 
	Left Outer Join Pessoa as SbAgNac on  Cd_Sb_Ag_Nac_HIM = SbAgNac.Cd_Pes 
	Left Outer Join Tipo_Produto as TP on HIM.Cd_Tp_Prod = TP.Cd_Tp_Prod 
	Left Outer Join Localidade as PortoRec on  Cd_Porto_Rcb_HIM = PortoRec.Cd_Local
	Left Outer Join Tipo_Embalagem  as TE on HIM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
	Left Outer Join Aux_Armador as AA on HIM.Cd_Emissor = AA.Cd_Arm_Ofc
	Left Outer Join Pessoa as Desp on Desp.Cd_Pes = HIM.Cd_Despachante
Where 
	Num_Proc_MIM = @Num_Proc 
Order by  
	Num_Proc_HIM

GO
