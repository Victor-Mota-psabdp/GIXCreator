SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE  [dbo].[SP_SEL_CTA_CTES_JOBS]-- '01/09/2011','15/09/2011','%','%'
				@datainicial	varchar(10),
				@datafinal	varchar(10),
				@pessoa 	varchar(25),
				@taxa		varchar(30)
AS
Select 
	dbo.fBusca_TipoDocCliente('N',cxa.num_proc_hia,19) Job_ATL,
	Apelido Processo, Nome_tp_tx  Taxa, CTA.dc_hia DebitoCredito,
	Convert(DateTime,dt_ins_hia,105)  Data, Cd_tp_moeda Moeda,cast(Vlr_org_hia as Money) as ValorOriginal,
	CTA.num_proc_hia Apelido,0 ValorPago, CTA.Dt_Prev_Pgto_HIA	Dt_PRev
From
	vwCta_Cte CTA
	Left Join vwcxas CXA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and upper(num_lcto) <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hia,105)<=convert(datetime,@datafinal,105)
	Join Pessoa PP on PP.cd_pes=cd_cred_Dev_hia
	Join Tipo_Taxa TT on TT.cd_tp_Tx=cta.cd_Tp_tx
Where
	num_lcto is null and
	apelido like @pessoa 
	and Nome_Tp_tx like @Taxa
	and convert(datetime,dt_ins_hia,105) between convert(Datetime,@datainicial,105) and convert(Datetime,@DataFinal,105)
order by 
	 convert(datetime,CTA.Dt_Prev_Pgto_HIA,103) 

GO
