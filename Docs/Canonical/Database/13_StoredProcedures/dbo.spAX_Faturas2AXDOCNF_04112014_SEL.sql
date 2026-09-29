SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spAX_Faturas2AXDOCNF_04112014_SEL 'EMMTE201310009BRA'
--esta alterado as datas pra ser enviada como getdate nos casos EM
CREATE  Procedure [dbo].[spAX_Faturas2AXDOCNF_04112014_SEL]--'EMMTE201310012BRA'
	@Fatura	Varchar(17)
as
--1948
Select 
	distinct 
	'10001' Dimensao_1,
	 C.Dimensao3 Dimensao_3,
		'BRSAO' Dimensao_4,
	(
	Case LEFT(fat.fatcod,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
		
	
	End
	) Dimensao_2,
	'' Dimensao_5,
	
	'BR1' Dimensao_6,
	Null Dimensao_7,
	1 Tipo,
	Null NumeroInternoAX,
	cd_ax Cd_PessoA_AX,
	

	'Cust' AccountType,
	1 Aprovado,
	Null Aprovado_Por,
	getdate() Dt_Aprovacao,
	'BR1' Company,
	FatDtEmissao Dt_Documento,
	--getdate() Dt_Documento,
	Null Numero_Documento,
	FatDtVenc Dt_Vencimento,
	--getdate() Dt_Vencimento,
		fat.FatCod Invoice_Number,
	C.TaxGroup TaxGroup,

	null TaxItemGroup,
	FatDtEmissao Dt_Ins,
	--getdate()  Dt_Ins,
	Null Dt_Envio_AX,
	Null Obs_AX,
	1 Ativo,
	Getdate() Data_Aprovacao,PP.CD_PES,
	fat.dt_canc
	--RPS.Num_Proc

  From Fatura  FAT
  Join Pessoa PP on PP.Cd_Pes=FAT.cd_pes
  left Join Pessoa_LLP P on P.Cd_Pes=PP.Cd_Pes
  Left Join Grupo GRP on GRP.Cd_Pes_Grupo = P.Cd_Pes_Grupo 
 -- Left Join Pessoa_ATL_AX AX on (cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes  or cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and Tipo='C'
	Left Join Pessoa_ATL_AX AX on AX.Cd_Pes = PP.Cd_Pes  and Tipo='C'
	Left Join dbo.AX_XML_Customer_Recebido C on C.accountnum =AX.cd_ax
  Join Item_Fat I on I.fatcod=fat.fatcod
  ---Join vwcta_Cte cta on cta.num_proc_hia=i.num_proc and i.cd_tp_tx=cta.cd_tp_tx and i.dc=cta.dc_hia
  ---Join base_nota_fiscal NF on notA_fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
  left join ax_doc AXD on AXD.invoice_number=fat.fatcod
  Left Join  vwRPS_Pendente on  FAT.Fatcod=FatcodRPS
  Where 
	Fat.fatcod = @Fatura
	--and
	--	(
	--		(month(fatdtemissao)>=month(getdate()-1) and year(fatdtemissao)=year(getdate()-1))
	--	or (FAT.dt_canc >='12-01-2013' and fatdtemissao <'12-01-2013') or convert(Datetime,fatdtemissao,105) >= getdate()-20 
	--	)

	--AND 	( len(fat.fatcod)=17 or len(fat.fatcod)=15)
	--and axd.invoice_number is null
	--and AX.Cd_Pes  is not null  and FatcodRPS is null

GO
