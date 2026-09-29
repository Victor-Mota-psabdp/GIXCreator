SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSpecoCostReport_Sel] --spSpecoCostReport_Sel '2020-01-01','2020-01-31'
	@DataInicial Datetime,
	@DataFinal	Datetime
AS


Declare @Output Table
	(
	MES VARCHAR(30),
	SBU VARCHAR(50),
	PO varchar(160),
	Ref_Despachante varchar(40),
	Categoria Varchar(40),
	Descricao	Varchar(100),
	DataPagamento datetime,
	Moeda	Varchar(5),
	Valor	Decimal(10,2),
	Credor_Despesas varchar(150),
	NRO_DI		Varchar(440),
	Terminal	Varchar(450),
	CD_TP_TX	VARCHAR(3)

	)


insert @Output
SELECT 
		month(dt_conclusao) MES,
		Num_CPF_CNPJ SBU,
		[dbo].[fBusca_Docs_PO_Modal](hou.num_proc,1) [Ref Processo],
		Hou.Num_Proc [REF DESPACHANTE],
		'' Categoria, 
		Nome_tp_Tx [Descricao Despesas],
		Null DataPagamento,
		'REAL' Moeda, 
		Sum(Vlr_Item_Custo) [Valor Real],
		Null NumeroDI,
		Null Credor,
		Nome_Terminal Terminal,
		cC.CD_TP_TX 

FROM vwHouse_Imp HOU
	Join TarefaS_processos TP with(nolock) on TP.id_task=4 and hou.Num_Proc=TP.num_proc
	Join Pessoa PP  with(nolock) on pp.cd_pes=Cd_Consig
	Join Custo_Cliente CC  with(nolock) on CC.num_proc=hou.num_proc
	Join Tipo_Taxa TT with(nolock)  on tt.cd_tp_Tx=cc.cd_tp_Tx
--	Join vwcxas CXA with(nolock)  on hou.num_proc=cc.num_proc and cxa.cd_tp_Tx=Cc.cd_tp_Tx and cxa.dc_hia='D'
--	Join PO_HIM DI with(nolock)  on hou.num_proc=di.Num_Proc_HIM and DI.id_dc=5
	Left Join Terminal T on Hou.Cd_Terminal=t.Cd_Terminal	
WHERE 
	HOU.NUM_PROC LIKE '%SPC%'
	and dt_conclusao between @DataInicial and @DataFinal and Nome_tp_tx not in ('VALOR DOS ACRÉSCIMOS (DI)','FOB CHARGES','Seguro','Frete (consta na DI)')
group by 
	month(dt_conclusao),Num_CPF_CNPJ,[dbo].[fBusca_Docs_PO_Modal](hou.num_proc,2),
 Nome_tp_Tx ,hou.num_proc ,cC.CD_TP_TX ,Nome_Terminal

Update
	@Output
	Set DataPagamento=dt_conclusao
from
	@Output O
	Join Tarefas_processos TP with(nolock) on TP.Num_Proc=O.Ref_Despachante and id_task=25
where
	DataPagamento is null and dt_conclusao is not null and O.Descricao like 'AFRMM%'


	
Update
	@Output
	Set NRO_DI=	dbo.fBusca_TipoDocCliente('N',Ref_Despachante,5)

 Update @Output
	Set Categoria='ARMAZENAGEM'
WHERE 
	DESCRICAO LIKE 'Armazenagem%'

 Update @Output
	Set Categoria='IMPOSTOS'
WHERE 
	DESCRICAO IN ('Imposto de Importação - CHB','Cofins - CHB','IPI - CHB','ICMS - CHB','PIS - CHB','Taxas Siscomex - CHB')

Update @Output
	Set Categoria='DESPACHO'
WHERE 
	DESCRICAO LIKE 'Serviços Prestados %'

Update @Output
	Set Categoria='OUTRAS'
WHERE 
	Categoria=''

	Update @Output
	Set Credor_Despesas='BANCO DO BRASIL'
WHERE 
	Descricao LIKE 'AFRMM%'

Update @Output
	Set DataPagamento=convert(datetime,Dt_Pgto_Rcto_HIA,105)
FROM @Output O
	jOIN VWCXAS CXA ON CXA.Num_Proc_HIA=O.Ref_Despachante AND O.CD_TP_TX=cxa.Cd_Tp_Tx and cxa.DC_HIA='D'
WHERE 
	DataPagamento is null 

Update @Output
	 	Set Credor_Despesas=Nome_Raz_Soc
FROM @Output O
	jOIN vwcta_cte cta ON cta.Num_Proc_HIA=O.Ref_Despachante AND O.CD_TP_TX=cta.Cd_Tp_Tx and cta.DC_HIA='D'
	Join Pessoa PP with(nolock) on pp.cd_pes=Cd_Cred_Dev_HIA
WHERE 
	Credor_Despesas is null 	

Update @Output
	 	Set Credor_Despesas='BDP SOUTH AMERICA LTDA'
FROM @Output O
	jOIN vwcta_cte cta ON cta.Num_Proc_HIA=O.Ref_Despachante AND O.CD_TP_TX=cta.Cd_Tp_Tx and cta.DC_HIA='C'
	
WHERE 
	Credor_Despesas is null 	AND Num_NF_HIA IS NOT NULL 


Update @Output
	 	Set Credor_Despesas='MINISTERIO DA FAZENDA'
WHERE 
	Credor_Despesas is null 	

--Data = Data de Pagamento de Impostos
Update
	@Output
	Set DataPagamento=	dbo.fBusca_TipoDocCliente('D',Ref_Despachante,5)
where
	DataPagamento is null and Credor_Despesas ='MINISTERIO DA FAZENDA'
---End Data = Data de Pagamento de Impostos

--Atualiza Descricao
	Update
		@Output
			Set Descricao = replace(replace(descricao,'CHB',''),'-',' ') 
---MONTH
	Update
		@Output
			Set Mes=
					(case
						When Mes=1 then 'Jan'
						When Mes=2 then 'Fev'
						When Mes=3 then 'Mar'
						When Mes=4 then 'Abr'
						When Mes=5 then 'Mai'
						When Mes=6 then 'Jun'
						When Mes=7 then 'Jul'
						When Mes=8 then 'Ago'
						When Mes=9 then 'Set'
						When Mes=10 then 'Oct'
						When Mes=11 then 'Nov'
						else 'Dec'
					End)

Select 
	MES ,
	SBU ,
	PO [Ref Processo] ,
	Ref_Despachante [Ref Despachante],
	Categoria ,
	Descricao [Descrição Despesa],
	DataPagamento [Data Pagamento],
	Moeda	,
	Valor	,
	Credor_Despesas [Credor Despesa],
	NRO_DI		,
	Terminal	

from @Output
GO
