SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_SalesOrderResponse_Sel]--'CSR','Faturamento','z'
(
	@ID_SalesOrderResponse	bigint,
	@sales_order			varchar(200),
	@Tipo					char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			ID_SalesOrderResponse [Internal Code],
			sales_order,seller,data_recebimento_processo,data_carregamento,doc_embarque,buyer_consignee,destination_country,
			[type],peso_liquido_total,peso_bruto_total,dt_ins [Received Date]
			,Message, Dt_Ins_JOB,Num_Proc,
			incoterm,moeda,inland_trucker,agent,viagem,navio,modal,terminal,porto_embarque,porto_destino,due,data_due
		from 
			ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
			select 
			ID_SalesOrderResponse [Internal Code],
			sales_order,seller,data_recebimento_processo,data_carregamento,doc_embarque,buyer_consignee,destination_country,
			[type],peso_liquido_total,peso_bruto_total,dt_ins [Received Date]
			,Message, Dt_Ins_JOB,Num_Proc,
			incoterm,moeda,inland_trucker,agent,viagem,navio,modal,terminal,porto_embarque,porto_destino,due,data_due
		from 
			ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse with(nolock)
		where 
			ID_SalesOrderResponse = @ID_SalesOrderResponse
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
			select 
			ID_SalesOrderResponse [Internal Code],
			sales_order,seller,data_recebimento_processo,data_carregamento,doc_embarque,buyer_consignee,destination_country,
			[type],peso_liquido_total,peso_bruto_total,dt_ins [Received Date]
			,Message, Dt_Ins_JOB,Num_Proc,
			incoterm,moeda,inland_trucker,agent,viagem,navio,modal,terminal,porto_embarque,porto_destino,due,data_due
		from 
			ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse with(nolock)
		where 
			sales_order = @sales_order
	End

if @Tipo = 'P'
	Begin
			select 
			ID_SalesOrderResponse [Internal Code],
			sales_order,seller,data_recebimento_processo,data_carregamento,doc_embarque,buyer_consignee,destination_country,
			[type],peso_liquido_total,peso_bruto_total,dt_ins [Received Date]
			,Message, Dt_Ins_JOB,Num_Proc,
			incoterm,moeda,inland_trucker,agent,viagem,navio,modal,terminal,porto_embarque,porto_destino,due,data_due
		from 
			ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse with(nolock)
		Where
			Dt_Ins_JOB is null and NUm_proc is not null
	
	End

if @Tipo = 'I' --usada na tela do Integrated Received
	Begin
		select 
			ID_SalesOrderResponse [Internal Code],
			sales_order,seller,data_recebimento_processo,data_carregamento,doc_embarque,buyer_consignee,destination_country,
			[type],peso_liquido_total,peso_bruto_total,dt_ins [Received Date]
			,Message, Dt_Ins_JOB,Num_Proc,
			incoterm,moeda,inland_trucker,agent,viagem,navio,modal,terminal,porto_embarque,porto_destino,due,data_due
		from 
			ATL_INT.dbo.JSON_Oxiteno_SalesOrderResponse with(nolock)
		Where
			dt_ins > getdate() -1
	End

GO
