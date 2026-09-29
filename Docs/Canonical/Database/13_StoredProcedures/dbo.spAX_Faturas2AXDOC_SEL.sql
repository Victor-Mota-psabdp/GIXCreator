SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spAX_Faturas2AXDOC_SEL]
as

Select 
	distinct 
	'10001' Dimensao_1,
	 AX_GRUPO Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(fatcod,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	Null Dimensao_7,
	1 Tipo,
	Null NumeroInternoAX,
	Isnull(cd_ax,1077) Cd_PessoA_AX,
	

	'Cust' AccountType,
	1 Aprovado,
	Null Aprovado_Por,
	getdate() Dt_Aprovacao,
	'BR1' Company,
	FatDtEmissao Dt_Documento,
	Null Numero_Documento,
	FatDtVenc Dt_Vencimento,
		FatCod Invoice_Number,
	Sales_Tax_Group TaxGroup,

	null TaxItemGroup,
	FatDtEmissao Dt_Ins,
	Null Dt_Envio_AX,
	Null Obs_AX,
	1 Ativo,
	Getdate() Data_Aprovacao,
	PP.cd_pes
	
	
	

  From Fatura  FAT
  Join Pessoa PP on PP.Cd_Pes=FAT.cd_pes
  left Join Pessoa_LLP P on P.Cd_Pes=PP.Cd_Pes
  Left Join Grupo GRP on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
  Left Join Pessoa_ATL_AX AX on (AX.Cd_Pes = PP.Cd_Pes and cd_Tp_ativ<>'AGT' or cd_Tp_ativ='AGT' and left(Ax.cd_pes,len(Ax.cd_pes)-1)=PP.cd_pes ) and Tipo='C'
  Where 
		FatStatus <> 0
	--	and (P.cd_pes is  null or GRP.cd_pes_grupo is null)
		and convert(datetime,convert(varchar(10),fatdtemissao,105),105) between '05-01-2013' and '05-31-2013'
	--and fatcod in ('IMATL201304147BRA')
		and cd_ax  is not null
GO
