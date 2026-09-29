SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spSpedImp_Rel]
		@Num_Proc	VarChar(16),
		@Num_Nf		Varchar(30)

as

select 
	intDigitoControle,
	IntNAleatorio,
	IntNLog,sum(peso_liquido) Peso_L,
	sum(peso_bruto) Peso_B,
	dbo.fBusca_TipoDocCliente ('N',nc.num_proc,1) Num_Pedido,
	sum(vl_ii) Valor_II,
	sum(vl_imposto_cofins) Cofins,
	sum(vl_imposto_pis) PIS,
	CFOP,
	nota_fiscal,
	emissao,
	id_item Item_NF,
	Serie,
	getdate() DtLancamento,
	dt_conclusao dtEntrada,
	CNPJ,
	dbo.fBusca_TipoDocCliente ('N',nc.num_proc,5) DI_Number,
	dbo.fBusca_Tarefa(nc.num_proc,4) DtDesembaraco

from nota_cliente NC with(nolock)
	Join Nota_Fiscal_Cliente_Det NDD with(nolock) on NC.id_nf=NDD.id_nf and NC.cd_cliente=NDD.cd_cliente
	Join Tarefas_Processos TP with(nolock) on TP.num_proc=nc.num_proc and id_task=13
Where
	nc.num_proc=@num_proc and nota_fiscal=@num_nf	
group by 
	CFOP,
	nota_fiscal,
	emissao,
	id_item,
	Serie,
	dt_conclusao,
	CNPJ,
	dbo.fBusca_TipoDocCliente ('N',nc.num_proc,5),
	dbo.fBusca_Tarefa(nc.num_proc,4),
	dbo.fBusca_TipoDocCliente ('N',nc.num_proc,1),
	intDigitoControle,IntNAleatorio,IntNLog




GO
