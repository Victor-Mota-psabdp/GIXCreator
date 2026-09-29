SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      Procedure [dbo].[spReportInvoiceAgente_Rel]
	@DataInicial	Datetime,
	@DataFinal		Datetime
as

 Select 
	vwF.Num_Proc  [JOB],	 
    pp.apelido    [Credor/Devedor],	
    dbo.fBusca_TipoDocCliente ('N',vwf.Num_Proc,180) [180 - Credit Note],
    dbo.fBusca_TipoDocCliente ('N',vwf.Num_Proc,181) [181 - Debit Note],
    vwh.MAWB  [Master],
	vwh.HAWB  [House],
	vwF.Vlr_Org [Valor U$],	
	vwF.FatCod [BDP Invoice]
from  
	vwFaturasValidas vwF
	left Join vwcta_cte cta with(nolock) on cta.num_proc_hia=vwf.num_proc 
	     and vwf.cd_tp_tx=cta.cd_Tp_tx and vwf.DC=cta.dc_hia
	join vwCliente_Alerta vwh with(nolock) on vwh.num_proc = vwf.num_proc   
	join Pessoa            pp with(nolock) on pp.cd_pes = vwf.cd_pes_fat
	     and pp.Cd_Tp_Ativ = 'AGT' 
         and LEN(pp.Num_CPF_CNPJ) = 0  
where convert(date,vwF.FatDtEmissao) between @DataInicial and @DataFinal
--and   vwf.Num_Proc = 'IAEVO202207001BR'
union all 
Select 
	cta.Num_Proc_HIA   [JOB],	 
    pp.apelido    [Credor/Devedor],	
    dbo.fBusca_TipoDocCliente ('N',cta.Num_Proc_HIA ,180) [180 - Credit Note],
    dbo.fBusca_TipoDocCliente ('N',cta.Num_Proc_HIA ,181) [181 - Debit Note],
    vwh.MAWB  [Master],
	vwh.HAWB  [House],
	dbo.valor(cta.Vlr_Org_HIA,cta.dc_hia) [Valor U$],	
	''  [BDP Invoice]
from  
	vwcta_cte cta
	left join vwFaturasValidas vwF with(nolock) on vwf.num_proc = cta.Num_Proc_HIA 
         and vwf.DC = cta.DC_HIA
		 and vwf.Cd_Tp_Tx = cta.Cd_Tp_Tx
	join vwCliente_Alerta vwh with(nolock) on vwh.num_proc = cta.Num_Proc_HIA   
	join Pessoa            pp with(nolock) on pp.cd_pes = cta.Cd_Cred_Dev_HIA
	     and pp.Cd_Tp_Ativ = 'AGT' 
         and LEN(pp.Num_CPF_CNPJ) = 0  
where convert(datetime,cta.Dt_Ins_HIA,103) between @DataInicial and @DataFinal
and   vwf.FatCod is null
--and   cta.Num_Proc_HIA = 'IAEVO202207001BR'



GO
