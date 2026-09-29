SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spAXReportExcecoesCustomer_Sel ''
CREATE  Procedure [dbo].[spAXReportExcecoesCustomer_Sel]
	@grupo Varchar(40)
AS

Declare @temp table
(
	Dt_Documento datetime,
	Invoice_Number varchar(17),
	Cadastro varchar(50),
	Codigo_ATL varchar(50),
	Num_CPF_CNPJ varchar(50)
)

insert @temp
Select 

	FatDtEmissao Dt_Documento,
	fat.FatCod Invoice_Number,
	Apelido [Cadastro],
	PP.CD_PES [Codigo ATL],
	Num_CPF_CNPJ [CNPJ]	
	
  From Fatura  FAT with(nolock)
  Join Pessoa PP with(nolock) on PP.Cd_Pes=FAT.cd_pes
  left Join Pessoa_LLP P with(nolock) on P.Cd_Pes=PP.Cd_Pes
  Left Join Grupo GRP with(nolock) on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
 -- Left Join Pessoa_ATL_AX AX on (cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and Tipo='C'
	Left Join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes  and Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C with(nolock) on C.accountnum =AX.cd_ax
  Join Item_Fat I with(nolock) on I.fatcod=fat.fatcod
  ---Join vwcta_Cte cta on cta.num_proc_hia=i.num_proc and i.cd_tp_tx=cta.cd_tp_tx and i.dc=cta.dc_hia
  ---Join base_nota_fiscal NF on notA_fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
  left join ax_doc AXD with(nolock) on AXD.invoice_number=fat.fatcod
 
  Where 

		--FatStatus <> 0
	--	and (P.cd_pes is  null or GRP.cd_pes_grupo is null)
		month(fatdtemissao)=month(getdate()-1) 
		 and year(fatdtemissao)=year(getdate()-1)
		--and fatcod in('IMATL201305141BRB','IMATL201305141BRD')
	--and fat.fatcod in ('IAATL201308007BRA')	--	and emissao between '05-01-2013' and '05-31-2013'
---	and i.cd_tp_Tx in ('DSC','MH1')
	--and left(fat.fatcod,2)='IM'
--	and fat.fatcod in ('IMATL201309027BRD','EAROB201309001BRA') 
	AND 	( len(fat.fatcod)=17 or len(fat.fatcod)=15) and
	axd.invoice_number is null
	and AX.Cd_Pes is null
		order by Apelido

	
select distinct  Dt_Documento,Invoice_Number,Cadastro,Codigo_ATL,Num_CPF_CNPJ,H.HSDDescricao from @temp T 
left join Hist_Geral H with(nolock) on T.Invoice_Number = substring(H.HSDDescricao,8,17)
where  substring(H.HSDDescricao,1,6) = 'Fatura'

GO
