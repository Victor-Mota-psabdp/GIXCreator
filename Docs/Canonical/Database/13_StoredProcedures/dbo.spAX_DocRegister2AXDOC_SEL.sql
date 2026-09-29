SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAX_DocRegister2AXDOC_SEL]
as

Select 
	Distinct 
	'10001' Dimensao_1,
	 '' Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(num_registro,2) 
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		else 999
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	Isnull(Dimensao7,'OTH-None') Dimensao_7,
	4 Tipo,
	Null NumeroInternoAX,
	cd_ax Cd_PessoA_AX,
	

	'Vend' AccountType,
	1 Aprovado,
	Null Aprovado_Por,
	getdate() Dt_Aprovacao,
	'BR1' Company,
	Dt_Ins Dt_Documento,
	Null Numero_Documento,
	Dt_Venc Dt_Vencimento,
	Doc_Number Invoice_Number,
	--'VEN SER 01' TaxGroup,
	Sales_Tax_Group TaxGroup,
	null TaxItemGroup,
	Dt_Ins Dt_Ins,
	Null Dt_Envio_AX,
	Null Obs_AX,
	1 Ativo,
	Getdate() Data_Aprovacao,
	'',
	PP.Cd_PEs,
	Ano,
	Mes,
	Num_Registro
	
	

  From registro_financeiro R
  Join Pessoa PP on PP.Cd_Pes=R.cd_pes
  Left Join Pessoa_LLP P on P.Cd_Pes=PP.Cd_Pes
  Left Join Grupo GRP on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
  Left Join Pessoa_ATL_AX AX on AX.Cd_Pes = PP.Cd_Pes and Tipo='F'
  Left Join dbo.AX_XML_Vendor_Recebido AXV on AXV.accountNum=cd_ax
  Where 
		---cta.dc_hia='D' and left(cd_Tp_Tx,1) <> 'X'
		--and AX_GRUPO is not null
		mes=7 and ano=2013 -- and num_registro='000710'
		
and cd_Ax is not null
GO
