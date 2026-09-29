SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spReconciliacao2012_Rel] --'2007-01-01','2012-12-31'
	@DataInicial as datetime,
	@DataFinal as datetime
as
select 
	convert(varchar(10),CONVERT(datetime,CX.dt_pgto_rcto_hia,103),103) [Data da Transação],
	CX.Num_Proc_HiA [Numero do Job],
	convert(decimal(18,2), CX.Vlr_Ref_Hia) [Valores na Moeda],
	convert(decimal(18,2), CX.Vlr_Pgto_Rcto_Hia) [Valores em BRL],
	(Case CX.DC_HIA
		When 'C' then 'Pagamento da Taxa: ' + TT.Nome_Tp_Tx
		else 'Recebimento da Taxa: ' + TT.Nome_Tp_Tx End) [Histórico],
	'X'[Balanço],
	NULL[Resultado],
	AJ.HAWB [Numero House],
	AJ.MAWB [Numero Master],
	PCL.Apelido [Nome Cliente],
	PFO.Apelido [Nome Fornecedor],
	CX.Num_Lcto [LA Number],
	(Case CC.Cd_Tp_Moeda
			When 'REL' then 'BRL'
			else CC.Cd_Tp_Moeda End ) [Moeda]
from 
	vwcta_Cte CC 
Join vwcxas CX on CC.Num_Proc_HIA = CX.Num_Proc_HIA and CC.Cd_Tp_Tx = CX.Cd_Tp_Tx and CC.DC_HIA = CX.DC_HIA
Join vwcliente CL on CX.Num_Proc_HIA=CL.num_proc
Join Tipo_Taxa TT on TT.Cd_Tp_Tx = CX.Cd_TP_Tx
Join Pessoa	PCL on PCL.Cd_Pes = CL.cd_cliente
Join Pessoa	PFO on PFO.Cd_Pes = CC.Cd_Cred_Dev_HIA
Join vwALL_JOBs AJ on AJ.Num_Proc = CX.Num_Proc_HIA 
where CONVERT(datetime,CX.dt_pgto_rcto_hia,103) between @DataInicial and @DataFinal


UNION ALL

select 
	convert(varchar(10),NF.Emissao,103) [Data da Transação],
	CC.Num_Proc_HiA [Numero do Job],
	convert(decimal(18,2), CC.Vlr_Org_Hia) [Valores na Moeda],
	convert(decimal(18,2), CC.Vlr_Pgto_NF_HIA) [Valores em BRL],
	'Taxa: ' + TT.Nome_Tp_Tx + ' - ' + 'NF: ' + cast(CC.Num_NF_HIA as varchar(30)) [Histórico],
	NULL[Balanço],
	'X'[Resultado],
	AJ.HAWB [Numero House],
	AJ.MAWB [Numero Master],
	PCL.Apelido [Nome Cliente],
	PFO.Apelido [Nome Fornecedor],
	NULL [LA Number],
	(Case CC.Cd_Tp_Moeda
			When 'REL' then 'BRL'
			else CC.Cd_Tp_Moeda end) [Moeda]
	
from 
	VWCta_Cte CC
Join BAse_Nota_Fiscal NF on NF.Nota_Fiscal=CC.Num_NF_Hia and NF.Ref_Acesso=CC.Ref_Acesso_NF_Hia
Join vwcliente CL on CC.Num_Proc_HIA=CL.num_proc
Join Tipo_Taxa TT on TT.Cd_Tp_Tx = CC.Cd_TP_Tx
Join Pessoa	PCL on PCL.Cd_Pes = CL.cd_cliente
Join Pessoa	PFO on PFO.Cd_Pes = CC.Cd_Cred_Dev_HIA
Join vwALL_JOBs AJ on AJ.Num_Proc = CC.Num_Proc_HIA 
where CONVERT(datetime,NF.Emissao,103) between @DataInicial and @DataFinal

Union ALL

select 
convert(varchar(10),RF.Dt_Ins,103) [Data da Transação],
RFI.Num_Proc[Numero do Job],
convert(decimal(18,2), RFI.Valor_Total) [Valores na Moeda],
convert(decimal(18,2), ISNULL(RFI.Valor_Total_Moeda_Local,RFI.Valor_Total)) [Valores em BRL],
'Taxa: ' + TT.Nome_Tp_Tx + ' - ' + 'Doc Register: ' + cast(RF.Num_Registro as varchar(30)) [Histórico],
NULL[Balanço],
'X'[Resultado],
AJ.HAWB [Numero House],
AJ.MAWB [Numero Master],
PCL.Apelido [Nome Cliente],
PFO.Apelido [Nome Fornecedor],
NULL [LA Number],
	(Case RF.Cd_Tp_Moeda
			When 'REL' then 'BRL'
			else RF.Cd_Tp_Moeda end) [Moeda]
from 
	registro_financeiro RF
join registro_financeiro_item RFI on RF.ano=rfi.ano and rfi.mes=rf.mes and rf.num_registro=rfi.num_registro
Join vwcliente CL on RFI.Num_Proc=CL.num_proc
Join Tipo_Taxa TT on TT.Cd_Tp_Tx = RFI.Cd_TP_Tx
Join Pessoa	PCL on PCL.Cd_Pes = CL.cd_cliente
Join Pessoa	PFO on PFO.Cd_Pes = RF.Cd_Pes
Join vwALL_JOBs AJ on AJ.Num_Proc = RFI.Num_Proc
where CONVERT(datetime,RF.Dt_Ins,103) between @DataInicial and @DataFinal



GO
