SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[spATL_Remessa_Rel] '','2012-01-01','2018-12-31'
CREATE Procedure [dbo].[spATL_Remessa_Rel]

@Remessa	varchar(12),
@DtInicial	Datetime,
@DtFinal DateTime


As
If @Remessa is null or @Remessa = ''
	Begin
	 set @Remessa = '%'
	End
if @DtInicial is null and @DtFinal is null
	Begin
		set @DtInicial = '1990/01/01'
		set @DtFinal = GETDATE()
	End

declare @Temp table
(
Remessa varchar(max),	
Ref_BDP varchar(max),		
DtRemessa datetime,
OrgMoeda varchar(max),		
FinalMoeda varchar(max),		
Agente varchar(max),	
VlTxFrete float,	
VlTotRemessa float,		
MAWB varchar(100),	
HAMB varchar(100),	
Ref_Internacional varchar(max),		
Banco varchar(500),	
TpFrete varchar(100),		
Cd_Taxa varchar(100),
NomeTaxa varchar(500),	
DC varchar(50),
VlrTaxa float,	
VlrReal float,
Paridade_Remessa float,	
Paridade_Recebimento float,			
TipoEndereco varchar(500),	
Rua_E varchar(500),
Numero_E varchar(500),	
Complemento_E varchar(500),	
CEP_E varchar(500),
Bairro_E varchar(500),	
Cidade_E varchar(500)	
)



insert @Temp
--Import Aereo
select
	RA.num_ref_ra			Remessa,
	HOU.Num_Proc_Hia		Ref_BDP,
	convert(datetime,RA.DT_RA,103)				DtRemessa,
	RA.Cd_Tp_Moeda_C_RA		OrgMoeda,
	RA.Cd_Tp_Moeda_F_RA		FinalMoeda,
	AG.Nome_Raz_Soc			Agente,
	RA.Tx_Fchto_RA			VlTxFrete,
	RA.Vlr_Tot_Fchto_RA		VlTotRemessa,
	HOU.MAWB_HIA			MAWB,
	HOU.HAWB_hia			HAMB,
	isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_proc_Hia,'74'),RI.Intl_Ref_LIA)	Ref_Internacional,
	NBC.Nome_Banco			Banco,
	HOU.Tp_Frete_HIA		TpFrete,
	CA.Cd_Tp_Tx				Cd_Taxa,
	TX.Nome_Tp_Tx			NomeTaxa,
	CA.DC_Hia				DC,
	CA.Vlr_Ref_HIA			VlrTaxa,
	CA.Vlr_Pgto_Rcto_HIA	VlrReal,
	CA.Par_Moeda_hia		Paridade_Remessa,
	Isnull(CXO.Par_Moeda_HIA,CA.Par_Moeda_hia)	Paridade_Recebimento,
	ENDAG.Cd_Tp_End			TipoEndereco,
	ENDAG.Rua				Rua_E,
	ENDAG.Numero			Numero_E,
	ENDAG.Compl_End			Complemento_E,
	ENDAG.CEP				CEP_E,
	ENDAG.Bairro			Bairro_E,
	ENDAG.Cidade			Cidade_E

from
	Remessa_Aer RA with(nolock)
	join Caixa_hou_imp_Aer CA with(nolock)	on CA.num_Rcb_hia = RA.Num_ref_RA
	join house_Imp_Aer HOU with(nolock)		on HOU.num_proc_hia = CA.num_proc_hia
	left join Tipo_Taxa TX with(nolock)		on TX.cd_tp_Tx = CA.cd_tp_Tx
	left join Pessoa AG with(nolock)			on AG.Cd_Pes = RA.cd_pes
	left join Endereco ENDAG with(nolock)	on ENDAG.cd_pes = AG.cd_pes
	left join LLP_Imp_Aer RI with(nolock)	on RI.Num_Proc_Lia = HOU.Num_Proc_HIA
	left Join Cta_Cte BC with(nolock)		on BC.Cd_Banco = RA.Cd_Banco
	left join Agencia AGBC with(nolock)		on AGBC.cd_banco = BC.Cd_Banco and AGBC.Cd_Agencia = RA.Cd_Agencia
	left join Banco NBC	with(nolock)		on NBC.Cd_Banco = AGBC.cd_banco
	Left Join Caixa_Hou_Imp_Aer  CXO with(nolock) on CA.num_proc_hia=CXO.num_proc_hia and CA.cd_Tp_tx=CXO.cd_tp_tx and CA.dc_hia <> CXO.dc_hia
where
	convert(datetime,RA.DT_RA,103) between @DtInicial and @DtFinal and 
	RA.num_ref_ra like @Remessa
group by
	RA.num_ref_ra,
	RA.DT_RA,
	RA.Cd_Tp_Moeda_C_RA,
	RA.Cd_Tp_Moeda_F_RA,
	AG.Nome_Raz_Soc,
	RA.Tx_Fchto_RA,
	RA.Vlr_Tot_Fchto_RA,
	HOU.MAWB_HIA,
	HOU.Num_Proc_Hia,
	HOU.HAWB_hia,
	NBC.Nome_Banco,
	RI.Intl_Ref_LIA,
	HOU.Tp_Frete_HIA,
	CA.Cd_Tp_Tx,
	CA.DC_Hia,
	CA.Vlr_Ref_HIA,
	TX.Nome_Tp_Tx,
	CA.Vlr_Pgto_Rcto_HIA,
	CA.Par_Moeda_HIA,
	CXO.Par_Moeda_HIA,
	ENDAG.Cd_Tp_End	,
	ENDAG.Rua,
	ENDAG.Numero,
	ENDAG.Compl_End,
	ENDAG.CEP,
	ENDAG.Bairro,
	ENDAG.Cidade
Union
--Export Aereo
select
	RA.num_ref_ra			Remessa,
	HOU.Num_Proc_Hea		Ref_BDP,
	convert(datetime,RA.DT_RA,103)				DtRemessa,
	RA.Cd_Tp_Moeda_C_RA		OrgMoeda,
	RA.Cd_Tp_Moeda_F_RA		FinalMoeda,
	AG.Nome_Raz_Soc			Agente,
	RA.Tx_Fchto_RA			VlTxFrete,
	RA.Vlr_Tot_Fchto_RA		VlTotRemessa,
	HOU.MAWB_HEA			MAWB,
	HOU.HAWB_hea			HAMB,
	isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_proc_Hea,'74'),RI.Intl_Ref_LEA)	Ref_Internacional,
	NBC.Nome_Banco			Banco,
	HOU.Tp_Frete_HEA		TpFrete,
	CA.Cd_Tp_Tx				Cd_Taxa,
	TX.Nome_Tp_Tx			NomeTaxa,
	CA.DC_Hea				DC,
	CA.Vlr_Ref_HEA			VlrTaxa,
	CA.Vlr_Pgto_Rcto_HEA	VlrReal,
	CA.Par_Moeda_hea		Paridade_Remessa,
	Isnull(CXO.Par_Moeda_HEA,CA.Par_Moeda_hea)	Paridade_Recebimento,
	ENDAG.Cd_Tp_End			TipoEndereca,
	ENDAG.Rua				Rua_E,
	ENDAG.Numero			Numero_E,
	ENDAG.Compl_End			Complemento_E,
	ENDAG.CEP				CEP_E,
	ENDAG.Bairro			Bairro_E,
	ENDAG.Cidade			Cidade_E
from
	Remessa_Aer RA with(nolock)
	join Caixa_hou_exp_Aer CA with(nolock)	on CA.num_Rcb_hea = RA.Num_ref_RA
	join house_Exp_Aer HOU	with(nolock) 	on HOU.num_proc_hea = CA.num_proc_hea
	left join Tipo_Taxa TX	 with(nolock)	on TX.cd_tp_Tx = CA.cd_tp_Tx
	left join Pessoa AG	 with(nolock)		on AG.Cd_Pes = RA.cd_pes
	left join Endereco ENDAG with(nolock)	on ENDAG.cd_pes = AG.cd_pes
	left join LLP_Exp_Aer RI with(nolock)	on RI.Num_Proc_Lea = HOU.Num_Proc_HEA
	left Join Cta_Cte BC with(nolock)		on BC.Cd_Banco = RA.Cd_Banco
	left join Agencia AGBC with(nolock)		on AGBC.cd_banco = BC.Cd_Banco and AGBC.Cd_Agencia = RA.Cd_Agencia
	left join Banco NBC	 with(nolock)		on NBC.Cd_Banco = AGBC.cd_banco
	Left Join Caixa_Hou_Exp_Aer  CXO with(nolock) on CA.num_proc_hea=CXO.num_proc_hea and CA.cd_Tp_tx=CXO.cd_tp_tx and CA.dc_hea <> CXO.dc_hea
where
convert(datetime,RA.DT_RA,103) between @DtInicial and @DtFinal and 
RA.num_ref_ra like @Remessa
group by
	RA.num_ref_ra,
	RA.DT_RA,
	RA.Cd_Tp_Moeda_C_RA,
	RA.Cd_Tp_Moeda_F_RA,
	AG.Nome_Raz_Soc,
	RA.Tx_Fchto_RA,
	RA.Vlr_Tot_Fchto_RA,
	HOU.MAWB_HEA,
	HOU.Num_Proc_Hea,
	HOU.HAWB_hea,
	NBC.Nome_Banco,
	RI.Intl_Ref_LEA,
	HOU.Tp_Frete_HEA,
	CA.Cd_Tp_Tx,
	CA.DC_Hea,
	CA.Vlr_Ref_HEA,
	TX.Nome_Tp_Tx,
	CA.Vlr_Pgto_Rcto_HEA,
	CA.Par_Moeda_HEA,
	CXO.Par_Moeda_HEA,
	ENDAG.Cd_Tp_End	,
	ENDAG.Rua,
	ENDAG.Numero,
	ENDAG.Compl_End,
	ENDAG.CEP,
	ENDAG.Bairro,
	ENDAG.Cidade
union
--Import Maritimo
select
	RM.num_ref_rm			Remessa,
	HOU.Num_Proc_Him		Ref_BDP,
	convert(datetime,RM.DT_RM,103)				DtRemessa,
	RM.Cd_Tp_Moeda_C_RM		OrgMoeda,
	RM.Cd_Tp_Moeda_F_RM		FinalMoeda,
	AG.Nome_Raz_Soc			Agente,
	RM.Tx_Fchto_RM			VlTxFrete,
	RM.Vlr_Tot_Fchto_RM		VlTotRemessa,
	HOU.MAWB_HIM			MAWB,
	HOU.HAWB_him			HAMB,
	isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_proc_Him,'74'),RI.Intl_Ref_LIM)	Ref_Internacional,
	NBC.Nome_Banco			Banco,
	HOU.Tp_Frete_HIM		TpFrete,
	CA.Cd_Tp_Tx				Cd_Taxa,
	TX.Nome_Tp_Tx			NomeTaxa,
	CA.DC_Him				DC,
	CA.Vlr_Ref_HIM			VlrTaxa,
	CA.Vlr_Pgto_Rcto_HIM	VlrReal,
	CA.Par_Moeda_him		Paridade_Remessa,
	Isnull(CXO.Par_Moeda_HIM,CA.Par_Moeda_him)	Paridade_Recebimento,
	ENDAG.Cd_Tp_End			TipoEndereca,
	ENDAG.Rua				Rua_E,
	ENDAG.Numero			Numero_E,
	ENDAG.Compl_End			Complemento_E,
	ENDAG.CEP				CEP_E,
	ENDAG.Bairro			Bairro_E,
	ENDAG.Cidade			Cidade_E
from
	Remessa_mar RM with(nolock)
	join Caixa_hou_imp_Mar CA	 with(nolock)on CA.num_Rcb_him = RM.Num_ref_RM
	join house_Imp_Mar HOU with(nolock)		on HOU.num_proc_him = CA.num_proc_him
	left join Tipo_Taxa TX with(nolock)		on TX.cd_tp_Tx = CA.cd_tp_Tx
	left join Pessoa AG	with(nolock)		on AG.Cd_Pes = RM.cd_pes
	left join Endereco ENDAG with(nolock)	on ENDAG.cd_pes = AG.cd_pes
	left join LLP_Imp_Mar RI with(nolock)	on RI.Num_Proc_Lim = HOU.Num_Proc_HIM
	left Join Cta_Cte BC with(nolock)		on BC.Cd_Banco = RM.Cd_Banco
	left join Agencia AGBC	 with(nolock)	on AGBC.cd_banco = BC.Cd_Banco and AGBC.Cd_Agencia = RM.Cd_Agencia
	left join Banco NBC	with(nolock)		on NBC.Cd_Banco = AGBC.cd_banco
	Left Join Caixa_Hou_Imp_Mar CXO with(nolock) on CA.num_proc_him=CXO.num_proc_him and CA.cd_Tp_tx=CXO.cd_tp_tx and CA.dc_him <> CXO.dc_him
where
convert(datetime,RM.DT_RM,103) between @DtInicial and @DtFinal and 
RM.num_ref_rm like @Remessa
group by
	RM.num_ref_RM,
	RM.DT_RM,
	RM.Cd_Tp_Moeda_C_RM,
	RM.Cd_Tp_Moeda_F_RM,
	AG.Nome_Raz_Soc,
	RM.Tx_Fchto_RM,
	RM.Vlr_Tot_Fchto_RM,
	HOU.MAWB_HIM,
	HOU.Num_Proc_Him,
	HOU.HAWB_him,
	NBC.Nome_Banco,
	RI.Intl_Ref_LIM,
	HOU.Tp_Frete_HIM,
	CA.Cd_Tp_Tx,
	CA.DC_Him,
	CA.Vlr_Ref_HIM,
	TX.Nome_Tp_Tx,
	CA.Vlr_Pgto_Rcto_HIM,
	CA.Par_Moeda_HIM,
	CXO.Par_Moeda_HIM,
	ENDAG.Cd_Tp_End	,
	ENDAG.Rua,
	ENDAG.Numero,
	ENDAG.Compl_End,
	ENDAG.CEP,
	ENDAG.Bairro,
	ENDAG.Cidade
Union
--Export Maritomo
select
	RM.num_ref_rm			Remessa,
	HOU.Num_Proc_Hem		Ref_BDP,
	convert(datetime,RM.DT_RM,103)				DtRemessa,
	RM.Cd_Tp_Moeda_C_RM		OrgMoeda,
	RM.Cd_Tp_Moeda_F_RM		FinalMoeda,
	AG.Nome_Raz_Soc			Agente,
	RM.Tx_Fchto_RM			VlTxFrete,
	RM.Vlr_Tot_Fchto_RM		VlTotRemessa,
	HOU.MAWB_HEM			MAWB,
	HOU.HAWB_hem			HAMB,
	isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_proc_Hem,'74'),RI.Intl_Ref_LEM)	Ref_Internacional,
	NBC.Nome_Banco			Banco,
	HOU.Tp_Frete_HEM		TpFrete,
	CA.Cd_Tp_Tx				Cd_Taxa,
	TX.Nome_Tp_Tx			NomeTaxa,
	CA.DC_Hem				DC,
	CA.Vlr_Ref_HEM			VlrTaxa,
	CA.Vlr_Pgto_Rcto_HEM	VlrReal,
	CA.Par_Moeda_hem		Paridade_Remessa,
	Isnull(CXO.Par_Moeda_HEM,CA.Par_Moeda_hem)	Paridade_Recebimento,
	ENDAG.Cd_Tp_End			TipoEndereca,
	ENDAG.Rua				Rua_E,
	ENDAG.Numero			Numero_E,
	ENDAG.Compl_End			Complemento_E,
	ENDAG.CEP				CEP_E,
	ENDAG.Bairro			Bairro_E,
	ENDAG.Cidade			Cidade_E
from
	Remessa_Mar RM with(nolock)
	join Caixa_hou_exp_Mar CA with(nolock)	on CA.num_Rcb_hem = RM.Num_ref_RM
	join house_Exp_Mar HOU with(nolock)		on HOU.num_proc_hem = CA.num_proc_hem
	left join Tipo_Taxa TX	with(nolock) 	on TX.cd_tp_Tx = CA.cd_tp_Tx
	left join Pessoa AG	with(nolock)		on AG.Cd_Pes = RM.cd_pes
	left join Endereco ENDAG with(nolock)	on ENDAG.cd_pes = AG.cd_pes
	left join LLP_Exp_Mar RI with(nolock)	on RI.Num_Proc_Lem = HOU.Num_Proc_HEM
	left Join Cta_Cte BC with(nolock)		on BC.Cd_Banco = RM.Cd_Banco
	left join Agencia AGBC with(nolock)		on AGBC.cd_banco = BC.Cd_Banco and AGBC.Cd_Agencia = RM.Cd_Agencia
	left join Banco NBC	with(nolock)		on NBC.Cd_Banco = AGBC.cd_banco
	Left Join Caixa_Hou_Exp_Mar CXO with(nolock) on CA.num_proc_hem=CXO.num_proc_hem and CA.cd_Tp_tx=CXO.cd_tp_tx and CA.dc_hem <> CXO.dc_hem
where
convert(datetime,RM.DT_RM,103) between @DtInicial and @DtFinal and 
RM.num_ref_rm like @Remessa
group by
	RM.num_ref_rm,
	RM.DT_RM,
	RM.Cd_Tp_Moeda_C_RM,
	RM.Cd_Tp_Moeda_F_RM,
	AG.Nome_Raz_Soc,
	RM.Tx_Fchto_RM,
	RM.Vlr_Tot_Fchto_RM,
	HOU.MAWB_HEM,
	HOU.Num_Proc_Hem,
	HOU.HAWB_hem,
	NBC.Nome_Banco,
	RI.Intl_Ref_LEM,
	HOU.Tp_Frete_HEM,
	CA.Cd_Tp_Tx,
	CA.DC_Hem,
	CA.Vlr_Ref_HEM,
	TX.Nome_Tp_Tx,
	CA.Vlr_Pgto_Rcto_HEM,
	CA.Par_Moeda_HEM,
	CXO.Par_Moeda_HEM,
	ENDAG.Cd_Tp_End	,
	ENDAG.Rua,
	ENDAG.Numero,
	ENDAG.Compl_End,
	ENDAG.CEP,
	ENDAG.Bairro,
	ENDAG.Cidade

order by
	Ref_BDP
option(hash join)
select 

Remessa	[Reference],
DtRemessa	[Remit. Date], 
Banco	Bank, 
OrgMoeda	[Orig. Currency], 
Paridade_Remessa	[Rate],
VlTotRemessa	[Remittance],
FinalMoeda	[Remit.Currency],
Agente	[Agent],
min(Ref_BDP)	[Brazilian Reference],
MAWB	[Master],
Ref_Internacional [International Reference],
HAMB [House],
TpFrete [P/C],


Sum((Case when Cd_Taxa = 'FRT' and DC = 'D' then VlrTaxa else 0 End)) [Freight Value - International Currency],

Sum((Case when Cd_Taxa <> 'FRT' and DC = 'D' then VlrTaxa *-1 else 
 Case when Cd_Taxa <> 'FRT' and DC = 'C' then VlrTaxa else 0 End End)) [Profit BDP SA - International Currency], 

Sum((Case when Cd_Taxa = 'FRT' and DC = 'D' then VlrTaxa else 0 End)) - 
Sum((Case when Cd_Taxa <> 'FRT' and DC = 'D' then VlrTaxa *-1 else 
 Case when Cd_Taxa <> 'FRT' and DC = 'C' then VlrTaxa else 0 End End)) [Remitence - International Currency],

Sum((Case when Cd_Taxa = 'FRT' and DC = 'D' then VlrReal else 0 End)) [Freight Value - Real (R$)],

Sum((Case when Cd_Taxa <> 'FRT' and DC = 'D' then VlrReal *-1 else 
 Case when Cd_Taxa <> 'FRT' and DC = 'C' then VlrReal else 0 End End))  [Profit BDP SA - Real (R$)],

 Sum((Case when Cd_Taxa = 'FRT' and DC = 'D' then VlrReal else 0 End)) -
 Sum((Case when Cd_Taxa <> 'FRT' and DC = 'D' then VlrReal *-1 else 
 Case when Cd_Taxa <> 'FRT' and DC = 'C' then VlrReal else 0 End End))  [Remitence - Real (R$)],
cast((Case when(
Sum((Case when Cd_Taxa = 'FRT' and DC = 'D' then VlrReal else 0 End)) <> 0 )Then sum((Paridade_Remessa - Paridade_Recebimento)*VlrTaxa*-1) else 0 END) as decimal(18,2))[Gain/Loss Currency]

	
 from @Temp
 group by
 
Remessa,
DtRemessa, 
Banco, 
OrgMoeda, 
Paridade_Remessa,
VlTotRemessa,
FinalMoeda,
Agente,
--Ref_BDP,
MAWB,
Ref_Internacional,
HAMB,
TpFrete
GO
