SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_TransfPriceTXT_EXP_SelIns 'EOCSR201403047BR','86667'

CREATE procedure [dbo].[spATL_TransfPriceTXT_EXP_SelIns]
(
@Num_Proc varchar(16),
@NF varchar(50)
)
as

Declare @Temp Table(
	ID	bigint,
	Num_Proc	varchar(16),
	Codigo_Empresa	varchar(9),
	Codigo_Filial	varchar(9),
	Serie_Nota_Fiscal	varchar(5),
	Numero_Nota_Fiscal	varchar(15),
	Data_Emissao	varchar(8),
	Numero_RE	varchar(15),
	Codigo_Produto	varchar(18),
	Tipo_Conhecimento_Transporte	varchar(2),
	Relacionamento	varchar(2),
	Data_RE	varchar(8),
	Declaracao_Exportacao	varchar(15),
	Data_Declaracao_Exportacao	varchar(8),
	Status_Averbacao	varchar(1),
	Conhecimento_Embarque	varchar(18),
	Data_Conhecimento_Embarque	varchar(8),
	Codigo_Pais	varchar(4),
	Comprovante_Exportacao	varchar(8),
	Data_Comprovante_Exportacao	varchar(8),
	Modelo_documento	varchar(3),
	Natureza_Exportacao	varchar(1),
	Data_Averbacao_DE	varchar(8),
	Tipo_Declaracao	varchar(1),
	Chave_NFe	varchar(44),
	Moeda	varchar(10),
	OpenFlex_01	varchar(150),
	OpenFlex_02	varchar(150),
	OpenFlex_03	varchar(150),
	OpenFlex_04	varchar(150),
	OpenFlex_05	varchar(150),
	OpenFlex_06	varchar(17),
	OpenFlex_07	varchar(17),
	OpenFlex_08	varchar(17)
)

Declare @ID bigint
set @ID = (Select ISNULL(max(ID),0)+1  from Transf_Price_TXT_EXP)
insert into @Temp
select 
distinct
	@ID  ID,
	T10.Num_Proc_HEM  Num_Proc,
	PD.Co_Code  Codigo_Empresa,
	PD.Business_Place  Codigo_Filial,
	TP.SERIE_SUBSERIE   Serie_Nota_Fiscal,
	TP.NUMERO_NOTA_FISCAL  Numero_Nota_Fiscal,
	replace(convert(varchar(10),T10.Data_PO_HEM,103),'/','')   Data_Emissao,
	left(T04.Numero_PO_HEM,15)  Numero_RE,
	TP.MERCADORIA_CODIGO  Codigo_Produto,
	NULL Tipo_Conhecimento_Transporte,
	NULL  Relacionamento,
	NULL  Data_RE,
	NULL  Declaracao_Exportacao,
	NULL  Data_Declaracao_Exportacao,
	NULL  Status_Averbacao,
	NULL  Conhecimento_Embarque,
	replace(convert(varchar(10),LLP.ATD_Lem,103),'/','')  Data_Conhecimento_Embarque,
	DST.Cd_Pais  Codigo_Pais,
	NULL  Comprovante_Exportacao,
	NULL  Data_Comprovante_Exportacao,
	NULL  Modelo_documento,
	NULL  Natureza_Exportacao,
	NULL  Data_Averbacao_DE,
	NULL  Tipo_Declaracao,
	NULL  Chave_NFe,
	LLP.Cd_Moeda_Invoice  Moeda,
	'BDP/'+replace(convert(varchar(10),getdate(),103),'/','')  OpenFlex_01,
	NULL  OpenFlex_02,
	NULL  OpenFlex_03,
	NULL  OpenFlex_04,
	NULL  OpenFlex_05,
	NULL  OpenFlex_06,
	NULL  OpenFlex_07,
	NULL  OpenFlex_08
	--,Replace(dbo.FRemoveCaracteresEspeciais(TP.Informante_CNPJ_CPF),'.','')
from Transf_Price_DOW_EXP_2015 TP
join PO_HEM T10 on right('0000000000' +TP.NUMERO_NOTA_FISCAL,10) = right('0000000000' +T10.Numero_PO_HEM,10) and ID_DC = '10'
join Plantas_Dow PD with(nolock) on Replace(dbo.FRemoveCaracteresEspeciais(TP.REMETENTE_CNPJ_CPF),'.','') = PD.Tax_Number_1
join PO_HEM T04 on T10.Num_Proc_HEM = T04.Num_Proc_HEM and T04.ID_DC = '4'
join LLP_exp_Mar LLP with(nolock) on T10.Num_Proc_HEm = LLP.num_proc_lem 
join Localidade DST with(nolock)  on LLP.Cd_DstFinal_Lem = DST.Cd_Local
--join Tipo_Moeda TM with(nolock)  on LLP.Cd_Moeda_Invoice = TM.Cd_Tp_Moeda
where  T10.Num_Proc_HEM = @Num_Proc and right('0000000000' +T10.Numero_PO_HEM,10) =right('0000000000' +@NF,10) and TP.MERCADORIA_CODIGO <> '' --and SUBSTRING(T10.Num_Proc_HEM,3,3) in ('CSR')
union all

select 
distinct
	@ID  ID,
	T10.Num_Proc_HEA  Num_Proc,
	PD.Co_Code  Codigo_Empresa,
	PD.Business_Place  Codigo_Filial,
	TP.SERIE_SUBSERIE   Serie_Nota_Fiscal,
	TP.NUMERO_NOTA_FISCAL  Numero_Nota_Fiscal,
	replace(convert(varchar(10),T10.Data_PO_HEA,103),'/','')  Data_Emissao,
	left(T04.Numero_PO_HEA,15)  Numero_RE,
	TP.MERCADORIA_CODIGO  Codigo_Produto,
	NULL  Tipo_Conhecimento_Transporte,
	NULL  Relacionamento,
	NULL  Data_RE,
	NULL  Declaracao_Exportacao,
	NULL  Data_Declaracao_Exportacao,
	NULL  Status_Averbacao,
	NULL  Conhecimento_Embarque,
	replace(convert(varchar(10),LLP.ATD_Lea,103),'/','')  Data_Conhecimento_Embarque,
	DST.Cd_Pais  Codigo_Pais,
	NULL  Comprovante_Exportacao,
	NULL  Data_Comprovante_Exportacao,
	NULL  Modelo_documento,
	NULL  Natureza_Exportacao,
	NULL  Data_Averbacao_DE,
	NULL  Tipo_Declaracao,
	NULL  Chave_NFe,
	LLP.Cd_Moeda_Invoice   Moeda,
	'BDP/'+replace(convert(varchar(10),getdate(),103),'/','')  OpenFlex_01,
	NULL  OpenFlex_02,
	NULL  OpenFlex_03,
	NULL  OpenFlex_04,
	NULL  OpenFlex_05,
	NULL  OpenFlex_06,
	NULL  OpenFlex_07,
	NULL  OpenFlex_08
	--,Replace(dbo.FRemoveCaracteresEspeciais(TP.Informante_CNPJ_CPF),'.','')
from Transf_Price_DOW_EXP_2015 TP
join PO_HEA T10 on right('0000000000' +TP.NUMERO_NOTA_FISCAL,10) = right('0000000000' +T10.Numero_PO_HEA,10) and ID_DC = '10'
join Plantas_Dow PD with(nolock) on Replace(dbo.FRemoveCaracteresEspeciais(TP.REMETENTE_CNPJ_CPF),'.','') = PD.Tax_Number_1
join PO_HEA T04 on T10.Num_Proc_HEA = T04.Num_Proc_HEA and T04.ID_DC = '4'
join LLP_exp_Aer LLP with(nolock) on T10.Num_Proc_HEA = LLP.num_proc_leA 
join Localidade DST with(nolock)  on LLP.Cd_DstFinal_Lea = DST.Cd_Local
--join Tipo_Moeda TM with(nolock)  on LLP.Cd_Moeda_Invoice = TM.Cd_Tp_Moeda
where  T10.Num_Proc_HEA = @Num_Proc and right('0000000000' +T10.Numero_PO_HEA,10) =right('0000000000' +@NF,10) and TP.MERCADORIA_CODIGO <> '' --and SUBSTRING(T10.Num_Proc_HEA,3,3) in ('CSR')
union all

select 
distinct
	@ID  ID,
	T10.Num_Proc_HEO  Num_Proc,
	PD.Co_Code  Codigo_Empresa,
	PD.Business_Place  Codigo_Filial,
	TP.SERIE_SUBSERIE  Serie_Nota_Fiscal,
	TP.NUMERO_NOTA_FISCAL  Numero_Nota_Fiscal,
	replace(convert(varchar(10),T10.Data_PO_HEO,103),'/','')   Data_Emissao,
	left(T04.Numero_PO_HEO,15)  Numero_RE,
	TP.MERCADORIA_CODIGO  Codigo_Produto,
	NULL  Tipo_Conhecimento_Transporte,
	NULL  Relacionamento,
	NULL  Data_RE,
	NULL  Declaracao_Exportacao,
	NULL  Data_Declaracao_Exportacao,
	NULL  Status_Averbacao,
	NULL  Conhecimento_Embarque,
	replace(convert(varchar(10),LLP.ATD_Leo,103),'/','')  Data_Conhecimento_Embarque,
	DST.Cd_Pais  Codigo_do_Pais,
	NULL  Comprovante_Exportacao,
	NULL  Data_Comprovante_Exportacao,
	NULL  Modelo_documento,
	NULL  Natureza_Exportacao,
	NULL  Data_Averbacao_DE,
	NULL  Tipo_Declaracao,
	NULL  Chave_NFe,
	LLP.Cd_Moeda_Invoice  Moeda,
	'BDP/'+replace(convert(varchar(10),getdate(),103),'/','')  OpenFlex_01,
	NULL  OpenFlex_02,
	NULL  OpenFlex_03,
	NULL  OpenFlex_04,
	NULL  OpenFlex_05,
	NULL  OpenFlex_06,
	NULL  OpenFlex_07,
	NULL  OpenFlex_08
	--,Replace(dbo.FRemoveCaracteresEspeciais(TP.Informante_CNPJ_CPF),'.','')
from Transf_Price_DOW_EXP_2015 TP
join PO_HEO T10 on right('0000000000' +TP.NUMERO_NOTA_FISCAL,10) = right('0000000000' +T10.Numero_PO_HEO,10) and ID_DC = '10'
join PO_HEO T04 on T10.Num_Proc_HEO = T04.Num_Proc_HEO and T04.ID_DC = '4'
join Plantas_Dow PD with(nolock) on Replace(dbo.FRemoveCaracteresEspeciais(TP.REMETENTE_CNPJ_CPF),'.','') = PD.Tax_Number_1
join LLP_exp_out LLP with(nolock) on T10.Num_Proc_HEO = LLP.num_proc_leo 
join Localidade DST with(nolock)  on LLP.Cd_DstFinal_Leo = DST.Cd_Local
--join Tipo_Moeda TM with(nolock)  on LLP.Cd_Moeda_Invoice = TM.Cd_Tp_Moeda
where  T10.Num_Proc_HEO = @Num_Proc and right('0000000000' +T10.Numero_PO_HEO,10) =right('0000000000' +@NF,10) and TP.MERCADORIA_CODIGO <> '' --and SUBSTRING(T10.Num_Proc_HEO,3,3) in ('CSR')


insert INTO  Transf_Price_TXT_EXP
select 
ID,
Num_Proc,
dbo.PreencheStringDireita(Codigo_Empresa,9,' '),
dbo.PreencheStringDireita(Codigo_Filial,9,' '),
dbo.PreencheStringDireita(Serie_Nota_Fiscal,5,' '),
dbo.PreencheStringDireita(Numero_Nota_Fiscal,15,' '),
dbo.PreencheStringDireita(Data_Emissao,8,' '),
dbo.PreencheStringDireita(Numero_RE,15,' '),
dbo.PreencheStringV2(Codigo_Produto,18,'0'),
dbo.PreencheStringDireita(Tipo_Conhecimento_Transporte,2,' '),
dbo.PreencheString(Relacionamento,2,'0'),
dbo.PreencheStringDireita(Data_RE,8,' '),
dbo.PreencheStringDireita(Declaracao_Exportacao,15,' '),
dbo.PreencheStringDireita(Data_Declaracao_Exportacao,8,' '),
dbo.PreencheStringDireita(Status_Averbacao,1,' '),
dbo.PreencheStringDireita(Conhecimento_Embarque,18,' '),
dbo.PreencheStringDireita(Data_Conhecimento_Embarque,8,' '),
dbo.PreencheStringDireita(Codigo_Pais,4,' '),
dbo.PreencheStringDireita(Comprovante_Exportacao,8,' '),
dbo.PreencheStringDireita(Data_Comprovante_Exportacao,8,' '),
dbo.PreencheStringDireita(Modelo_documento,3,' '),
dbo.PreencheStringDireita(Natureza_Exportacao,1,' '),
dbo.PreencheStringDireita(Data_Averbacao_DE,8,' '),
dbo.PreencheStringDireita(Tipo_Declaracao,1,' '),
dbo.PreencheStringDireita(Chave_NFe,44,' '),
dbo.PreencheStringDireita(Moeda,10,' '),
dbo.PreencheStringDireita(OpenFlex_01,12,' '),
dbo.PreencheStringDireita(OpenFlex_02,150,' '),
dbo.PreencheStringDireita(OpenFlex_03,150,' '),
dbo.PreencheStringDireita(OpenFlex_04,150,' '),
dbo.PreencheStringDireita(OpenFlex_05,150,' '),
dbo.PreencheString(OpenFlex_06,17,'0'),
dbo.PreencheString(OpenFlex_07,17,'0'),
dbo.PreencheString(OpenFlex_08,17,'0')
from @Temp

--select  Replace(dbo.FRemoveCaracteresEspeciais(TP.Informante_CNPJ_CPF),'.','') ,PD.Tax_Number_1,*  from Transf_Price_DOW_EXP TP
--join Plantas_Dow PD with(nolock) on Replace(dbo.FRemoveCaracteresEspeciais(TP.Informante_CNPJ_CPF),'.','') = PD.Tax_Number_1


--select * from Transf_Price_DOW_EXP
--select Cd_Pais, * from LLP_exp_out LLP
--join Localidade DST with(nolock)  on LLP.Cd_DstFinal_Leo = DST.Cd_Local
--where Num_Proc_Leo = 'EOCSR201312041BR'

--select * from pais

/*

sp_help Transf_Price_TXT_EXP
select 
Codigo_Empresa +
Codigo_Filial +
Serie_Nota_Fiscal +
Numero_Nota_Fiscal +
Data_Emissao +
Numero_RE +
Codigo_Produto +
Tipo_Conhecimento_Transporte +
Relacionamento +
Data_RE +
Declaracao_Exportacao +
Data_Declaracao_Exportacao +
Status_Averbacao +
Conhecimento_Embarque +
Data_Conhecimento_Embarque +
Codigo_Pais +
Comprovante_Exportacao +
Data_Comprovante_Exportacao +
Modelo_de_documento +
Natureza_Exportacao +
Data_Averbacao_DE +
Tipo_Declaracao +
Chave_NFe +
Moeda +
OpenFlex_01 from
Transf_Price_TXT_EXP
*/
GO
