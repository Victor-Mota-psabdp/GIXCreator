SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pLucratividade_Rel 
(
@Cd_Pes		VarChar(10)='%', 
@Modal		Char(2)='%', 
@Dt_Inic		VarChar(16),
@Dt_Fim		VarChar(16)
)
 AS
	If @Modal = '%'			
		Begin 
			Select 
				'EA' as Modal, MEA.Dt_Saida_MEA as Data,  MEA.Num_Proc_MEA as Proc_Master, HEA.Num_Proc_HEA as ProcHouse, PS.Apelido as Pessoa, MEA.MAWB_MEA as Master, HEA.HAWB_HEA as House, TT.Nome_Tp_Tx as Tipo_Taxa, 
				Trf_Net_MEA as Trf_Net, Peso_Real_HEA as Peso_Bruto_H, Vol_Tot_HEA as Vol_Tot_H, Peso_Bruto_MEA as Peso_Bruto_M, 
				CtaC.Cd_Tp_Moeda as MoedaC,  CtaC.Vlr_Org_HEA as Vlr_OrgC, CxaC.Dt_Pgto_Rcto_HEA as Dt_PgtC, CxaC.Num_Rcb_HEA as ReciboC, CxaC.Vlr_Pgto_Rcto_HEA as VlrPgoC, CtaC.Org_Ins_HEA as InserC, CxaC.Par_Moeda_HEA as Parid_C, 
				CtaD.Cd_Tp_Moeda as MoedaD, CtaD.Vlr_Org_HEA as Vlr_OrgD, CxaD.Dt_Pgto_Rcto_HEA as Dt_PgtD, CxaD.Num_Rcb_HEA as ReciboD, CxaD.Vlr_Pgto_Rcto_HEA as VlrPgoD, CtaD.Org_Ins_HEA as InserD, CxaD.Par_Moeda_HEA as Parid_D, 
 				CtaMC.Cd_Tp_Moeda as MoedaMC, CtaMC.Vlr_Org_MEA as Vlr_OrgMC, CxaMC.Dt_Pgto_Rcto_MEA as Dt_PgtMC, CxaMC.Num_Rcb_MEA as ReciboMC, CxaMC.Vlr_Pgto_Rcto_MEA as VlrPgoMC, CtaMC.Org_Ins_MEA as InserMC,
				CxaMC.Par_Moeda_MEA as Parid_MC, 
 				CtaMD.Cd_Tp_Moeda as MoedaMD, CtaMD.Vlr_Org_MEA as Vlr_OrgMD, CxaMD.Dt_Pgto_Rcto_MEA as Dt_PgtMD, CxaMD.Num_Rcb_MEA as ReciboMD, CxaMD.Vlr_Pgto_Rcto_MEA as VlrPgoMD, CtaMD.Org_Ins_MEA as InserMD,
				CxaMD.Par_Moeda_MEA as Parid_MD 
			From
				Master_Exp_Aer as MEA Join House_Exp_Aer as HEA on MEA.Num_Proc_MEA = HEA.Num_Proc_MEA 
				Join Pessoa as PS on HEA.Cd_Export_HEA = PS.Cd_Pes 
				Left Outer Join Cta_Cte_Hou_Exp_Aer as Cta on (HEA.Num_Proc_HEA = Cta.Num_Proc_HEA and Cta.Desp_Dst_HEA = 'N')
				Left Outer Join Tipo_Taxa as TT on (Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx)
				Left Outer Join Cta_Cte_Hou_Exp_Aer as CtaC on (Cta.Num_Proc_HEA = CtaC.Num_Proc_HEA and CtaC.DC_HEA = 'C' and CtaC.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Exp_Aer as CxaC on (CtaC.Num_Proc_HEA = CxaC.Num_Proc_HEA and CtaC.Cd_Tp_Tx = CxaC.Cd_Tp_Tx and CxaC.DC_HEA = CtaC.DC_HEA and CxaC.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Hou_Exp_Aer as CtaD on (Cta.Num_Proc_HEA = CtaD.Num_Proc_HEA and CtaD.DC_HEA = 'D' and CtaD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Exp_Aer as CxaD on (CtaD.Num_Proc_HEA = CxaD.Num_Proc_HEA and CtaD.Cd_Tp_Tx = CxaD.Cd_Tp_Tx and CtaD.DC_HEA = CxaD.DC_HEA and CxaD.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Mas_Exp_Aer as CtaMC on (Left(Cta.Num_Proc_HEA,14) = CtaMC.Num_Proc_MEA and CtaMC.DC_MEA = 'C' and CtaMC.Cd_Tp_Tx = Cta.Cd_Tp_Tx )
				Left Outer Join Caixa_Mas_Exp_Aer as CxaMC on (CTAMC.Num_Proc_MEA = CxaMC.Num_Proc_MEA and CtaMC.Cd_Tp_Tx = CxaMC.Cd_Tp_Tx and CtaMC.DC_MEA = CxaMC.DC_MEA)
				Left Outer Join Cta_Cte_Mas_Exp_Aer as CtaMD on (Left(Cta.Num_Proc_HEA,14) = CtaMD.Num_Proc_MEA and CtaMD.DC_MEA = 'D' and CtaMD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Mas_Exp_Aer as CxaMD on (CTAMD.Num_Proc_MEA = CxaMD.Num_Proc_MEA and CtaMD.Cd_Tp_Tx = CxaMD.Cd_Tp_Tx and CtaMD.DC_MEA = CxaMD.DC_MEA)
			Where
				HEA.Cd_Export_HEA Like @Cd_Pes and 
				Convert(DateTime, MEA.Dt_Saida_MEA, 105) between  @Dt_Inic and  @Dt_Fim
				
			Group by 
				MEA.Dt_Saida_MEA, MEA.Num_Proc_MEA, HEA.Num_Proc_HEA, PS.Apelido, MEA.MAWB_MEA, HEA.HAWB_HEA,TT.Nome_Tp_Tx, 
				Trf_Net_MEA, Peso_Real_HEA, Vol_Tot_HEA, Peso_Bruto_MEA,
				CtaC.Cd_Tp_Moeda, CtaC.Vlr_Org_HEA, CxaC.Dt_Pgto_Rcto_HEA, CxaC.Num_Rcb_HEA, CxaC.Vlr_Pgto_Rcto_HEA, CtaC.Org_Ins_HEA, CxaC.Par_Moeda_HEA, 
				CtaD.Cd_Tp_Moeda, CtaD.Vlr_Org_HEA, CxaD.Dt_Pgto_Rcto_HEA, CxaD.Num_Rcb_HEA, CxaD.Vlr_Pgto_Rcto_HEA, CtaD.Org_Ins_HEA, CxaD.Par_Moeda_HEA, 
 				CtaMC.Cd_Tp_Moeda, CtaMC.Vlr_Org_MEA, CxaMC.Dt_Pgto_Rcto_MEA, CxaMC.Num_Rcb_MEA, CxaMC.Vlr_Pgto_Rcto_MEA, CtaMC.Org_Ins_MEA,
				CxaMC.Par_Moeda_MEA, 
 				CtaMD.Cd_Tp_Moeda, CtaMD.Vlr_Org_MEA, CxaMD.Dt_Pgto_Rcto_MEA, CxaMD.Num_Rcb_MEA, CxaMD.Vlr_Pgto_Rcto_MEA, CtaMD.Org_Ins_MEA,
				CxaMD.Par_Moeda_MEA
			Union 
			
			Select 
				'EM' as Modal, MEM.Dt_Saida_MEM as Data, MEM.Num_Proc_MEM as Proc_Master, HEM.Num_Proc_HEM as ProcHouse, PS.Apelido as Pessoa, MEM.MAWB_MEM as Master, HEM.HAWB_HEM as House, TT.Nome_Tp_Tx as Tipo_Taxa, 
				Trf_Net_MEM as Trf_Net, Peso_Bruto_HEM as Peso_Bruto_H, Vol_Tot_HEM as Vol_Tot_H, Peso_Bruto_MEM as Peso_Bruto_M, 
				CtaC.Cd_Tp_Moeda as MoedaC, CtaC.Vlr_Org_HEM as Vlr_OrgC, CxaC.Dt_Pgto_Rcto_HEM as Dt_PgtC, CxaC.Num_Rcb_HEM as ReciboC, CxaC.Vlr_Pgto_Rcto_HEM as VlrPgoC, CtaC.Org_Ins_HEM as InserC, CxaC.Par_Moeda_HEM as Parid_C, 
				CtaD.Cd_Tp_Moeda as MoedaD, CtaD.Vlr_Org_HEM as Vlr_OrgD, CxaD.Dt_Pgto_Rcto_HEM as Dt_PgtD, CxaD.Num_Rcb_HEM as ReciboD, CxaD.Vlr_Pgto_Rcto_HEM as VlrPgoD, CtaD.Org_Ins_HEM as InserD, CxaD.Par_Moeda_HEM as Parid_D, 
 				CtaMC.Cd_Tp_Moeda as MoedaMC, CtaMC.Vlr_Org_MEM as Vlr_OrgMC, CxaMC.Dt_Pgto_Rcto_MEM as Dt_PgtMC, CxaMC.Num_Rcb_MEM as ReciboMC, CxaMC.Vlr_Pgto_Rcto_MEM as VlrPgoMC, CtaMC.Org_Ins_MEM as InserMC,
				CxaMC.Par_Moeda_MEM as Parid_MC, 
 				CtaMD.Cd_Tp_Moeda as MoedaMD, CtaMD.Vlr_Org_MEM as Vlr_OrgMD, CxaMD.Dt_Pgto_Rcto_MEM as Dt_PgtMD, CxaMD.Num_Rcb_MEM as ReciboMD, CxaMD.Vlr_Pgto_Rcto_MEM as VlrPgoMD, CtaMD.Org_Ins_MEM as InserMD,
				CxaMD.Par_Moeda_MEM as Parid_MD 
			From
				Master_Exp_Mar as MEM Join House_Exp_Mar as HEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM 
				Join Pessoa as PS on HEM.Cd_Export_HEM = PS.Cd_Pes 
				Left Outer Join Cta_Cte_Hou_Exp_Mar as Cta on (HEM.Num_Proc_HEM = Cta.Num_Proc_HEM and Cta.Desp_Dst_HEM = 'N')
				Left Outer Join Tipo_Taxa as TT on (Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx)
				Left Outer Join Cta_Cte_Hou_Exp_Mar as CtaC on (Cta.Num_Proc_HEM = CtaC.Num_Proc_HEM and CtaC.DC_HEM = 'C' and CtaC.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Exp_Mar as CxaC on (CtaC.Num_Proc_HEM = CxaC.Num_Proc_HEM and CtaC.Cd_Tp_Tx = CxaC.Cd_Tp_Tx and CxaC.DC_HEM = CtaC.DC_HEM and CxaC.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Hou_Exp_Mar as CtaD on (Cta.Num_Proc_HEM = CtaD.Num_Proc_HEM and CtaD.DC_HEM = 'D' and CtaD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Exp_Mar as CxaD on (CtaD.Num_Proc_HEM = CxaD.Num_Proc_HEM and CtaD.Cd_Tp_Tx = CxaD.Cd_Tp_Tx and CtaD.DC_HEM = CxaD.DC_HEM and CxaD.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Mas_Exp_Mar as CtaMC on (Left(Cta.Num_Proc_HEM,14) = CtaMC.Num_Proc_MEM and CtaMC.DC_MEM = 'C' and CtaMC.Cd_Tp_Tx = Cta.Cd_Tp_Tx )
				Left Outer Join Caixa_Mas_Exp_Mar as CxaMC on (CTAMC.Num_Proc_MEM = CxaMC.Num_Proc_MEM and CtaMC.Cd_Tp_Tx = CxaMC.Cd_Tp_Tx and CtaMC.DC_MEM = CxaMC.DC_MEM)
				Left Outer Join Cta_Cte_Mas_Exp_Mar as CtaMD on (Left(Cta.Num_Proc_HEM,14) = CtaMD.Num_Proc_MEM and CtaMD.DC_MEM = 'D' and CtaMD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Mas_Exp_Mar as CxaMD on (CTAMD.Num_Proc_MEM = CxaMD.Num_Proc_MEM and CtaMD.Cd_Tp_Tx = CxaMD.Cd_Tp_Tx and CtaMD.DC_MEM = CxaMD.DC_MEM)
			Where
				HEM.Cd_Export_HEM Like @Cd_Pes and 
				Convert(datetime, MEM.Dt_Saida_MEM, 105) between  @Dt_Inic and  @Dt_Fim
			Group by 
				MEM.Dt_Saida_MEM, MEM.Num_Proc_MEM, HEM.Num_Proc_HEM, PS.Apelido, MEM.MAWB_MEM, HEM.HAWB_HEM, HEM.HAWB_HEM,TT.Nome_Tp_Tx, 
				Trf_Net_MEM, Peso_Bruto_HEM, Vol_Tot_HEM, Peso_Bruto_MEM,
				CtaC.Cd_Tp_Moeda, CtaC.Vlr_Org_HEM, CxaC.Dt_Pgto_Rcto_HEM, CxaC.Num_Rcb_HEM, CxaC.Vlr_Pgto_Rcto_HEM, CtaC.Org_Ins_HEM, CxaC.Par_Moeda_HEM, 
				CtaD.Cd_Tp_Moeda, CtaD.Vlr_Org_HEM, CxaD.Dt_Pgto_Rcto_HEM, CxaD.Num_Rcb_HEM, CxaD.Vlr_Pgto_Rcto_HEM, CtaD.Org_Ins_HEM, CxaD.Par_Moeda_HEM, 
 				CtaMC.Cd_Tp_Moeda, CtaMC.Vlr_Org_MEM, CxaMC.Dt_Pgto_Rcto_MEM, CxaMC.Num_Rcb_MEM, CxaMC.Vlr_Pgto_Rcto_MEM, CtaMC.Org_Ins_MEM,
				CxaMC.Par_Moeda_MEM, 
				CtaMD.Cd_Tp_Moeda, CtaMD.Vlr_Org_MEM, CxaMD.Dt_Pgto_Rcto_MEM, CxaMD.Num_Rcb_MEM, CxaMD.Vlr_Pgto_Rcto_MEM, CtaMD.Org_Ins_MEM,
				CxaMD.Par_Moeda_MEM
			Union 
			
			
			Select 
				'IA' as Modal, MIA.Dt_Cheg_MIA as Data, MIA.Num_Proc_MIA as Proc_Master, HIA.Num_Proc_HIA as ProcHouse, PS.Apelido as Pessoa, MIA.MAWB_MIA as Master, HIA.HAWB_HIA as House, TT.Nome_Tp_Tx as Tipo_Taxa, 
				Null as Trf_Net, Peso_Bruto_HIA as Peso_Bruto_H, Vol_Tot_HIA as Vol_Tot_H, Peso_Bruto_MIA as Peso_Bruto_M, 
				CtaC.Cd_Tp_Moeda as MoedaC, CtaC.Vlr_Org_HIA as Vlr_OrgC, CxaC.Dt_Pgto_Rcto_HIA as Dt_PgtC, CxaC.Num_Rcb_HIA as ReciboC, CxaC.Vlr_Pgto_Rcto_HIA as VlrPgoC, CtaC.Org_Ins_HIA as InserC,  CxaC.Par_Moeda_HIA as Parid_C,
				CtaD.Cd_Tp_Moeda as MoedaD, CtaD.Vlr_Org_HIA as Vlr_OrgD, CxaD.Dt_Pgto_Rcto_HIA as Dt_PgtD, CxaD.Num_Rcb_HIA as ReciboD, CxaD.Vlr_Pgto_Rcto_HIA as VlrPgoD, CtaD.Org_Ins_HIA as InserD, CxaD.Par_Moeda_HIA as Parid_D,
 				CtaMC.Cd_Tp_Moeda as MoedaMC, CtaMC.Vlr_Org_MIA as Vlr_OrgMC, CxaMC.Dt_Pgto_Rcto_MIA as Dt_PgtMC, CxaMC.Num_Rcb_MIA as ReciboMC, CxaMC.Vlr_Pgto_Rcto_MIA as VlrPgoMC, CtaMC.Org_Ins_MIA as InserMC,
				CxaMC.Par_Moeda_MIA as Parid_MC, 
 				CtaMD.Cd_Tp_Moeda as MoedaMD, CtaMD.Vlr_Org_MIA as Vlr_OrgMD, CxaMD.Dt_Pgto_Rcto_MIA as Dt_PgtMD, CxaMD.Num_Rcb_MIA as ReciboMD, CxaMD.Vlr_Pgto_Rcto_MIA as VlrPgoMD, CtaMD.Org_Ins_MIA as InserMD,
				CxaMD.Par_Moeda_MIA as Parid_MD 
			From
				Master_Imp_Aer as MIA Join House_Imp_Aer as HIA on MIA.Num_Proc_MIA = HIA.Num_Proc_MIA 
				Join Pessoa as PS on HIA.Cd_Import_HIA = PS.Cd_Pes 
				Left Outer Join Cta_Cte_Hou_Imp_Aer as Cta on (HIA.Num_Proc_HIA = Cta.Num_Proc_HIA and Cta.Desp_Org_HIA = 'N')
				Left Outer Join Tipo_Taxa as TT on (Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx)
				Left Outer Join Cta_Cte_Hou_Imp_Aer as CtaC on (Cta.Num_Proc_HIA = CtaC.Num_Proc_HIA and CtaC.DC_HIA = 'C' and CtaC.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Imp_Aer as CxaC on (CtaC.Num_Proc_HIA = CxaC.Num_Proc_HIA and CtaC.Cd_Tp_Tx = CxaC.Cd_Tp_Tx and CxaC.DC_HIA = CtaC.DC_HIA and CxaC.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Hou_Imp_Aer as CtaD on (Cta.Num_Proc_HIA = CtaD.Num_Proc_HIA and CtaD.DC_HIA = 'D' and CtaD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Imp_Aer as CxaD on (CtaD.Num_Proc_HIA = CxaD.Num_Proc_HIA and CtaD.Cd_Tp_Tx = CxaD.Cd_Tp_Tx and CtaD.DC_HIA = CxaD.DC_HIA and CxaD.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Mas_Imp_Aer as CtaMC on (Left(Cta.Num_Proc_HIA,14) = CtaMC.Num_Proc_MIA and CtaMC.DC_MIA = 'C' and CtaMC.Cd_Tp_Tx = Cta.Cd_Tp_Tx )
				Left Outer Join Caixa_Mas_Imp_Aer as CxaMC on (CTAMC.Num_Proc_MIA = CxaMC.Num_Proc_MIA and CtaMC.Cd_Tp_Tx = CxaMC.Cd_Tp_Tx and CtaMC.DC_MIA = CxaMC.DC_MIA)
				Left Outer Join Cta_Cte_Mas_Imp_Aer as CtaMD on (Left(Cta.Num_Proc_HIA,14) = CtaMD.Num_Proc_MIA and CtaMD.DC_MIA = 'D' and CtaMD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Mas_Imp_Aer as CxaMD on (CTAMD.Num_Proc_MIA = CxaMD.Num_Proc_MIA and CtaMD.Cd_Tp_Tx = CxaMD.Cd_Tp_Tx and CtaMD.DC_MIA = CxaMD.DC_MIA)
			Where
				HIA.Cd_Import_HIA Like @Cd_Pes and 
				Convert(datetime, MIA.Dt_Cheg_MIA, 105) between  @Dt_Inic and  @Dt_Fim
			Group by 
				MIA.Dt_Cheg_MIA, MIA.Num_Proc_MIA, HIA.Num_Proc_HIA, PS.Apelido, MIA.MAWB_MIA, HIA.HAWB_HIA, HIA.HAWB_HIA,TT.Nome_Tp_Tx, 
				Peso_Bruto_HIA, Vol_Tot_HIA, Peso_Bruto_MIA,
				CtaC.Cd_Tp_Moeda, CtaC.Vlr_Org_HIA, CxaC.Dt_Pgto_Rcto_HIA, CxaC.Num_Rcb_HIA, CxaC.Vlr_Pgto_Rcto_HIA, CtaC.Org_Ins_HIA, CxaC.Par_Moeda_HIA, 
				CtaD.Cd_Tp_Moeda, CtaD.Vlr_Org_HIA, CxaD.Dt_Pgto_Rcto_HIA, CxaD.Num_Rcb_HIA, CxaD.Vlr_Pgto_Rcto_HIA, CtaD.Org_Ins_HIA, CxaD.Par_Moeda_HIA, 
 				CtaMC.Cd_Tp_Moeda, CtaMC.Vlr_Org_MIA, CxaMC.Dt_Pgto_Rcto_MIA, CxaMC.Num_Rcb_MIA, CxaMC.Vlr_Pgto_Rcto_MIA, CtaMC.Org_Ins_MIA,
				CxaMC.Par_Moeda_MIA, 
				CtaMD.Cd_Tp_Moeda, CtaMD.Vlr_Org_MIA, CxaMD.Dt_Pgto_Rcto_MIA, CxaMD.Num_Rcb_MIA, CxaMD.Vlr_Pgto_Rcto_MIA, CtaMD.Org_Ins_MIA,
				CxaMD.Par_Moeda_MIA
			Union 
			
			Select 
				'IM' as Modal, MIM.Dt_Atrac_MIM as Data, MIM.Num_Proc_MIM as Proc_Master, HIM.Num_Proc_HIM as ProcHouse, PS.Apelido as Pessoa, MIM.MAWB_MIM as Master, HIM.HAWB_HIM as House, TT.Nome_Tp_Tx as Tipo_Taxa, 
				Null as Trf_Net, Peso_Bruto_HIM as Peso_Bruto_H, Vol_Tot_HIM as Vol_Tot_H, Peso_Bruto_MIM as Peso_Bruto_M, 
				CtaC.Cd_Tp_Moeda as MoedaC, CtaC.Vlr_Org_HIM as Vlr_OrgC, CxaC.Dt_Pgto_Rcto_HIM as Dt_PgtC, CxaC.Num_Rcb_HIM as ReciboC, CxaC.Vlr_Pgto_Rcto_HIM as VlrPgoC, CtaC.Org_Ins_HIM as InserC,  CxaC.Par_Moeda_HIM as Parid_D,
				CtaD.Cd_Tp_Moeda as MoedaD, CtaD.Vlr_Org_HIM as Vlr_OrgD, CxaD.Dt_Pgto_Rcto_HIM as Dt_PgtD, CxaD.Num_Rcb_HIM as ReciboD, CxaD.Vlr_Pgto_Rcto_HIM as VlrPgoD, CtaD.Org_Ins_HIM as InserD, CxaD.Par_Moeda_HIM as Parid_D,
 				CtaMC.Cd_Tp_Moeda as MoedaMC, CtaMC.Vlr_Org_MIM as Vlr_OrgMC, CxaMC.Dt_Pgto_Rcto_MIM as Dt_PgtMC, CxaMC.Num_Rcb_MIM as ReciboMC, CxaMC.Vlr_Pgto_Rcto_MIM as VlrPgoMC, CtaMC.Org_Ins_MIM as InserMC,
				CxaMC.Par_Moeda_MIM as Parid_MC, 
 				CtaMD.Cd_Tp_Moeda as MoedaMD, CtaMD.Vlr_Org_MIM as Vlr_OrgMD, CxaMD.Dt_Pgto_Rcto_MIM as Dt_PgtMD, CxaMD.Num_Rcb_MIM as ReciboMD, CxaMD.Vlr_Pgto_Rcto_MIM as VlrPgoMD, CtaMD.Org_Ins_MIM as InserMD,
				CxaMD.Par_Moeda_MIM as Parid_MD 
			From
				Master_Imp_Mar as MIM Join House_Imp_Mar as HIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM 
				Join Pessoa as PS on HIM.Cd_Import_HIM = PS.Cd_Pes 
				Left Outer Join Cta_Cte_Hou_Imp_Mar as Cta on (HIM.Num_Proc_HIM = Cta.Num_Proc_HIM and Cta.Desp_Org_HIM = 'N' )
				Left Outer Join Tipo_Taxa as TT on (Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx)
				Left Outer Join Cta_Cte_Hou_Imp_Mar as CtaC on (Cta.Num_Proc_HIM = CtaC.Num_Proc_HIM and CtaC.DC_HIM = 'C' and CtaC.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Imp_Mar as CxaC on (CtaC.Num_Proc_HIM = CxaC.Num_Proc_HIM and CtaC.Cd_Tp_Tx = CxaC.Cd_Tp_Tx and CxaC.DC_HIM = CtaC.DC_HIM and CxaC.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Hou_Imp_Mar as CtaD on (Cta.Num_Proc_HIM = CtaD.Num_Proc_HIM and CtaD.DC_HIM = 'D' and CtaD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Imp_Mar as CxaD on (CtaD.Num_Proc_HIM = CxaD.Num_Proc_HIM and CtaD.Cd_Tp_Tx = CxaD.Cd_Tp_Tx and CtaD.DC_HIM = CxaD.DC_HIM and CxaD.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Mas_Imp_Mar as CtaMC on (Left(Cta.Num_Proc_HIM,14) = CtaMC.Num_Proc_MIM and CtaMC.DC_MIM = 'C' and CtaMC.Cd_Tp_Tx = Cta.Cd_Tp_Tx )
				Left Outer Join Caixa_Mas_Imp_Mar as CxaMC on (CTAMC.Num_Proc_MIM = CxaMC.Num_Proc_MIM and CtaMC.Cd_Tp_Tx = CxaMC.Cd_Tp_Tx and CtaMC.DC_MIM = CxaMC.DC_MIM)
				Left Outer Join Cta_Cte_Mas_Imp_Mar as CtaMD on (Left(Cta.Num_Proc_HIM,14) = CtaMD.Num_Proc_MIM and CtaMD.DC_MIM = 'D' and CtaMD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Mas_Imp_Mar as CxaMD on (CTAMD.Num_Proc_MIM = CxaMD.Num_Proc_MIM and CtaMD.Cd_Tp_Tx = CxaMD.Cd_Tp_Tx and CtaMD.DC_MIM = CxaMD.DC_MIM)
			Where
				HIM.Cd_Import_HIM Like @Cd_Pes and 
				Convert(datetime, MIM.Dt_Atrac_MIM, 105) between  @Dt_Inic and  @Dt_Fim
			Group by 
				Dt_Atrac_MIM, MIM.Num_Proc_MIM, HIM.Num_Proc_HIM, PS.Apelido, MIM.MAWB_MIM, HIM.HAWB_HIM,TT.Nome_Tp_Tx, 
				Peso_Bruto_HIM, Vol_Tot_HIM, Peso_Bruto_MIM,
				CtaC.Cd_Tp_Moeda, CtaC.Vlr_Org_HIM, CxaC.Dt_Pgto_Rcto_HIM, CxaC.Num_Rcb_HIM, CxaC.Vlr_Pgto_Rcto_HIM, CtaC.Org_Ins_HIM, CxaC.Par_Moeda_HIM, 
				CtaD.Cd_Tp_Moeda, CtaD.Vlr_Org_HIM, CxaD.Dt_Pgto_Rcto_HIM, CxaD.Num_Rcb_HIM, CxaD.Vlr_Pgto_Rcto_HIM, CtaD.Org_Ins_HIM, CxaD.Par_Moeda_HIM, 
 				CtaMC.Cd_Tp_Moeda, CtaMC.Vlr_Org_MIM, CxaMC.Dt_Pgto_Rcto_MIM, CxaMC.Num_Rcb_MIM, CxaMC.Vlr_Pgto_Rcto_MIM, CtaMC.Org_Ins_MIM,
				CtaMD.Cd_Tp_Moeda, CxaMC.Par_Moeda_MIM, CtaMD.Vlr_Org_MIM, CxaMD.Dt_Pgto_Rcto_MIM, CxaMD.Num_Rcb_MIM, CxaMD.Vlr_Pgto_Rcto_MIM, CtaMD.Org_Ins_MIM,
				CxaMD.Par_Moeda_MIM
			Return 
		End 
	If @Modal = 'EA'
			Select 
				'EA' as Modal, MEA.Dt_Saida_MEA as Data,  MEA.Num_Proc_MEA as Proc_Master, HEA.Num_Proc_HEA as ProcHouse, PS.Apelido as Pessoa, MEA.MAWB_MEA as Master, HEA.HAWB_HEA as House, TT.Nome_Tp_Tx as Tipo_Taxa, 
				Trf_Net_MEA as Trf_Net, Peso_Real_HEA as Peso_Bruto_H, Vol_Tot_HEA as Vol_Tot_H, Peso_Bruto_MEA as Peso_Bruto_M, 
				CtaC.Cd_Tp_Moeda as MoedaC,  CtaC.Vlr_Org_HEA as Vlr_OrgC, CxaC.Dt_Pgto_Rcto_HEA as Dt_PgtC, CxaC.Num_Rcb_HEA as ReciboC, CxaC.Vlr_Pgto_Rcto_HEA as VlrPgoC, CtaC.Org_Ins_HEA as InserC, CxaC.Par_Moeda_HEA as Parid_C, 
				CtaD.Cd_Tp_Moeda as MoedaD, CtaD.Vlr_Org_HEA as Vlr_OrgD, CxaD.Dt_Pgto_Rcto_HEA as Dt_PgtD, CxaD.Num_Rcb_HEA as ReciboD, CxaD.Vlr_Pgto_Rcto_HEA as VlrPgoD, CtaD.Org_Ins_HEA as InserD, CxaD.Par_Moeda_HEA as Parid_D, 
 				CtaMC.Cd_Tp_Moeda as MoedaMC, CtaMC.Vlr_Org_MEA as Vlr_OrgMC, CxaMC.Dt_Pgto_Rcto_MEA as Dt_PgtMC, CxaMC.Num_Rcb_MEA as ReciboMC, CxaMC.Vlr_Pgto_Rcto_MEA as VlrPgoMC, CtaMC.Org_Ins_MEA as InserMC,
				CxaMC.Par_Moeda_MEA as Parid_MC, 
 				CtaMD.Cd_Tp_Moeda as MoedaMD, CtaMD.Vlr_Org_MEA as Vlr_OrgMD, CxaMD.Dt_Pgto_Rcto_MEA as Dt_PgtMD, CxaMD.Num_Rcb_MEA as ReciboMD, CxaMD.Vlr_Pgto_Rcto_MEA as VlrPgoMD, CtaMD.Org_Ins_MEA as InserMD,
				CxaMD.Par_Moeda_MEA as Parid_MD 
			From
				Master_Exp_Aer as MEA Join House_Exp_Aer as HEA on MEA.Num_Proc_MEA = HEA.Num_Proc_MEA 
				Join Pessoa as PS on HEA.Cd_Export_HEA = PS.Cd_Pes 
				Left Outer Join Cta_Cte_Hou_Exp_Aer as Cta on (HEA.Num_Proc_HEA = Cta.Num_Proc_HEA and Cta.Desp_Dst_HEA = 'N')
				Left Outer Join Tipo_Taxa as TT on (Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx)
				Left Outer Join Cta_Cte_Hou_Exp_Aer as CtaC on (Cta.Num_Proc_HEA = CtaC.Num_Proc_HEA and CtaC.DC_HEA = 'C' and CtaC.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Exp_Aer as CxaC on (CtaC.Num_Proc_HEA = CxaC.Num_Proc_HEA and CtaC.Cd_Tp_Tx = CxaC.Cd_Tp_Tx and CxaC.DC_HEA = CtaC.DC_HEA and CxaC.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Hou_Exp_Aer as CtaD on (Cta.Num_Proc_HEA = CtaD.Num_Proc_HEA and CtaD.DC_HEA = 'D' and CtaD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Exp_Aer as CxaD on (CtaD.Num_Proc_HEA = CxaD.Num_Proc_HEA and CtaD.Cd_Tp_Tx = CxaD.Cd_Tp_Tx and CtaD.DC_HEA = CxaD.DC_HEA and CxaD.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Mas_Exp_Aer as CtaMC on (Left(Cta.Num_Proc_HEA,14) = CtaMC.Num_Proc_MEA and CtaMC.DC_MEA = 'C' and CtaMC.Cd_Tp_Tx = Cta.Cd_Tp_Tx )
				Left Outer Join Caixa_Mas_Exp_Aer as CxaMC on (CTAMC.Num_Proc_MEA = CxaMC.Num_Proc_MEA and CtaMC.Cd_Tp_Tx = CxaMC.Cd_Tp_Tx and CtaMC.DC_MEA = CxaMC.DC_MEA)
				Left Outer Join Cta_Cte_Mas_Exp_Aer as CtaMD on (Left(Cta.Num_Proc_HEA,14) = CtaMD.Num_Proc_MEA and CtaMD.DC_MEA = 'D' and CtaMD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Mas_Exp_Aer as CxaMD on (CTAMD.Num_Proc_MEA = CxaMD.Num_Proc_MEA and CtaMD.Cd_Tp_Tx = CxaMD.Cd_Tp_Tx and CtaMD.DC_MEA = CxaMD.DC_MEA)
			Where
				HEA.Cd_Export_HEA Like @Cd_Pes and 
				Convert(DateTime, MEA.Dt_Saida_MEA, 105) between  @Dt_Inic and  @Dt_Fim
				
			Group by 
				MEA.Dt_Saida_MEA, MEA.Num_Proc_MEA, HEA.Num_Proc_HEA, PS.Apelido, MEA.MAWB_MEA, HEA.HAWB_HEA,TT.Nome_Tp_Tx, 
				Trf_Net_MEA, Peso_Real_HEA, Vol_Tot_HEA, Peso_Bruto_MEA,
				CtaC.Cd_Tp_Moeda, CtaC.Vlr_Org_HEA, CxaC.Dt_Pgto_Rcto_HEA, CxaC.Num_Rcb_HEA, CxaC.Vlr_Pgto_Rcto_HEA, CtaC.Org_Ins_HEA, CxaC.Par_Moeda_HEA, 
				CtaD.Cd_Tp_Moeda, CtaD.Vlr_Org_HEA, CxaD.Dt_Pgto_Rcto_HEA, CxaD.Num_Rcb_HEA, CxaD.Vlr_Pgto_Rcto_HEA, CtaD.Org_Ins_HEA, CxaD.Par_Moeda_HEA, 
 				CtaMC.Cd_Tp_Moeda, CtaMC.Vlr_Org_MEA, CxaMC.Dt_Pgto_Rcto_MEA, CxaMC.Num_Rcb_MEA, CxaMC.Vlr_Pgto_Rcto_MEA, CtaMC.Org_Ins_MEA,
				CxaMC.Par_Moeda_MEA, 
 				CtaMD.Cd_Tp_Moeda, CtaMD.Vlr_Org_MEA, CxaMD.Dt_Pgto_Rcto_MEA, CxaMD.Num_Rcb_MEA, CxaMD.Vlr_Pgto_Rcto_MEA, CtaMD.Org_Ins_MEA,
				CxaMD.Par_Moeda_MEA
	If @Modal = 'EM'
			Select 
				'EM' as Modal, MEM.Dt_Saida_MEM as Data, MEM.Num_Proc_MEM as Proc_Master, HEM.Num_Proc_HEM as ProcHouse, PS.Apelido as Pessoa, MEM.MAWB_MEM as Master, HEM.HAWB_HEM as House, TT.Nome_Tp_Tx as Tipo_Taxa, 
				Trf_Net_MEM as Trf_Net, Peso_Bruto_HEM as Peso_Bruto_H, Vol_Tot_HEM as Vol_Tot_H, Peso_Bruto_MEM as Peso_Bruto_M, 
				CtaC.Cd_Tp_Moeda as MoedaC, CtaC.Vlr_Org_HEM as Vlr_OrgC, CxaC.Dt_Pgto_Rcto_HEM as Dt_PgtC, CxaC.Num_Rcb_HEM as ReciboC, CxaC.Vlr_Pgto_Rcto_HEM as VlrPgoC, CtaC.Org_Ins_HEM as InserC, CxaC.Par_Moeda_HEM as Parid_C, 
				CtaD.Cd_Tp_Moeda as MoedaD, CtaD.Vlr_Org_HEM as Vlr_OrgD, CxaD.Dt_Pgto_Rcto_HEM as Dt_PgtD, CxaD.Num_Rcb_HEM as ReciboD, CxaD.Vlr_Pgto_Rcto_HEM as VlrPgoD, CtaD.Org_Ins_HEM as InserD, CxaD.Par_Moeda_HEM as Parid_D, 
 				CtaMC.Cd_Tp_Moeda as MoedaMC, CtaMC.Vlr_Org_MEM as Vlr_OrgMC, CxaMC.Dt_Pgto_Rcto_MEM as Dt_PgtMC, CxaMC.Num_Rcb_MEM as ReciboMC, CxaMC.Vlr_Pgto_Rcto_MEM as VlrPgoMC, CtaMC.Org_Ins_MEM as InserMC,
				CxaMC.Par_Moeda_MEM as Parid_MC, 
 				CtaMD.Cd_Tp_Moeda as MoedaMD, CtaMD.Vlr_Org_MEM as Vlr_OrgMD, CxaMD.Dt_Pgto_Rcto_MEM as Dt_PgtMD, CxaMD.Num_Rcb_MEM as ReciboMD, CxaMD.Vlr_Pgto_Rcto_MEM as VlrPgoMD, CtaMD.Org_Ins_MEM as InserMD,
				CxaMD.Par_Moeda_MEM as Parid_MD 
			From
				Master_Exp_Mar as MEM Join House_Exp_Mar as HEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM 
				Join Pessoa as PS on HEM.Cd_Export_HEM = PS.Cd_Pes 
				Left Outer Join Cta_Cte_Hou_Exp_Mar as Cta on (HEM.Num_Proc_HEM = Cta.Num_Proc_HEM and Cta.Desp_Dst_HEM = 'N')
				Left Outer Join Tipo_Taxa as TT on (Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx)
				Left Outer Join Cta_Cte_Hou_Exp_Mar as CtaC on (Cta.Num_Proc_HEM = CtaC.Num_Proc_HEM and CtaC.DC_HEM = 'C' and CtaC.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Exp_Mar as CxaC on (CtaC.Num_Proc_HEM = CxaC.Num_Proc_HEM and CtaC.Cd_Tp_Tx = CxaC.Cd_Tp_Tx and CxaC.DC_HEM = CtaC.DC_HEM and CxaC.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Hou_Exp_Mar as CtaD on (Cta.Num_Proc_HEM = CtaD.Num_Proc_HEM and CtaD.DC_HEM = 'D' and CtaD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Exp_Mar as CxaD on (CtaD.Num_Proc_HEM = CxaD.Num_Proc_HEM and CtaD.Cd_Tp_Tx = CxaD.Cd_Tp_Tx and CtaD.DC_HEM = CxaD.DC_HEM and CxaD.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Mas_Exp_Mar as CtaMC on (Left(Cta.Num_Proc_HEM,14) = CtaMC.Num_Proc_MEM and CtaMC.DC_MEM = 'C' and CtaMC.Cd_Tp_Tx = Cta.Cd_Tp_Tx )
				Left Outer Join Caixa_Mas_Exp_Mar as CxaMC on (CTAMC.Num_Proc_MEM = CxaMC.Num_Proc_MEM and CtaMC.Cd_Tp_Tx = CxaMC.Cd_Tp_Tx and CtaMC.DC_MEM = CxaMC.DC_MEM)
				Left Outer Join Cta_Cte_Mas_Exp_Mar as CtaMD on (Left(Cta.Num_Proc_HEM,14) = CtaMD.Num_Proc_MEM and CtaMD.DC_MEM = 'D' and CtaMD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Mas_Exp_Mar as CxaMD on (CTAMD.Num_Proc_MEM = CxaMD.Num_Proc_MEM and CtaMD.Cd_Tp_Tx = CxaMD.Cd_Tp_Tx and CtaMD.DC_MEM = CxaMD.DC_MEM)
			Where
				HEM.Cd_Export_HEM Like @Cd_Pes and 
				Convert(datetime, MEM.Dt_Saida_MEM, 105) between  @Dt_Inic and  @Dt_Fim
			Group by 
				MEM.Dt_Saida_MEM, MEM.Num_Proc_MEM, HEM.Num_Proc_HEM, PS.Apelido, MEM.MAWB_MEM, HEM.HAWB_HEM, HEM.HAWB_HEM,TT.Nome_Tp_Tx, 
				Trf_Net_MEM, Peso_Bruto_HEM, Vol_Tot_HEM, Peso_Bruto_MEM,
				CtaC.Cd_Tp_Moeda, CtaC.Vlr_Org_HEM, CxaC.Dt_Pgto_Rcto_HEM, CxaC.Num_Rcb_HEM, CxaC.Vlr_Pgto_Rcto_HEM, CtaC.Org_Ins_HEM, CxaC.Par_Moeda_HEM, 
				CtaD.Cd_Tp_Moeda, CtaD.Vlr_Org_HEM, CxaD.Dt_Pgto_Rcto_HEM, CxaD.Num_Rcb_HEM, CxaD.Vlr_Pgto_Rcto_HEM, CtaD.Org_Ins_HEM, CxaD.Par_Moeda_HEM, 
 				CtaMC.Cd_Tp_Moeda, CtaMC.Vlr_Org_MEM, CxaMC.Dt_Pgto_Rcto_MEM, CxaMC.Num_Rcb_MEM, CxaMC.Vlr_Pgto_Rcto_MEM, CtaMC.Org_Ins_MEM,
				CxaMC.Par_Moeda_MEM, 
				CtaMD.Cd_Tp_Moeda, CtaMD.Vlr_Org_MEM, CxaMD.Dt_Pgto_Rcto_MEM, CxaMD.Num_Rcb_MEM, CxaMD.Vlr_Pgto_Rcto_MEM, CtaMD.Org_Ins_MEM,
				CxaMD.Par_Moeda_MEM
	If @Modal = 'IA'
			
			Select 
				'IA' as Modal, MIA.Dt_Cheg_MIA as Data, MIA.Num_Proc_MIA as Proc_Master, HIA.Num_Proc_HIA as ProcHouse, PS.Apelido as Pessoa, MIA.MAWB_MIA as Master, HIA.HAWB_HIA as House, TT.Nome_Tp_Tx as Tipo_Taxa, 
				Null as Trf_Net, Peso_Bruto_HIA as Peso_Bruto_H, Vol_Tot_HIA as Vol_Tot_H, Peso_Bruto_MIA as Peso_Bruto_M, 
				CtaC.Cd_Tp_Moeda as MoedaC, CtaC.Vlr_Org_HIA as Vlr_OrgC, CxaC.Dt_Pgto_Rcto_HIA as Dt_PgtC, CxaC.Num_Rcb_HIA as ReciboC, CxaC.Vlr_Pgto_Rcto_HIA as VlrPgoC, CtaC.Org_Ins_HIA as InserC,  CxaC.Par_Moeda_HIA as Parid_C,
				CtaD.Cd_Tp_Moeda as MoedaD, CtaD.Vlr_Org_HIA as Vlr_OrgD, CxaD.Dt_Pgto_Rcto_HIA as Dt_PgtD, CxaD.Num_Rcb_HIA as ReciboD, CxaD.Vlr_Pgto_Rcto_HIA as VlrPgoD, CtaD.Org_Ins_HIA as InserD, CxaD.Par_Moeda_HIA as Parid_D,
 				CtaMC.Cd_Tp_Moeda as MoedaMC, CtaMC.Vlr_Org_MIA as Vlr_OrgMC, CxaMC.Dt_Pgto_Rcto_MIA as Dt_PgtMC, CxaMC.Num_Rcb_MIA as ReciboMC, CxaMC.Vlr_Pgto_Rcto_MIA as VlrPgoMC, CtaMC.Org_Ins_MIA as InserMC,
				CxaMC.Par_Moeda_MIA as Parid_MC, 
 				CtaMD.Cd_Tp_Moeda as MoedaMD, CtaMD.Vlr_Org_MIA as Vlr_OrgMD, CxaMD.Dt_Pgto_Rcto_MIA as Dt_PgtMD, CxaMD.Num_Rcb_MIA as ReciboMD, CxaMD.Vlr_Pgto_Rcto_MIA as VlrPgoMD, CtaMD.Org_Ins_MIA as InserMD,
				CxaMD.Par_Moeda_MIA as Parid_MD 
			From
				Master_Imp_Aer as MIA Join House_Imp_Aer as HIA on MIA.Num_Proc_MIA = HIA.Num_Proc_MIA 
				Join Pessoa as PS on HIA.Cd_Import_HIA = PS.Cd_Pes 
				Left Outer Join Cta_Cte_Hou_Imp_Aer as Cta on (HIA.Num_Proc_HIA = Cta.Num_Proc_HIA and Cta.Desp_Org_HIA = 'N')
				Left Outer Join Tipo_Taxa as TT on (Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx)
				Left Outer Join Cta_Cte_Hou_Imp_Aer as CtaC on (Cta.Num_Proc_HIA = CtaC.Num_Proc_HIA and CtaC.DC_HIA = 'C' and CtaC.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Imp_Aer as CxaC on (CtaC.Num_Proc_HIA = CxaC.Num_Proc_HIA and CtaC.Cd_Tp_Tx = CxaC.Cd_Tp_Tx and CxaC.DC_HIA = CtaC.DC_HIA and CxaC.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Hou_Imp_Aer as CtaD on (Cta.Num_Proc_HIA = CtaD.Num_Proc_HIA and CtaD.DC_HIA = 'D' and CtaD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Imp_Aer as CxaD on (CtaD.Num_Proc_HIA = CxaD.Num_Proc_HIA and CtaD.Cd_Tp_Tx = CxaD.Cd_Tp_Tx and CtaD.DC_HIA = CxaD.DC_HIA and CxaD.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Mas_Imp_Aer as CtaMC on (Left(Cta.Num_Proc_HIA,14) = CtaMC.Num_Proc_MIA and CtaMC.DC_MIA = 'C' and CtaMC.Cd_Tp_Tx = Cta.Cd_Tp_Tx )
				Left Outer Join Caixa_Mas_Imp_Aer as CxaMC on (CTAMC.Num_Proc_MIA = CxaMC.Num_Proc_MIA and CtaMC.Cd_Tp_Tx = CxaMC.Cd_Tp_Tx and CtaMC.DC_MIA = CxaMC.DC_MIA)
				Left Outer Join Cta_Cte_Mas_Imp_Aer as CtaMD on (Left(Cta.Num_Proc_HIA,14) = CtaMD.Num_Proc_MIA and CtaMD.DC_MIA = 'D' and CtaMD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Mas_Imp_Aer as CxaMD on (CTAMD.Num_Proc_MIA = CxaMD.Num_Proc_MIA and CtaMD.Cd_Tp_Tx = CxaMD.Cd_Tp_Tx and CtaMD.DC_MIA = CxaMD.DC_MIA)
			Where
				HIA.Cd_Import_HIA Like @Cd_Pes and 
				Convert(datetime, MIA.Dt_Cheg_MIA, 105) between  @Dt_Inic and  @Dt_Fim
			Group by 
				MIA.Dt_Cheg_MIA, MIA.Num_Proc_MIA, HIA.Num_Proc_HIA, PS.Apelido, MIA.MAWB_MIA, HIA.HAWB_HIA, HIA.HAWB_HIA,TT.Nome_Tp_Tx, 
				Peso_Bruto_HIA, Vol_Tot_HIA, Peso_Bruto_MIA, 
				CtaC.Cd_Tp_Moeda, CtaC.Vlr_Org_HIA, CxaC.Dt_Pgto_Rcto_HIA, CxaC.Num_Rcb_HIA, CxaC.Vlr_Pgto_Rcto_HIA, CtaC.Org_Ins_HIA, CxaC.Par_Moeda_HIA, 
				CtaD.Cd_Tp_Moeda, CtaD.Vlr_Org_HIA, CxaD.Dt_Pgto_Rcto_HIA, CxaD.Num_Rcb_HIA, CxaD.Vlr_Pgto_Rcto_HIA, CtaD.Org_Ins_HIA, CxaD.Par_Moeda_HIA, 
 				CtaMC.Cd_Tp_Moeda, CtaMC.Vlr_Org_MIA, CxaMC.Dt_Pgto_Rcto_MIA, CxaMC.Num_Rcb_MIA, CxaMC.Vlr_Pgto_Rcto_MIA, CtaMC.Org_Ins_MIA,
				CxaMC.Par_Moeda_MIA, 
				CtaMD.Cd_Tp_Moeda, CtaMD.Vlr_Org_MIA, CxaMD.Dt_Pgto_Rcto_MIA, CxaMD.Num_Rcb_MIA, CxaMD.Vlr_Pgto_Rcto_MIA, CtaMD.Org_Ins_MIA,
				CxaMD.Par_Moeda_MIA
	If @Modal = 'IM'
			
			Select 
				'IM' as Modal, MIM.Dt_Atrac_MIM as Data, MIM.Num_Proc_MIM as Proc_Master, HIM.Num_Proc_HIM as ProcHouse, PS.Apelido as Pessoa, MIM.MAWB_MIM as Master, HIM.HAWB_HIM as House, TT.Nome_Tp_Tx as Tipo_Taxa, 
				Null as Trf_Net, Peso_Bruto_HIM as Peso_Bruto_H, Vol_Tot_HIM as Vol_Tot_H, Peso_Bruto_MIM as Peso_Bruto_M, 
				CtaC.Cd_Tp_Moeda as MoedaC, CtaC.Vlr_Org_HIM as Vlr_OrgC, CxaC.Dt_Pgto_Rcto_HIM as Dt_PgtC, CxaC.Num_Rcb_HIM as ReciboC, CxaC.Vlr_Pgto_Rcto_HIM as VlrPgoC, CtaC.Org_Ins_HIM as InserC,  CxaC.Par_Moeda_HIM as Parid_D,
				CtaD.Cd_Tp_Moeda as MoedaD, CtaD.Vlr_Org_HIM as Vlr_OrgD, CxaD.Dt_Pgto_Rcto_HIM as Dt_PgtD, CxaD.Num_Rcb_HIM as ReciboD, CxaD.Vlr_Pgto_Rcto_HIM as VlrPgoD, CtaD.Org_Ins_HIM as InserD, CxaD.Par_Moeda_HIM as Parid_D,
 				CtaMC.Cd_Tp_Moeda as MoedaMC, CtaMC.Vlr_Org_MIM as Vlr_OrgMC, CxaMC.Dt_Pgto_Rcto_MIM as Dt_PgtMC, CxaMC.Num_Rcb_MIM as ReciboMC, CxaMC.Vlr_Pgto_Rcto_MIM as VlrPgoMC, CtaMC.Org_Ins_MIM as InserMC,
				CxaMC.Par_Moeda_MIM as Parid_MC, 
 				CtaMD.Cd_Tp_Moeda as MoedaMD, CtaMD.Vlr_Org_MIM as Vlr_OrgMD, CxaMD.Dt_Pgto_Rcto_MIM as Dt_PgtMD, CxaMD.Num_Rcb_MIM as ReciboMD, CxaMD.Vlr_Pgto_Rcto_MIM as VlrPgoMD, CtaMD.Org_Ins_MIM as InserMD,
				CxaMD.Par_Moeda_MIM as Parid_MD 
			From
				Master_Imp_Mar as MIM Join House_Imp_Mar as HIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM 
				Join Pessoa as PS on HIM.Cd_Import_HIM = PS.Cd_Pes 
				Left Outer Join Cta_Cte_Hou_Imp_Mar as Cta on (HIM.Num_Proc_HIM = Cta.Num_Proc_HIM and Cta.Desp_Org_HIM = 'N')
				Left Outer Join Tipo_Taxa as TT on (Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx)
				Left Outer Join Cta_Cte_Hou_Imp_Mar as CtaC on (Cta.Num_Proc_HIM = CtaC.Num_Proc_HIM and CtaC.DC_HIM = 'C' and CtaC.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Imp_Mar as CxaC on (CtaC.Num_Proc_HIM = CxaC.Num_Proc_HIM and CtaC.Cd_Tp_Tx = CxaC.Cd_Tp_Tx and CxaC.DC_HIM = CtaC.DC_HIM and CxaC.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Hou_Imp_Mar as CtaD on (Cta.Num_Proc_HIM = CtaD.Num_Proc_HIM and CtaD.DC_HIM = 'D' and CtaD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Hou_Imp_Mar as CxaD on (CtaD.Num_Proc_HIM = CxaD.Num_Proc_HIM and CtaD.Cd_Tp_Tx = CxaD.Cd_Tp_Tx and CtaD.DC_HIM = CxaD.DC_HIM and CxaD.Num_Lcto <>'PROVISÓRIO')
				Left Outer Join Cta_Cte_Mas_Imp_Mar as CtaMC on (Left(Cta.Num_Proc_HIM,14) = CtaMC.Num_Proc_MIM and CtaMC.DC_MIM = 'C' and CtaMC.Cd_Tp_Tx = Cta.Cd_Tp_Tx )
				Left Outer Join Caixa_Mas_Imp_Mar as CxaMC on (CTAMC.Num_Proc_MIM = CxaMC.Num_Proc_MIM and CtaMC.Cd_Tp_Tx = CxaMC.Cd_Tp_Tx and CtaMC.DC_MIM = CxaMC.DC_MIM)
				Left Outer Join Cta_Cte_Mas_Imp_Mar as CtaMD on (Left(Cta.Num_Proc_HIM,14) = CtaMD.Num_Proc_MIM and CtaMD.DC_MIM = 'D' and CtaMD.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
				Left Outer Join Caixa_Mas_Imp_Mar as CxaMD on (CTAMD.Num_Proc_MIM = CxaMD.Num_Proc_MIM and CtaMD.Cd_Tp_Tx = CxaMD.Cd_Tp_Tx and CtaMD.DC_MIM = CxaMD.DC_MIM)
			Where
				HIM.Cd_Import_HIM Like @Cd_Pes and 
				Convert(datetime, MIM.Dt_Atrac_MIM, 105) between  @Dt_Inic and  @Dt_Fim
			Group by 
				Dt_Atrac_MIM, MIM.Num_Proc_MIM, HIM.Num_Proc_HIM, PS.Apelido, MIM.MAWB_MIM, HIM.HAWB_HIM,TT.Nome_Tp_Tx, 
				Peso_Bruto_HIM, Vol_Tot_HIM, Peso_Bruto_MIM, 
				CtaC.Cd_Tp_Moeda, CtaC.Vlr_Org_HIM, CxaC.Dt_Pgto_Rcto_HIM, CxaC.Num_Rcb_HIM, CxaC.Vlr_Pgto_Rcto_HIM, CtaC.Org_Ins_HIM, CxaC.Par_Moeda_HIM, 
				CtaD.Cd_Tp_Moeda, CtaD.Vlr_Org_HIM, CxaD.Dt_Pgto_Rcto_HIM, CxaD.Num_Rcb_HIM, CxaD.Vlr_Pgto_Rcto_HIM, CtaD.Org_Ins_HIM, CxaD.Par_Moeda_HIM, 
 				CtaMC.Cd_Tp_Moeda, CtaMC.Vlr_Org_MIM, CxaMC.Dt_Pgto_Rcto_MIM, CxaMC.Num_Rcb_MIM, CxaMC.Vlr_Pgto_Rcto_MIM, CtaMC.Org_Ins_MIM,
				CtaMD.Cd_Tp_Moeda, CxaMC.Par_Moeda_MIM, CtaMD.Vlr_Org_MIM, CxaMD.Dt_Pgto_Rcto_MIM, CxaMD.Num_Rcb_MIM, CxaMD.Vlr_Pgto_Rcto_MIM, CtaMD.Org_Ins_MIM,
				CxaMD.Par_Moeda_MIM
GO
