SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CNPJ/ fornecedor /Data do lançamento/Usuário/ e Filial
--select * from Sol_Pgto_Cta_Cte where Doc_Register = 'S'


--spATL_Registro_FinanceiroDet_Rel

CREATE Procedure [dbo].[spATL_Registro_Financeiro_NEW_Rel]--11,'2015'
	@Mes varchar(30),
	@Ano varchar(30)
AS

select 
	S.Mes					[Mes],
	S.Ano					[Ano],
	S.Num_Registro			[Numero do Registro],
	S.Doc_Number			[Numero do Documento],
	S.Dt_IssueDate			[Data do Documento],
	S.Dt_Vcto				[Data de Vencimento],	
	PP.APELIDO				[Apelido],
	PP.Nome_Raz_Soc			[Fornecedor],
	I.num_proc				[Job],
	TT.Nome_tp_Tx			[Taxa],
	I.DC					[DC],
	I.CD_TP_MOEDA			[Moeda],
	I.Vlr_Pgto_Rcto			[Valor],
	AX.Cd_Ax				[Codigo AX],
	
	PP.Num_CPF_CNPJ			[CNPJ],
	U.nome_usuario			[Usuario],
	S.Dt_Ins				[Data do Lancamento],
	S.Ref_Acesso			[Invoice Type],
	E.Nome_Site				[Invoice Type Name],
	S.cd_servico			[Service Code],
	T.Descricao				[Service Code Descrição],
	S.ID					[Numero do Registro]	

--from 
	--registro_financeiro_item RFI with(nolock)
	--Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro
	--Join Tipo_Taxa TT on TT.cd_tp_Tx=RFI.cd_tp_Tx
	--left join Site E on E.Cd_Site = RF.Ref_Acesso
	--left join Tipo_NF_Doc_Register T on T.cd_site = RF.Ref_Acesso and T.cd_servico = RF.cd_servico
	--left join Sol_Pgto_Cta_Cte S with(nolock) on S.mes=RFI.mes and S.ano=rfi.ano and S.num_registro=RF.num_registro
from Sol_Pgto_Cta_Cte S
	Join Sol_Pgto_Cta_Cte_Item I on I.ID = S.ID
	Join Tipo_Taxa TT on TT.cd_tp_Tx=I.cd_tp_Tx
	Join Pessoa PP on pp.cd_pes=S.Cd_cred_dev
	Left Join Pessoa_ATL_AX AX on AX.cd_pes=PP.cd_pes and Tipo='F'
	left join usuario U on U.cd_usuario = S.cd_solicitante
	left join Site E on E.Cd_Site = S.Ref_Acesso
	left join Tipo_NF_Doc_Register T on T.cd_site = S.Ref_Acesso and T.cd_servico = S.cd_servico
	--left join Tipo_Doc_RF R on R.Cd_Tipo_Doc_RF = S.Cd_Tp_Doc_RF
	--left join Tipo_Lancamento_RF L on L.Cd_Tipo_Lanc = S.Cd_Tipo_Lanc
	
Where
	 --RF.mes=@Mes and RF.ano=@Ano
	 S.mes=@Mes and S.Ano=@Ano
	 and S.Doc_Register = 'S'
	 and S.Status = 1
	 And Status_Aprovacao = 'A'
	 
--select * from Sol_Pgto_Cta_Cte where Doc_Register = 'S'
--select * from Sol_Pgto_Cta_Cte_Item

/*	 
ALTER Procedure [dbo].[spATL_Registro_FinanceiroDet_Rel]--'12','2015'
	@Mes varchar(30),
	@Ano varchar(30)
AS

select 
	RF.Mes,RF.Num_Registro,Doc_Number ,
	dt_ins [Data do Documento],
	dt_venc [Data de Vencimento] ,
	APELIDO,
	RFI.num_proc [Job],
	Nome_tp_Tx [Taxa],
	RFI.DC,
	CD_TP_MOEDA Moeda,
	RFI.Valor,
	AX.Cd_Ax [Codigo AX]
	--,PP.Num_CPF_CNPJ [CNPJ]
from 
	registro_financeiro_item RFI with(nolock)
	Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro
	left join Sol_Pgto_Cta_Cte S on S.mes=RFI.mes and S.ano=rfi.ano and S.num_registro=RF.num_registro
	Join Tipo_Taxa TT on TT.cd_tp_Tx=RFI.cd_tp_Tx
	Join Pessoa PP on pp.cd_pes=Rf.cd_pes
	Left Join Pessoa_ATL_AX AX on AX.cd_pes=PP.cd_pes and Tipo='F'
Where
	 RF.mes=@mes and RF.ano=@ano	and ativo = 1'
	 
	 */
GO
