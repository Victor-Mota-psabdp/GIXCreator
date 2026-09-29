SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create Procedure [dbo].[spRemessaData_Sel]-- '2013-01-01','2013-12-31'

@DtInicial	Datetime,
@DtFinal DateTime


As
--Import Aereo
select
	RA.num_ref_ra			Remessa,
	HOU.Num_Proc_Hia		Ref_BDP,
	RA.DT_RA				DtRemessa,
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
	Remessa_Aer RA
	join Caixa_hou_imp_Aer CA	on CA.num_Rcb_hia = RA.Num_ref_RA
	join house_Imp_Aer HOU		on HOU.num_proc_hia = CA.num_proc_hia
	left join Tipo_Taxa TX		on TX.cd_tp_Tx = CA.cd_tp_Tx
	left join Pessoa AG			on AG.Cd_Pes = RA.cd_pes
	left join Endereco ENDAG	on ENDAG.cd_pes = AG.cd_pes
	left join LLP_Imp_Aer RI	on RI.Num_Proc_Lia = HOU.Num_Proc_HIA
	left Join Cta_Cte BC		on BC.Cd_Banco = RA.Cd_Banco
	left join Agencia AGBC		on AGBC.cd_banco = BC.Cd_Banco and AGBC.Cd_Agencia = RA.Cd_Agencia
	left join Banco NBC			on NBC.Cd_Banco = AGBC.cd_banco
	Left Join Caixa_Hou_Imp_Aer  CXO on CA.num_proc_hia=CXO.num_proc_hia and CA.cd_Tp_tx=CXO.cd_tp_tx and CA.dc_hia <> CXO.dc_hia
where
	convert(datetime,RA.DT_RA,103) between @DtInicial and @DtFinal
	--RA.num_ref_ra = @Remessa
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
	RA.DT_RA				DtRemessa,
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
	Remessa_Aer RA
	join Caixa_hou_exp_Aer CA	on CA.num_Rcb_hea = RA.Num_ref_RA
	join house_Exp_Aer HOU		on HOU.num_proc_hea = CA.num_proc_hea
	left join Tipo_Taxa TX		on TX.cd_tp_Tx = CA.cd_tp_Tx
	left join Pessoa AG			on AG.Cd_Pes = RA.cd_pes
	left join Endereco ENDAG	on ENDAG.cd_pes = AG.cd_pes
	left join LLP_Exp_Aer RI	on RI.Num_Proc_Lea = HOU.Num_Proc_HEA
	left Join Cta_Cte BC		on BC.Cd_Banco = RA.Cd_Banco
	left join Agencia AGBC		on AGBC.cd_banco = BC.Cd_Banco and AGBC.Cd_Agencia = RA.Cd_Agencia
	left join Banco NBC			on NBC.Cd_Banco = AGBC.cd_banco
	Left Join Caixa_Hou_Exp_Aer  CXO on CA.num_proc_hea=CXO.num_proc_hea and CA.cd_Tp_tx=CXO.cd_tp_tx and CA.dc_hea <> CXO.dc_hea
where
convert(datetime,RA.DT_RA,103) between @DtInicial and @DtFinal
	--RA.num_ref_ra = @Remessa
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
	RM.DT_RM				DtRemessa,
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
	Remessa_mar RM
	join Caixa_hou_imp_Mar CA	on CA.num_Rcb_him = RM.Num_ref_RM
	join house_Imp_Mar HOU		on HOU.num_proc_him = CA.num_proc_him
	left join Tipo_Taxa TX		on TX.cd_tp_Tx = CA.cd_tp_Tx
	left join Pessoa AG			on AG.Cd_Pes = RM.cd_pes
	left join Endereco ENDAG	on ENDAG.cd_pes = AG.cd_pes
	left join LLP_Imp_Mar RI	on RI.Num_Proc_Lim = HOU.Num_Proc_HIM
	left Join Cta_Cte BC		on BC.Cd_Banco = RM.Cd_Banco
	left join Agencia AGBC		on AGBC.cd_banco = BC.Cd_Banco and AGBC.Cd_Agencia = RM.Cd_Agencia
	left join Banco NBC			on NBC.Cd_Banco = AGBC.cd_banco
	Left Join Caixa_Hou_Imp_Mar CXO on CA.num_proc_him=CXO.num_proc_him and CA.cd_Tp_tx=CXO.cd_tp_tx and CA.dc_him <> CXO.dc_him
where
convert(datetime,RM.DT_RM,103) between @DtInicial and @DtFinal
	--RM.num_ref_rm = @Remessa
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
	RM.DT_RM				DtRemessa,
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
	Remessa_Mar RM
	join Caixa_hou_exp_Mar CA	on CA.num_Rcb_hem = RM.Num_ref_RM
	join house_Exp_Mar HOU		on HOU.num_proc_hem = CA.num_proc_hem
	left join Tipo_Taxa TX		on TX.cd_tp_Tx = CA.cd_tp_Tx
	left join Pessoa AG			on AG.Cd_Pes = RM.cd_pes
	left join Endereco ENDAG	on ENDAG.cd_pes = AG.cd_pes
	left join LLP_Exp_Mar RI	on RI.Num_Proc_Lem = HOU.Num_Proc_HEM
	left Join Cta_Cte BC		on BC.Cd_Banco = RM.Cd_Banco
	left join Agencia AGBC		on AGBC.cd_banco = BC.Cd_Banco and AGBC.Cd_Agencia = RM.Cd_Agencia
	left join Banco NBC			on NBC.Cd_Banco = AGBC.cd_banco
	Left Join Caixa_Hou_Exp_Mar CXO on CA.num_proc_hem=CXO.num_proc_hem and CA.cd_Tp_tx=CXO.cd_tp_tx and CA.dc_hem <> CXO.dc_hem
where
convert(datetime,RM.DT_RM,103) between @DtInicial and @DtFinal
	--RM.num_ref_rm = @Remessa
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

GO
