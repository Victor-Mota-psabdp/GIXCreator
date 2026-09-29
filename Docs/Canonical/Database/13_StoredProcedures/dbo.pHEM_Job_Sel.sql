SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pHEM_Job_Sel
(
@Num_Proc 	VarChar(16)=''
)
As
If @Num_Proc = ''
	Select  
		HEM.Num_Proc_HEM, Num_Prop_EM, Dt_Emis_HEM, HAWB_HEM, Dt_Etg_BL_HEM, JEM.MAWB_HEM, 
		Cd_Consig_HEM, Consig.Apelido as Consignatario, Cd_Export_HEM, Ship.Apelido as Shiper, 
		Cd_Notify_HEM, Notif.Apelido as Notify, Navio_HEM, Viagem_HEM, Band_Bras_HEM, Cd_Org_HEM, Orig.Nome_Local as Origem, 
		Cd_Dst_HEM, Dest.Nome_Local as Destino, Cd_Sb_Ag_Nac_HEM, SbAg.Apelido as SubAgente, Trf_Cp_HEM, Trf_Vd_HEM, Tp_Frete_HEM, 
		HEM.Cd_Tp_Moeda, Nome_Tp_Moeda, Vlr_Frete_Tot_HEM, 
		HEM.Cd_Tp_Prod, Nome_Tp_Prod, RE_DSE_HEM, SD_HEM, Prod_Perig_HEM, 
		Prod_Perec_HEM, Cd_Dsp_HEM, Desp.Apelido as Despachante, Cli_Msq_HEM, Transp_HEM, EW_HEM, 
		FOB_FCA_HEM, CIF_HEM, HEM.Cd_Tp_Embal, Nome_Tp_Embal, Qtd_Tot_Vol_HEM, 
		Vol_Tot_HEM, Peso_Liquido_HEM, Peso_Bruto_HEM, Dt_Rcb_Crg_HEM, Dt_Rcb_Doc_HEM, 
		Obs_HEM, Transito_HEM, 
		Nr_Viagem, Ano_Viagem, Dt_Previs, Dt_Atrac, Vg.ID_Navio, ID_Loc_Atrac, Dt_Oper, Nr_Viagem_Age,
		Nv.Nome_Navio, AA.Descricao_Armador as Emissor, Cd_Tp_Oper, Us.Nome_Usuario as Consultor,
		JEM.Nr_Reserva, JEM.Dt_ETA as Dt_ETA	, Agente.Apelido as Agente, 
		Inv_HEM, Vend.Nome_Usuario as Vendedor , HEM.Dead_Line, TTime_d, TTime_h 
	From 
		House_Exp_Mar as HEM
		Left Outer Join Viagem as Vg on HEM.Id_Viagem = Vg.ID_Viagem
		Left Outer Join Navio as NV on Vg.ID_Navio = NV.ID_Navio
		Left Outer Join Pessoa as Consig on  (Cd_Consig_HEM = Consig.Cd_Pes )
		Left Outer Join Pessoa as Ship on Cd_Export_HEM = Ship.Cd_Pes 
		Left Outer Join Pessoa as Notif on Cd_Notify_HEM = Notif.Cd_Pes 
		Join Localidade as Orig on Cd_Org_HEM = Orig.Cd_Local 
		Join Localidade as Dest  on Cd_Dst_HEM = Dest.Cd_Local
		Left Outer Join Pessoa as SbAg on Cd_Sb_Ag_Nac_HEM = SbAg.Cd_Pes 
		Left Outer Join Tipo_Moeda on HEM.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda 
		Left Outer Join Tipo_Produto on HEM.Cd_Tp_Prod = Tipo_Produto.Cd_Tp_Prod 
		Left Outer Join Pessoa as Desp on Cd_Dsp_HEM = Desp.Cd_Pes 
		Left Outer Join Tipo_Embalagem on HEM.Cd_Tp_Embal = Tipo_Embalagem.Cd_Tp_Embal 
		Left Outer Join Aux_Armador as AA on HEM.Cd_Emissor = AA.Cd_Arm_Ofc
		Left Outer Join Job_Exp_Mar as JEM on JEM.Num_Proc_HEM = HEM.Num_Proc_HEM
		Left Outer Join Usuario as Us on Us.Cd_Usuario = JEM.Cd_Usuario
		Left Outer Join Pessoa as Agente on Agente.Cd_Pes = JEM.Cd_Agente 
		Left Outer Join Usuario as Vend on Vend.Cd_Usuario = JEM.Cd_Vendedor		


	Where 
		Left(HEM.Num_Proc_HEM,5) = 'EMJOB' 
	Order by 
		HEM.Num_Proc_HEM
Else
	Select  
		HEM.Num_Proc_HEM, Num_Prop_EM, Dt_Emis_HEM, HAWB_HEM, Dt_Etg_BL_HEM, JEM.MAWB_HEM, 
		Cd_Consig_HEM, Consig.Apelido as Consignatario, Cd_Export_HEM, Ship.Apelido as Shiper, 
		Cd_Notify_HEM, Notif.Apelido as Notify, Navio_HEM, Viagem_HEM, Band_Bras_HEM, Cd_Org_HEM, Orig.Nome_Local as Origem, 
		Cd_Dst_HEM, Dest.Nome_Local as Destino, Cd_Sb_Ag_Nac_HEM, SbAg.Apelido as SubAgente, Trf_Cp_HEM, Trf_Vd_HEM, Tp_Frete_HEM, 
		HEM.Cd_Tp_Moeda, Nome_Tp_Moeda, Vlr_Frete_Tot_HEM, 
		HEM.Cd_Tp_Prod, Nome_Tp_Prod, RE_DSE_HEM, SD_HEM, Prod_Perig_HEM, 
		Prod_Perec_HEM, Cd_Dsp_HEM, Desp.Apelido as Despachante, Cli_Msq_HEM, Transp_HEM, EW_HEM, 
		FOB_FCA_HEM, CIF_HEM, HEM.Cd_Tp_Embal, Nome_Tp_Embal, Qtd_Tot_Vol_HEM, 
		Vol_Tot_HEM, Peso_Liquido_HEM, Peso_Bruto_HEM, Dt_Rcb_Crg_HEM, Dt_Rcb_Doc_HEM, 
		Obs_HEM, Transito_HEM, 
		Nr_Viagem, Ano_Viagem, Dt_Previs, Dt_Atrac, Vg.ID_Navio, ID_Loc_Atrac, Dt_Oper, Nr_Viagem_Age,
		Nv.Nome_Navio, AA.Descricao_Armador as Emissor, Cd_Tp_Oper, Us.Nome_Usuario as Consultor,
		JEM.Nr_Reserva, JEM.Dt_ETA as Dt_ETA,  Agente.Apelido as Agente,
		Inv_HEM, Vend.Nome_Usuario as Vendedor , HEM.Dead_Line, TTime_d, TTime_h 
	From 
		House_Exp_Mar as HEM
		Left Outer Join Viagem as Vg on HEM.Id_Viagem = Vg.ID_Viagem
		Left Outer Join Navio as NV on Vg.ID_Navio = NV.ID_Navio
		Left Outer Join Pessoa as Consig on  (Cd_Consig_HEM = Consig.Cd_Pes )
		Left Outer Join Pessoa as Ship on Cd_Export_HEM = Ship.Cd_Pes 
		Left Outer Join Pessoa as Notif on Cd_Notify_HEM = Notif.Cd_Pes 
		Join Localidade as Orig on Cd_Org_HEM = Orig.Cd_Local 
		Join Localidade as Dest  on Cd_Dst_HEM = Dest.Cd_Local
		Left Outer Join Pessoa as SbAg on Cd_Sb_Ag_Nac_HEM = SbAg.Cd_Pes 
		Left Outer Join Tipo_Moeda on HEM.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda 
		Left Outer Join Tipo_Produto on HEM.Cd_Tp_Prod = Tipo_Produto.Cd_Tp_Prod 
		Left Outer Join Pessoa as Desp on Cd_Dsp_HEM = Desp.Cd_Pes 
		Left Outer Join Tipo_Embalagem on HEM.Cd_Tp_Embal = Tipo_Embalagem.Cd_Tp_Embal 
		Left Outer Join Aux_Armador as AA on HEM.Cd_Emissor = AA.Cd_Arm_Ofc
		Left Outer Join Job_Exp_Mar as JEM on JEM.Num_Proc_HEM = HEM.Num_Proc_HEM
		Left Outer Join Usuario as Us on Us.Cd_Usuario = JEM.Cd_Usuario
		Left Outer Join Pessoa as Agente on Agente.Cd_Pes = JEM.Cd_Agente 
		Left Outer Join Usuario as Vend on Vend.Cd_Usuario = JEM.Cd_Vendedor		
	Where 
		HEM.Num_Proc_HEM = @Num_Proc and 
		Left(HEM.Num_Proc_HEM,5) = 'EMJOB' 
	Order by 
		HEM.Num_Proc_HEM

GO
