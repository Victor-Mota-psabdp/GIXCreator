SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spAX_NF2AXDOC_SEL]
as

Select 
	distinct 
	'10001' Dimensao_1,
	 AX_GRUPO Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(Nota_FIscal,2) 
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
	3 Tipo,
	Null NumeroInternoAX,
	Isnull(cd_ax,1077) Cd_PessoA_AX,
	

	'Cust' AccountType,
	1 Aprovado,
	Null Aprovado_Por,
	getdate() Dt_Aprovacao,
	'BR1' Company,
	Emissao Dt_Documento,
	Null Numero_Documento,
	Prazo Dt_Vencimento,
	Nota_Fiscal+'.'+Ref_Acesso Invoice_Number,
	Sales_Tax_Group TaxGroup,

	null TaxItemGroup,
	Emissao Dt_Ins,
	Null Dt_Envio_AX,
	Null Obs_AX,
	1 Ativo,
	Getdate() Data_Aprovacao
	
	
	

  From Base_Nota_Fiscal FAT
  Join Pessoa PP on PP.Cd_Pes=FAT.cd_pes
  Join Pessoa_LLP P on P.Cd_Pes=PP.Cd_Pes
  Join Grupo GRP on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
  Left Join Pessoa_ATL_AX AX on (AX.Cd_Pes = PP.Cd_Pes and cd_tp_ativ<>'AGT' or left(AX.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes and cd_tp_ativ='AGT') and Tipo='C'
  Where 
		Cd_Status <> 2
	--	and AX_GRUPO is null
		and emissao between '05-01-2013' and '05-31-2013'
		
		
GO
