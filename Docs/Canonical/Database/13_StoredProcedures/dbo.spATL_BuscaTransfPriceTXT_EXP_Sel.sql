SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BuscaTransfPriceTXT_EXP_Sel]
as

Declare @JOB varchar(16)
Declare @NF varchar(50)
Declare C_JOBs cursor for
--select distinct T10.Num_Proc_HEM from Transf_Price_DOW_EXP TP with(nolock) 
--join PO_HEM T10 with(nolock)  on right('0000000000' +TP.NUMERO_NOTA_FISCAL,10) = right('0000000000' +T10.Numero_PO_HEM,10) and ID_DC = '10'
--join Plantas_Dow PD with(nolock) on Replace(dbo.FRemoveCaracteresEspeciais(TP.Informante_CNPJ_CPF),'.','') = PD.Tax_Number_1
--join PO_HEM T04 with(nolock)  on T10.Num_Proc_HEM = T04.Num_Proc_HEM and T04.ID_DC = '4'
--join LLP_exp_Mar LLP with(nolock) on T10.Num_Proc_HEm = LLP.num_proc_lem
--join Localidade DST with(nolock)  on LLP.Cd_DstFinal_Lem = DST.Cd_Local
----join Tipo_Moeda TM with(nolock)  on LLP.Cd_Moeda_Invoice = TM.Cd_Tp_Moeda
--where  SUBSTRING(T10.Num_Proc_HEM,3,3) in ('CSR','ROB') and YEAR(T10.Data_PO_HEM) = 2014

select distinct HOU.Num_proc, PO.Numero_NF from vwHouse_Exp HOU
join dbo.vwPO_Exp PO with(nolock) on HOU.Num_Proc = PO.Num_Proc 
where  SUBSTRING(HOU.Num_Proc,1,1) ='E' and SUBSTRING(HOU.Num_Proc,3,3) in ('CSR','ROB') and YEAR(PO.Data_NF) = 2015 and ID_Status <> 9
Open C_JOBs 
SET NOCOUNT ON
Fetch Next From C_JOBS Into @JOB, @NF
	While @@FETCH_STATUS = 0
		Begin
Print @JOB
Print @NF
exec spATL_TransfPriceTXT_EXP_SelIns @JOB, @NF

			Fetch Next From C_JOBS Into @JOB, @NF
		End
close C_JOBS
deallocate C_JOBS

/*
select 
Codigo_Empresa+
Codigo_Filial+
Serie_Nota_Fiscal+
Numero_Nota_Fiscal+
Data_Emissao+
Numero_RE+
Codigo_Produto+
Tipo_Conhecimento_Transporte+
Relacionamento+
Data_RE+
Declaracao_Exportacao+
Data_Declaracao_Exportacao+
Status_Averbacao+
Conhecimento_Embarque+
Data_Conhecimento_Embarque+
Codigo_Pais+
Comprovante_Exportacao+
Data_Comprovante_Exportacao+
Modelo_de_documento+
Natureza_Exportacao+
Data_Averbacao_DE+
Tipo_Declaracao+
Chave_NFe+
Moeda+
OpenFlex_01+
OpenFlex_02+
OpenFlex_03+
OpenFlex_04+
OpenFlex_05+
OpenFlex_06+
OpenFlex_07+
OpenFlex_08
from Transf_Price_TXT_EXP
*/
GO
