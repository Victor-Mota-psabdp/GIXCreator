SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spAXReportExecoesVendor_Sel] ''
CREATE  Procedure [dbo].[spAXReportExecoesVendor_Sel]
	@grupo Varchar(40)
AS

/*
	Anderson Oliveira 13/12/2013 - Report de exceção para demonstrar quais casos não foram enviados para o AX devido a erro no Vendor

*/

Select distinct
	Apelido [Cadastro],
	PP.CD_PES [Codigo ATL],
	Num_CPF_CNPJ [CNPJ],
	Num_Proc_HIA [Job],
	Nome_Tp_Tx [Descrição da Taxa],
	DC_HIA	[DC],
	Vlr_Org_HIA [Valor],
	US.Nome_Usuario,
	LG.Dt_Ins

From vwcta_Cte cta with(nolock)
		Join Pessoa PP with(nolock) on PP.Cd_Pes=cd_Cred_dev_hia
		Left Join Pessoa_LLP P with(nolock) on P.Cd_Pes=PP.Cd_Pes
		Left Join Grupo GRP with(nolock) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
		Left Join Pessoa_ATL_AX AX with(nolock) on (AX.Cd_Pes = PP.Cd_Pes) and Tipo='F'
		Left Join vwcliente C with(nolock) on C.num_proc=cta.num_proc_hia
		Left Join Item_Fat I with(nolock) on cta.num_proc_hia=I.num_proc and cta.cd_tp_tx=I.cd_tp_tx and Cta.dc_hia=I.dc
		left  Join dbo.AX_XML_Vendor_Recebido AV with(nolock) on accountnum=cd_ax
		Left Join vwAXDocs IC with(nolock) on (IC.num_proc=cta.num_proc_hia and len(numerointernoax)=16 or cta.num_proc_hia=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=cta.cd_Tp_Tx and IC.Dc=cta.dc_hia
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_TX=Cta.cD_tp_Tx
		left join Log_Cta_Cte LG with(nolock) on cta.num_proc_hia=LG.Num_Proc_CC and cta.cd_tp_tx=LG.cd_tp_tx and Cta.dc_hia=LG.DC_CC and Tp_Oper_CC = 'I'
		left join Usuario US with(nolock) on LG.Cd_Usuario = US.Cd_Usuario
 Where 
		(cta.dc_hia='D' or cta.DC_HIA='C' and CTA.Cd_Tp_Tx in ('XY0','XY1'))
		and month(convert(Datetime,dt_ins_hia,105))=month(getdate()-1)
		and year(convert(Datetime,dt_ins_hia,105))=year(getdate()-1)
		and desp_org_hia='N' 		
		and i.num_proc is null and  (cd_cliente <> Cd_cred_dev_hia or cd_cliente is null)
		and AV.AccountNum is  null
		and IC.num_proc is null
		and substring(CTA.num_proc_hia,3,3) <> 'REM'
		and p.cd_pes_grupo is null
		
Order by 1



GO
