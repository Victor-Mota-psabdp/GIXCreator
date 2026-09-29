SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE Procedure  pCtaCteOpos_Sel 
(
@DataInic	varchar(10),
@DataFinal	varchar(10),
@CredDev 	varchar(25)='%',
@Taxa		varchar(30)='%'
)
AS
Declare @Inicio		DateTime 
Declare @Fim		DateTime 
Set @Inicio = convert(datetime, @DataInic, 105)
Set @Fim = convert(datetime, @DataFinal, 105)
Select 
	Cte.Num_Proc_HIM as Processo, TT.Nome_Tp_Tx as Taxa, Cte.DC_HIM as DC, Ps.Apelido as CredDev, 
	Cte.Cd_Tp_Moeda as TipoMoeda, Cte.Vlr_Org_HIM as ValorOrigem, Cast(Cxa.Par_Moeda_HIM as Float) as Paridade,
	convert(datetime,Cxa.Dt_Pgto_Rcto_HIM, 105) as  DtPagamento,  CteOps.Cd_Tp_Moeda as MoedaOps, Cxa.Vlr_Ref_HIM as Vlr_Ref,
	Sum(TotPagto.Vlr_Ref_HIM) as TotalPagto 
From 
	Cta_Cte_Hou_Imp_Mar Cte Left Outer Join Caixa_Hou_Imp_Mar as Cxa on (Cte.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.Dc_HIM = Cxa.DC_HIM and convert(datetime, Cxa.Dt_Pgto_Rcto_HIM, 105) <= @Fim )
	Left Outer Join Caixa_Hou_Imp_Mar as  TotPagto on (Cte.Num_Proc_HIM = TotPagto.Num_Proc_HIM and Cte.Cd_Tp_Tx = TotPagto.Cd_Tp_Tx and Cte.Dc_HIM = TotPagto.DC_HIM and convert(datetime, TotPagto.Dt_Pgto_Rcto_HIM, 105) <= @Fim and TotPagto.Num_Lcto <> 'PROVISORIO' )
	Left Outer Join Cta_Cte_Hou_Imp_Mar as CteOps on (Cxa.Num_Proc_HIM = CteOps.Num_Proc_HIM and  Cxa.Cd_Tp_Tx = CteOps.Cd_Tp_Tx and Cxa.DC_HIM = CteOps.Dc_HIM )
	Join Tipo_Taxa as TT on (Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx) 
	Join Tipo_Moeda as TM on (Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda)
	Join Pessoa as PS on (Cte.Cd_Cred_Dev_HIM = PS.Cd_Pes)
Where
	Ps.Apelido like @CredDev  
	and Cte.Desp_Org_HIM = 'N'
	and convert(datetime, Cte.Dt_Ins_HIM, 105) between  @Inicio and  @Fim
	and TT.Nome_Tp_Tx Like @Taxa 
Group by 
	Cte.Num_Proc_HIM, TT.Nome_Tp_Tx, Cte.DC_HIM, Ps.Apelido, 
	Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HIM, Cxa.Par_Moeda_HIM, 
	Cxa.Dt_Pgto_Rcto_HIM,  CteOps.Cd_Tp_Moeda,  Cxa.Vlr_Ref_HIM
Union 
--MIM 
---------
Select 
	Cte.Num_Proc_MIM as Processo, TT.Nome_Tp_Tx as Taxa, Cte.DC_MIM as DC, Ps.Apelido as CredDev, 
	Cte.Cd_Tp_Moeda as TipoMoeda, Cte.Vlr_Org_MIM as ValorOrigem, Cast(Cxa.Par_Moeda_MIM as Float) as Paridade,
	convert(datetime, Cxa.Dt_Pgto_Rcto_MIM, 105) as  DtPagamento, CteOps.Cd_Tp_Moeda as MoedaOps, Cxa.Vlr_Ref_MIM as Vlr_Ref,
	Sum(TotPagto.Vlr_Ref_MIM) as TotalPagto 
From 
	Cta_Cte_Mas_Imp_Mar Cte Left Outer Join Caixa_Mas_Imp_Mar Cxa on (Cte.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.Dc_MIM <> Cxa.DC_MIM and convert(datetime,Cxa.Dt_Pgto_Rcto_MIM, 105)  <=  @Fim)
	Left Outer Join Caixa_Mas_Imp_Mar TotPagto on (Cte.Num_Proc_MIM = TotPagto.Num_Proc_MIM and Cte.Cd_Tp_Tx = TotPagto.Cd_Tp_Tx and Cte.Dc_MIM = TotPagto.DC_MIM and convert(datetime, TotPagto.Dt_Pgto_Rcto_MIM, 105) <= @Fim  and TotPagto.Num_Lcto <> 'PROVISORIO')
	Left Outer Join Cta_Cte_Mas_Imp_Mar as CteOps on (Cxa.Num_Proc_MIM = CteOps.Num_Proc_MIM and  Cxa.Cd_Tp_Tx = CteOps.Cd_Tp_Tx and Cxa.DC_MIM = CteOps.Dc_MIM)
	Join Tipo_Taxa as TT on (Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx) 
	Join Tipo_Moeda as TM on (Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda)
	Join Pessoa as PS on (Cte.Cd_Cred_Dev_MIM = PS.Cd_Pes)
Where
	Ps.Apelido like @CredDev  
	and Cte.Desp_Org_MIM = 'N'
	and convert(datetime, Cte.Dt_Ins_MIM, 105) between @Inicio and @Fim
	and TT.Nome_Tp_Tx Like @Taxa 
Group by 
	Cte.Num_Proc_MIM, TT.Nome_Tp_Tx, Cte.DC_MIM,  Ps.Apelido,  
	Cte.Cd_Tp_Moeda, Cte.Vlr_Org_MIM, Cxa.Par_Moeda_MIM, 
	Cxa.Dt_Pgto_Rcto_MIM, CteOps.Cd_Tp_Moeda, Cxa.Vlr_Ref_MIM
Union
--HEM 
---------
Select 
	Cte.Num_Proc_HEM as Processo, TT.Nome_Tp_Tx as Taxa, Cte.DC_HEM as DC, Ps.Apelido as CredDev, 
	Cte.Cd_Tp_Moeda as TipoMoeda, Cte.Vlr_Org_HEM as ValorOrigem, Cast(Cxa.Par_Moeda_HEM as Float) as Paridade,
	convert(datetime,Cxa.Dt_Pgto_Rcto_HEM, 105) as  DtPagamento,  CteOps.Cd_Tp_Moeda as MoedaOps, Cxa.Vlr_Ref_HEM as Vlr_Ref,
	Sum(TotPagto.Vlr_Ref_HEM) as TotalPagto 
From 
	Cta_Cte_Hou_Exp_Mar Cte Left Outer Join Caixa_Hou_Exp_Mar Cxa on (Cte.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.Dc_HEM <> Cxa.DC_HEM and  Convert(datetime, Cxa.Dt_Pgto_Rcto_HEM, 105)  <= @Fim)
	Left Outer Join Caixa_Hou_Exp_Mar TotPagto on (Cte.Num_Proc_HEM = TotPagto.Num_Proc_HEM and Cte.Cd_Tp_Tx = TotPagto.Cd_Tp_Tx and Cte.Dc_HEM = TotPagto.DC_HEM and convert(datetime, TotPagto.Dt_Pgto_Rcto_HEM, 105) <= @Fim and TotPagto.Num_Lcto <> 'PROVISORIO')
	Left Outer Join Cta_Cte_Hou_Exp_Mar as CteOps on (Cxa.Num_Proc_HEM = CteOps.Num_Proc_HEM and  Cxa.Cd_Tp_Tx = CteOps.Cd_Tp_Tx and Cxa.DC_HEM = CteOps.Dc_HEM)
	Join Tipo_Taxa as TT on (Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx) 
	Join Tipo_Moeda as TM on (Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda)
	Join Pessoa as PS on (Cte.Cd_Cred_Dev_HEM = PS.Cd_Pes)
Where
	Ps.Apelido like @CredDev  
	and Cte.Desp_Dst_HEM = 'N'
	and convert(datetime, Cte.Dt_Ins_HEM, 105) between @Inicio and  @Fim
	and TT.Nome_Tp_Tx Like @Taxa 
Group By 
	Cte.Num_Proc_HEM, TT.Nome_Tp_Tx, Cte.DC_HEM, Ps.Apelido, 
	Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HEM, Cxa.Par_Moeda_HEM, 
	Cxa.Dt_Pgto_Rcto_HEM, CteOps.Cd_Tp_Moeda, Cxa.Vlr_Ref_HEM 
	
Union 
--MEM 
---------
Select 
	Cte.Num_Proc_MEM as Processo, TT.Nome_Tp_Tx as Taxa, Cte.DC_MEM as DC, Ps.Apelido as CredDev, 
	Cte.Cd_Tp_Moeda as TipoMoeda, Cte.Vlr_Org_MEM as ValorOrigem, Cast(Cxa.Par_Moeda_MEM as Float) as Paridade,
	convert(datetime, Cxa.Dt_Pgto_Rcto_MEM, 105) as  DtPagamento,  CteOps.Cd_Tp_Moeda as MoedaOps, Cxa.Vlr_Ref_MEM as Vlr_Ref,
	Sum(TotPagto.Vlr_Ref_MEM) as TotalPagto 
From 
	Cta_Cte_Mas_Exp_Mar Cte Left Outer Join Caixa_Mas_Exp_Mar Cxa on (Cte.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.Dc_MEM <> Cxa.DC_MEM and  Convert(DateTime, Cxa.Dt_Pgto_Rcto_MEM, 105)  <=  @Fim)
	Left Outer Join Caixa_Mas_Exp_Mar TotPagto on (Cte.Num_Proc_MEM = TotPagto.Num_Proc_MEM and Cte.Cd_Tp_Tx = TotPagto.Cd_Tp_Tx and Cte.Dc_MEM = TotPagto.DC_MEM and convert(datetime, TotPagto.Dt_Pgto_Rcto_MEM, 105) <= @Fim and TotPagto.Num_Lcto <> 'PROVISORIO')
	Left Outer Join Cta_Cte_Mas_Exp_Mar as CteOps on (Cxa.Num_Proc_MEM = CteOps.Num_Proc_MEM  and  Cxa.Cd_Tp_Tx = CteOps.Cd_Tp_Tx and Cxa.DC_MEM = CteOps.Dc_MEM)
	Join Tipo_Taxa as TT on (Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx) 
	Join Tipo_Moeda as TM on (Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda)
	Join Pessoa as PS on (Cte.Cd_Cred_Dev_MEM = PS.Cd_Pes)
Where
	Ps.Apelido like @CredDev  
	and Cte.Desp_Dst_MEM = 'N'
	and convert(datetime, Cte.Dt_Ins_MEM, 105) between @Inicio and  @Fim
	and TT.Nome_Tp_Tx Like @Taxa 
Group by 
	Cte.Num_Proc_MEM,  TT.Nome_Tp_Tx,  Cte.DC_MEM, Ps.Apelido, 
	Cte.Cd_Tp_Moeda, Cte.Vlr_Org_MEM, Cxa.Par_Moeda_MEM,
	Cxa.Dt_Pgto_Rcto_MEM,  CteOps.Cd_Tp_Moeda, Cxa.Vlr_Ref_MEM
Union
--HIA 
---------
Select 
	Cte.Num_Proc_HIA as Processo, TT.Nome_Tp_Tx as Taxa, Cte.DC_HIA as DC, Ps.Apelido as CredDev, 
	Cte.Cd_Tp_Moeda as TipoMoeda, Cte.Vlr_Org_HIA as ValorOrigem, Cast(Cxa.Par_Moeda_HIA as Float) as Paridade,
	convert(datetime, Cxa.Dt_Pgto_Rcto_HIA, 105) as  DtPagamento,  CteOps.Cd_Tp_Moeda as MoedaOps, Cxa.Vlr_Ref_HIA as Vlr_Ref,
	Sum(TotPagto.Vlr_Ref_HIA) as TotalPagto 
From 
	Cta_Cte_Hou_Imp_Aer Cte Left Outer Join Caixa_Hou_Imp_Aer Cxa on (Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.Dc_HIA <> Cxa.DC_HIA and Convert(DateTime, Cxa.Dt_Pgto_Rcto_HIA, 105)  <=  @Fim)
	Left Outer Join Caixa_Hou_Imp_Aer TotPagto on (Cte.Num_Proc_HIA = TotPagto.Num_Proc_HIA and Cte.Cd_Tp_Tx = TotPagto.Cd_Tp_Tx and Cte.Dc_HIA = TotPagto.DC_HIA and convert(datetime, TotPagto.Dt_Pgto_Rcto_HIA, 105) <= @Fim and TotPagto.Num_Lcto <> 'PROVISORIO')
	Left Outer Join Cta_Cte_Hou_Imp_Aer as CteOps on (Cxa.Num_Proc_HIA = CteOps.Num_Proc_HIA  and  Cxa.Cd_Tp_Tx = CteOps.Cd_Tp_Tx and Cxa.DC_HIA = CteOps.Dc_HIA )
	Join Tipo_Taxa as TT on (Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx) 
	Join Tipo_Moeda as TM on (Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda)
	Join Pessoa as PS on (Cte.Cd_Cred_Dev_HIA = PS.Cd_Pes)
Where
	Ps.Apelido like @CredDev  
	and Cte.Desp_Org_HIA = 'N'
	and convert(datetime, Cte.Dt_Ins_HIA, 105) between @Inicio and @Fim
	and TT.Nome_Tp_Tx Like @Taxa 
Group by
	Cte.Num_Proc_HIA, TT.Nome_Tp_Tx, Cte.DC_HIA, Ps.Apelido, 
	Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HIA, Cxa.Par_Moeda_HIA ,
	Cxa.Dt_Pgto_Rcto_HIA,  CteOps.Cd_Tp_Moeda, Cxa.Vlr_Ref_HIA
Union 
--MIA 
---------
Select 
	Cte.Num_Proc_MIA as Processo, TT.Nome_Tp_Tx as Taxa, Cte.DC_MIA as DC, Ps.Apelido as CredDev, 
	Cte.Cd_Tp_Moeda as TipoMoeda, Cte.Vlr_Org_MIA as ValorOrigem, Cast(Cxa.Par_Moeda_MIA as Float) as Paridade,
	convert(datetime, Cxa.Dt_Pgto_Rcto_MIA, 105) as  DtPagamento,  CteOps.Cd_Tp_Moeda as MoedaOps, Cxa.Vlr_Ref_MIA as Vlr_Ref,
	Sum(TotPagto.Vlr_Ref_MIA) as TotalPagto 
From 
	Cta_Cte_Mas_Imp_Aer Cte Left Outer Join Caixa_Mas_Imp_Aer Cxa on (Cte.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.Dc_MIA <> Cxa.DC_MIA and  Convert(DateTime, Cxa.Dt_Pgto_Rcto_MIA, 105)  <=  @Fim)
	Left Outer Join Caixa_Mas_Imp_Aer TotPagto on (Cte.Num_Proc_MIA = TotPagto.Num_Proc_MIA and Cte.Cd_Tp_Tx = TotPagto.Cd_Tp_Tx and Cte.Dc_MIA = TotPagto.DC_MIA and convert(datetime, TotPagto.Dt_Pgto_Rcto_MIA, 105) <= @Fim and TotPagto.Num_Lcto <> 'PROVISORIO')
	Left Outer Join Cta_Cte_Mas_Imp_Aer as CteOps on (Cxa.Num_Proc_MIA = CteOps.Num_Proc_MIA and  Cxa.Cd_Tp_Tx = CteOps.Cd_Tp_Tx and Cxa.DC_MIA = CteOps.Dc_MIA)
	Join Tipo_Taxa as TT on (Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx) 
	Join Tipo_Moeda as TM on (Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda)
	Join Pessoa as PS on (Cte.Cd_Cred_Dev_MIA = PS.Cd_Pes)
Where
	Ps.Apelido like @CredDev  
	and Cte.Desp_Org_MIA = 'N'
	and convert(datetime, Cte.Dt_Ins_MIA, 105) between @Inicio and  @Fim
	and TT.Nome_Tp_Tx Like @Taxa 
Group by 
	Cte.Num_Proc_MIA, TT.Nome_Tp_Tx, Cte.DC_MIA, Ps.Apelido, 
	Cte.Cd_Tp_Moeda, Cte.Vlr_Org_MIA, Cxa.Par_Moeda_MIA,
	Cxa.Dt_Pgto_Rcto_MIA,  CteOps.Cd_Tp_Moeda, Cxa.Vlr_Ref_MIA
Union 
--HEA 
---------
Select 
	Cte.Num_Proc_HEA as Processo, TT.Nome_Tp_Tx as Taxa, Cte.DC_HEA as DC, Ps.Apelido as CredDev, 
	Cte.Cd_Tp_Moeda as TipoMoeda, Cte.Vlr_Org_HEA as ValorOrigem, Cast(Cxa.Par_Moeda_HEA as Float) as Paridade,
	convert(datetime, Cxa.Dt_Pgto_Rcto_HEA, 105) as  DtPagamento,  CteOps.Cd_Tp_Moeda as MoedaOps, Cxa.Vlr_Ref_HEA as Vlr_Ref,
	Sum(TotPagto.Vlr_Ref_HEA) as TotalPagto 
From 
	Cta_Cte_Hou_Exp_Aer Cte Left Outer Join Caixa_Hou_Exp_Aer Cxa on (Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.Dc_HEA <> Cxa.DC_HEA and Convert(DateTime, Cxa.Dt_Pgto_Rcto_HEA, 105)  <=  @Fim)
	Left Outer Join Caixa_Hou_Exp_Aer TotPagto on (Cte.Num_Proc_HEA = TotPagto.Num_Proc_HEA and Cte.Cd_Tp_Tx = TotPagto.Cd_Tp_Tx and Cte.Dc_HEA = TotPagto.DC_HEA and convert(datetime, TotPagto.Dt_Pgto_Rcto_HEA, 105) <= @Fim and TotPagto.Num_Lcto <> 'PROVISORIO')
	Left Outer Join Cta_Cte_Hou_Exp_Aer as CteOps on (Cxa.Num_Proc_HEA = CteOps.Num_Proc_HEA and  Cxa.Cd_Tp_Tx = CteOps.Cd_Tp_Tx and Cxa.DC_HEA = CteOps.Dc_HEA)
	Join Tipo_Taxa as TT on (Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx) 
	Join Tipo_Moeda as TM on (Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda)
	Join Pessoa as PS on (Cte.Cd_Cred_Dev_HEA = PS.Cd_Pes)
Where
	Ps.Apelido like @CredDev  
	and Cte.Desp_Dst_HEA = 'N'
	and convert(datetime, Cte.Dt_Ins_HEA, 105) between @Inicio and @Fim
	and TT.Nome_Tp_Tx Like @Taxa 
Group by 
	Cte.Num_Proc_HEA, TT.Nome_Tp_Tx, Cte.DC_HEA, Ps.Apelido, 
	Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HEA, Cxa.Par_Moeda_HEA, 
	Cxa.Dt_Pgto_Rcto_HEA,  CteOps.Cd_Tp_Moeda, Cxa.Vlr_Ref_HEA
Union
--MEA 
---------
Select 
	Cte.Num_Proc_MEA as Processo, TT.Nome_Tp_Tx as Taxa, Cte.DC_MEA as DC, Ps.Apelido as CredDev, 
	Cte.Cd_Tp_Moeda as TipoMoeda, Cte.Vlr_Org_MEA as ValorOrigem, Cast(Cxa.Par_Moeda_MEA as Float) as Paridade,
	convert(datetime, Cxa.Dt_Pgto_Rcto_MEA, 105) as  DtPagamento,  CteOps.Cd_Tp_Moeda as MoedaOps, Cxa.Vlr_Ref_MEA as Vlr_Ref,
	Sum(TotPagto.Vlr_Ref_MEA) as TotalPagto 
From 
	Cta_Cte_Mas_Exp_Aer Cte Left Outer Join Caixa_Mas_Exp_Aer Cxa on (Cte.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.Dc_MEA <> Cxa.DC_MEA and Convert(DateTime, Cxa.Dt_Pgto_Rcto_MEA, 105)  <= @Fim)
	Left Outer Join Caixa_Mas_Exp_Aer TotPagto on (Cte.Num_Proc_MEA = TotPagto.Num_Proc_MEA and Cte.Cd_Tp_Tx = TotPagto.Cd_Tp_Tx and Cte.Dc_MEA = TotPagto.DC_MEA and convert(datetime, TotPagto.Dt_Pgto_Rcto_MEA, 105) <= @Fim and TotPagto.Num_Lcto <> 'PROVISORIO')
	Left Outer Join Cta_Cte_Mas_Exp_Aer as CteOps on (Cxa.Num_Proc_MEA = CteOps.Num_Proc_MEA  and  Cxa.Cd_Tp_Tx = CteOps.Cd_Tp_Tx and Cxa.DC_MEA = CteOps.Dc_MEA)
	Join Tipo_Taxa as TT on (Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx) 
	Join Tipo_Moeda as TM on (Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda)
	Join Pessoa as PS on (Cte.Cd_Cred_Dev_MEA = PS.Cd_Pes)
Where
	Ps.Apelido like @CredDev  
	and Cte.Desp_Dst_MEA = 'N'
	and convert(datetime, Cte.Dt_Ins_MEA, 105) between @Inicio and @Fim
	and TT.Nome_Tp_Tx Like @Taxa
Group by
	Cte.Num_Proc_MEA, TT.Nome_Tp_Tx, Cte.DC_MEA, Ps.Apelido, 
	Cte.Cd_Tp_Moeda, Cte.Vlr_Org_MEA, Cxa.Par_Moeda_MEA, 
	Cxa.Dt_Pgto_Rcto_MEA,  CteOps.Cd_Tp_Moeda, Cxa.Vlr_Ref_MEA
GO
