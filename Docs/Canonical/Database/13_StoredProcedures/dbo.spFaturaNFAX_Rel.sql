SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spFaturaNFAX_Rel '%','2013-08-01','2013-08-19'
CREATE procedure spFaturaNFAX_Rel 
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
	
as

	If @Grupo = 'GRUPO ALL'
		set @Grupo = '%'	
		
select  
 IFAT.FatCod [Fatura],
FAT.FatDtEmissao [Data Fatura],
FARG.Numero [Nota Fiscal],
FARG.Codigo [Site],
FARG.Dt_Fatura [Data NF],
IFAT.Num_Proc [JOB],
PAX.CD_AX [Codigo AX],
FAT.FatDtVenc[Vencimento],
TT.Nome_Tp_Tx [Descrição da Taxa],
TT.CD_AX [Codigo da Taxa - AX],
IFAT.DC [D/C],
(case when IFAT.Cd_Tp_Moeda = 'REL' then 'BRL' else IFAT.Cd_Tp_Moeda END) [Moeda],
abs(IFAT.Vlr_Org) [Valor],
IFAT.Paridade [Paridade],
abs(IFAT.Vlr_RS) [Valor Em Reais],
abs(vCC.Valor_Org) * vCC.Paridade [Valor Em Reais (NF)]
from Fatura FAT with(nolock) 
join item_fat IFAT with(nolock) on FAT.FatCod = IFAT.FatCod 
left join Fatura_Arg_Det vCC with(nolock) on IFAT.Num_proc = vCC.Num_proc and IFAT.cd_tp_tx = vCC.cd_tp_tx and IFAT.DC = vCC.DC 
left join Fatura_ARG FARG with(nolock) on vCC.ID_Fat = FARG.ID_Fat and [Status] <> 2
join Pessoa_ATL_AX PAX with(nolock) on FAT.Cd_Pes = PAX.CD_Pes and Tipo = 'C'
join Tipo_Taxa TT with(nolock) on IFAT.Cd_Tp_tx = TT.CD_Tp_tx
Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=FAT.Cd_Pes
join Grupo G with(nolock) on G.cd_pes_grupo= PLL.cd_pes_grupo
join pessoa	PG  with(nolock) on PG.cd_pes=G.Cd_Pes_Grupo
--join vwCta_Cte vCC with(nolock) on IFAT.Num_proc = vCC.Num_proc_hia and IFAT.cd_tp_tx = vCC.cd_tp_tx and IFAT.DC = vCC.DC_HIA and FAT.Cd_Pes = vCC.Cd_Cred_Dev_Hia
--left join Base_nota_fiscal BNF with(nolock) on vCC.Num_NF_HIA = BNF.Nota_Fiscal and vCC.Ref_Acesso_NF_HIA = BNF.Ref_Acesso
where FatStatus = '1'  and FAT.FatDtEmissao between @DtInicial and @DtFinal and PG.Apelido like @Grupo
--order by FAT.FatDtEmissao desc

GO
